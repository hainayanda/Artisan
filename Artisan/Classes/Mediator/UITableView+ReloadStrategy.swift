//
//  UITableView+ReloadStrategy.swift
//  Artisan
//
//  Created by Nayanda Haberty (ID) on 15/09/20.
//

import Foundation
import UIKit

extension UITableView.Mediator {
    
    func reload(
        _ tableView: UITableView,
        with sections: [UITableView.Section],
        oldSections: [UITableView.Section],
        completion: ((Bool) -> Void)?) {
        guard dataIsValid(tableView, oldData: oldSections) else {
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                completion?(true)
            }
            tableView.reloadData()
            CATransaction.commit()
            return
        }
        switch self.reloadStrategy {
        case .reloadAll:
            reloadAll(tableView, with: sections, oldSections: oldSections, completion: completion)
            return
        case .reloadLinearDifferences:
            reloadBatch(for: tableView, with: sections, oldSections: oldSections, reloader: {
                linearReloadCell(for: tableView, $0, with: $1, sectionIndex: $2)
            }, completion: completion)
        case .reloadArangementDifferences:
            reloadBatch(for: tableView, with: sections, oldSections: oldSections, reloader: {
                arrangeReloadCell(for: tableView, $0, with: $1, sectionIndex: $2)
            }, completion: completion)
        }
    }
    
    func reloadAll(
        _ tableView: UITableView,
        with sections: [UITableView.Section],
        oldSections: [UITableView.Section],
        completion: ((Bool) -> Void)?) {
        tableView.beginUpdates()
        let oldCount = max(oldSections.count, 1)
        let newCount = max(sections.count, 1)
        let reloaded = min(oldCount, newCount)
        tableView.reloadSections(
            getIndexSet(from: 0, to: reloaded),
            with: reloadSectionAnimation
        )
        if newCount > oldCount {
            tableView.insertSections(
                getIndexSet(from: oldCount, to: newCount),
                with: insertSectionAnimation
            )
        } else if oldCount > newCount {
            tableView.deleteSections(
                getIndexSet(from: newCount, to: oldCount),
                with: deleteSectionAnimation
            )
        }
        tableView.endUpdates()
        completion?(true)
    }
    
    func reloadBatch(
        for tableView: UITableView,
        with sections: [UITableView.Section],
        oldSections: [UITableView.Section],
        reloader: (UITableView.Section, UITableView.Section, Int) -> Void,
        completion: ((Bool) -> Void)?) {
        tableView.beginUpdates()
        defer {
            tableView.endUpdates()
            completion?(true)
        }
        verifyLinearity(
            for: tableView,
            with: sections,
            oldSections: oldSections,
            whenSameSection: reloader
        )
        if sections.count > oldSections.count {
            tableView.insertSections(
                getIndexSet(from: oldSections.endIndex, to: sections.endIndex),
                with: insertSectionAnimation
            )
        } else if oldSections.count > sections.count {
            tableView.deleteSections(
                getIndexSet(from: sections.endIndex, to: oldSections.endIndex),
                with: deleteSectionAnimation
            )
        }
    }
    
    func linearReloadCell(
        for tableView: UITableView,
        _ oldSection: UITableView.Section,
        with newSection: UITableView.Section,
        sectionIndex: Int) {
        verifyLinearity(
            for: tableView,
            with: newSection.cells,
            oldCells: oldSection.cells,
            sectionIndex: sectionIndex
        )
        if oldSection.cells.count > newSection.cells.count {
            tableView.deleteRows(
                at: getIndexPath(
                    from: newSection.cells.endIndex,
                    to: oldSection.cells.endIndex,
                    section: sectionIndex
                ),
                with: deleteRowAnimation
            )
        } else if oldSection.cells.count < newSection.cells.count {
            tableView.insertRows(
                at: getIndexPath(
                    from: oldSection.cells.endIndex,
                    to: newSection.cells.endIndex,
                    section: sectionIndex
                ),
                with: insertSectionAnimation
            )
        }
    }
    
    func arrangeReloadCell(
        for tableView: UITableView,
        _ oldSection: UITableView.Section,
        with newSection: UITableView.Section,
        sectionIndex: Int) {
        let newCells = newSection.cells
        var oldCellsArranged = compareOldAndNewForRemove(
            for: tableView,
            old: oldSection.cells,
            new: newCells,
            sectionIndex: sectionIndex
        )
        for (index, newCell) in newCells.enumerated() {
            let indexPath: IndexPath = .init(row: index, section: sectionIndex)
            guard let oldCell = oldCellsArranged[safe: index] else {
                tableView.insertRows(
                    at: [indexPath],
                    with: insertRowAnimation
                )
                oldCellsArranged.insert(newCell, at: index)
                continue
            }
            guard newCell.isNotSameMediator(with: oldCell) else {
                continue
            }
            if let oldIndex = oldCellsArranged.firstIndex(where: { $0.isSameMediator(with: newCell) }) {
                tableView.moveRow(
                    at: .init(row: oldIndex, section: sectionIndex),
                    to: .init(row: index, section: sectionIndex)
                )
                oldCellsArranged.remove(at: oldIndex)
                oldCellsArranged.insert(newCell, at: index)
            } else {
                tableView.insertRows(at: [indexPath], with: insertRowAnimation)
                oldCellsArranged.insert(newCell, at: index)
            }
        }
    }
    
    func compareOldAndNewForRemove(
        for tableView: UITableView,
        old oldCells: [TableCellMediator],
        new newCells: [TableCellMediator],
        sectionIndex: Int) -> [TableCellMediator] {
        var removedIndexes: [IndexPath] = []
        var keepedIndexes: [Int] = []
        for (index, oldCell) in oldCells.enumerated() {
            guard !newCells.contains(where: { $0.isSameMediator(with: oldCell) }) else {
                keepedIndexes.append(index)
                continue
            }
            removedIndexes.append(.init(row: index, section: sectionIndex))
        }
        if !removedIndexes.isEmpty {
            tableView.deleteRows(at: removedIndexes, with: deleteRowAnimation)
            var oldCellAfterDelete: [TableCellMediator] = []
            for index in keepedIndexes {
                guard let oldCell = oldCells[safe: index] else { continue }
                oldCellAfterDelete.append(oldCell)
            }
            return oldCellAfterDelete
        }
        return oldCells
    }
    
    func dataIsValid(_ tableView: UITableView, oldData: [UITableView.Section]) -> Bool {
        guard tableView.numberOfSections == oldData.count else { return false }
        for (section, cells) in oldData.enumerated() {
            guard tableView.numberOfRows(inSection: section) == cells.cellCount else { return false }
        }
        return true
    }
    
    func getIndexSet(from start: Int, to end: Int) -> IndexSet {
        guard start < (end - 1) else {
            return .init(arrayLiteral: start)
        }
        return .init(integersIn: start ..< end)
    }
    
    func getIndexPath(from start: Int, to end: Int, section: Int) -> [IndexPath] {
        guard start < (end - 1) else {
            return [.init(row: start, section: section)]
        }
        var indexPaths: [IndexPath] = []
        for index in start ..< end {
            indexPaths.append(.init(row: index, section: section))
        }
        return indexPaths
    }
    
    func verifyLinearity(
        for tableView: UITableView,
        with sections: [UITableView.Section],
        oldSections: [UITableView.Section],
        whenSameSection: (UITableView.Section, UITableView.Section, Int) -> Void) {
        for (sectionIndex, oldSection) in oldSections.enumerated() where sections.count > sectionIndex {
            let newSection = sections[sectionIndex]
            guard newSection.isSameSection(with: oldSection) else {
                tableView.reloadSections(.init(arrayLiteral: sectionIndex), with: reloadSectionAnimation)
                continue
            }
            whenSameSection(oldSection, newSection, sectionIndex)
        }
    }
    
    func verifyLinearity(
        for tableView: UITableView,
        with cells: [TableCellMediator],
        oldCells: [TableCellMediator],
        sectionIndex: Int) {
        var cellDifference: [IndexPath] = []
        var sameCells: [IndexPath] = []
        for (cellIndex, oldCell) in oldCells.enumerated() where cells.count > cellIndex {
            let newCell = cells[cellIndex]
            let indexPath: IndexPath = .init(row: cellIndex, section: sectionIndex)
            guard newCell.isSameMediator(with: oldCell) else {
                cellDifference.append(indexPath)
                continue
            }
            sameCells.append(indexPath)
        }
        if !sameCells.isEmpty {
            tableView.reloadRows(at: sameCells, with: .fade)
        }
        if !cellDifference.isEmpty {
            tableView.reloadRows(at: cellDifference, with: reloadRowAnimation)
        }
    }
}
