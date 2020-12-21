//
//  UICollectionView+ReloadStrategy.swift
//  Artisan
//
//  Created by Nayanda Haberty (ID) on 15/09/20.
//

import Foundation
import UIKit

extension UICollectionView.Mediator {
    
    func reload(
        _ collectionView: UICollectionView,
        with sections: [UICollectionView.Section],
        oldSections: [UICollectionView.Section],
        completion: ((Bool) -> Void)?) {
        guard dataIsValid(collectionView, oldData: oldSections) else {
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                completion?(true)
            }
            collectionView.reloadData()
            CATransaction.commit()
            return
        }
        switch self.reloadStrategy {
        case .reloadAll:
            reloadAll(collectionView, with: sections, oldSections: oldSections, completion: completion)
            return
        case .reloadLinearDifferences:
            reloadBatch(for: collectionView, with: sections, oldSections: oldSections, reloader: {
                linearReloadCell(for: collectionView, $0, with: $1, sectionIndex: $2)
            }, completion: completion)
        case .reloadArangementDifferences:
            reloadBatch(for: collectionView, with: sections, oldSections: oldSections, reloader: {
                arrangeReloadCell(for: collectionView, $0, with: $1, sectionIndex: $2)
            }, completion: completion)
        }
    }
    
    func reloadAll(
        _ collectionView: UICollectionView,
        with sections: [UICollectionView.Section],
        oldSections: [UICollectionView.Section],
        completion: ((Bool) -> Void)?) {
        collectionView.performBatchUpdates({
            let oldCount = max(oldSections.count, 1)
            let newCount = max(sections.count, 1)
            let reloaded = min(oldCount, newCount)
            collectionView.reloadSections(
                getIndexSet(from: 0, to: reloaded)
            )
            if newCount > oldCount {
                collectionView.insertSections(
                    getIndexSet(from: oldCount, to: newCount)
                )
            } else if oldCount > newCount {
                collectionView.deleteSections(
                    getIndexSet(from: newCount, to: oldCount)
                )
            }
        }, completion: completion)
    }
    
    func reloadBatch(
        for collectionView: UICollectionView,
        with sections: [UICollectionView.Section],
        oldSections: [UICollectionView.Section],
        reloader: (UICollectionView.Section, UICollectionView.Section, Int) -> Void,
        completion: ((Bool) -> Void)?) {
        collectionView.performBatchUpdates({
            verifyLinearity(
                for: collectionView,
                with: sections,
                oldSections: oldSections,
                whenSameSection: reloader
            )
            if sections.count > oldSections.count {
                collectionView.insertSections(
                    getIndexSet(from: oldSections.endIndex, to: sections.endIndex)
                )
            } else if oldSections.count > sections.count {
                collectionView.deleteSections(
                    getIndexSet(from: sections.endIndex, to: oldSections.endIndex)
                )
            }
        }, completion: completion)
    }
    
    func linearReloadCell(
        for collectionView: UICollectionView,
        _ oldSection: UICollectionView.Section,
        with newSection: UICollectionView.Section,
        sectionIndex: Int) {
        collectionView.reloadItems(
            at: getIndexPath(
                from: 0,
                to: min(newSection.cells.endIndex, oldSection.cells.endIndex),
                section: sectionIndex
            )
        )
        if oldSection.cells.count > newSection.cells.count {
            collectionView.deleteItems(
                at: getIndexPath(
                    from: newSection.cells.endIndex,
                    to: oldSection.cells.endIndex,
                    section: sectionIndex
                )
            )
        } else if oldSection.cells.count < newSection.cells.count {
            collectionView.insertItems(
                at: getIndexPath(
                    from: oldSection.cells.endIndex,
                    to: newSection.cells.endIndex,
                    section: sectionIndex
                )
            )
        }
    }
    
    func arrangeReloadCell(
        for collectionView: UICollectionView,
        _ oldSection: UICollectionView.Section,
        with newSection: UICollectionView.Section,
        sectionIndex: Int) {
        let newCells = newSection.cells
        var oldCellsArranged = compareOldAndNewForRemove(
            for: collectionView,
            old: oldSection.cells,
            new: newCells,
            sectionIndex: sectionIndex
        )
        for (index, newCell) in newCells.enumerated() {
            let indexPath: IndexPath = .init(row: index, section: sectionIndex)
            guard let oldCell = oldCellsArranged[safe: index] else {
                collectionView.insertItems(
                    at: [indexPath]
                )
                oldCellsArranged.insert(newCell, at: index)
                continue
            }
            guard newCell.isNotSameMediator(with: oldCell) else {
                continue
            }
            if let oldIndex = oldCellsArranged.firstIndex(where: { $0.isSameMediator(with: newCell) }) {
                collectionView.moveItem(
                    at: .init(row: oldIndex, section: sectionIndex),
                    to: .init(row: index, section: sectionIndex)
                )
                oldCellsArranged.remove(at: oldIndex)
                oldCellsArranged.insert(newCell, at: index)
            } else {
                collectionView.insertItems(at: [indexPath])
                oldCellsArranged.insert(newCell, at: index)
            }
        }
    }
    
    func compareOldAndNewForRemove(
        for collectionView: UICollectionView,
        old oldCells: [CollectionCellMediator],
        new newCells: [CollectionCellMediator],
        sectionIndex: Int) -> [CollectionCellMediator] {
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
            collectionView.deleteItems(at: removedIndexes)
            var oldCellAfterDelete: [CollectionCellMediator] = []
            for index in keepedIndexes {
                guard let oldCell = oldCells[safe: index] else { continue }
                oldCellAfterDelete.append(oldCell)
            }
            return oldCellAfterDelete
        }
        return oldCells
    }
    
    func dataIsValid(_ collectionView: UICollectionView, oldData: [UICollectionView.Section]) -> Bool {
        guard collectionView.numberOfSections == oldData.count else { return false }
        for (section, cells) in oldData.enumerated() {
            guard collectionView.numberOfItems(inSection: section) == cells.cellCount else { return false }
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
        for collectionView: UICollectionView,
        with sections: [UICollectionView.Section],
        oldSections: [UICollectionView.Section],
        whenSameSection: (UICollectionView.Section, UICollectionView.Section, Int) -> Void) {
        for (sectionIndex, oldSection) in oldSections.enumerated() where sections.count > sectionIndex {
            let newSection = sections[sectionIndex]
            guard newSection.isSameSection(with: oldSection) else {
                collectionView.reloadSections(.init(arrayLiteral: sectionIndex))
                continue
            }
            whenSameSection(oldSection, newSection, sectionIndex)
        }
    }
}
