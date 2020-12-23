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
            reloadAll(tableView: tableView, completion)
            return
        }
        switch self.reloadStrategy {
        case .reloadAll:
            reloadAll(tableView: tableView, completion)
            return
        case .reloadArrangementDifference, .reloadArrangementDifferenceAndRefresh:
            reloadBatch(tableView, with: sections, oldSections: oldSections, completion: completion)
        }
    }
    
    func reloadAll(tableView: UITableView, _ completion: ((Bool) -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            completion?(true)
        }
        tableView.reloadData()
        CATransaction.commit()
    }
    
    func reloadBatch(
        _ tableView: UITableView,
        with sections: [UITableView.Section],
        oldSections: [UITableView.Section],
        completion: ((Bool) -> Void)?) {
        tableView.beginUpdates()
        defer {
            tableView.endUpdates()
            completion?(true)
        }
        var mutableSection = oldSections
        var removedIndex: [Int] = []
        var mutableIndex: Int = 0
        for (sectionIndex, oldSection) in oldSections.enumerated() {
            guard sections.contains(where: { $0.isSameSection(with: oldSection)} ) else {
                mutableSection.remove(at: mutableIndex)
                removedIndex.append(sectionIndex)
                continue
            }
            mutableIndex += 1
        }
        if !removedIndex.isEmpty {
            tableView.deleteSections(.init(removedIndex), with: animationSet.deleteSectionAnimation)
        }
        for (sectionIndex, section) in sections.enumerated() {
            if let oldSection = mutableSection[safe: sectionIndex],
               oldSection.isSameSection(with: section) {
                reloadSection(tableView, with: section, oldSections: oldSection, at: sectionIndex)
            } else if let realIndex = mutableSection.firstIndex(where: { $0.isSameSection(with: section)}) {
                let removedSection = mutableSection.remove(at: realIndex)
                mutableSection.insert(removedSection, at: sectionIndex)
                tableView.moveSection(realIndex, toSection: sectionIndex)
                reloadSection(tableView, with: section, oldSections: removedSection, at: sectionIndex)
            } else {
                mutableSection.insert(section, at: sectionIndex)
                tableView.insertSections(.init([sectionIndex]), with: animationSet.insertSectionAnimation)
            }
        }
    }
    
    func reloadSection(
        _ tableView: UITableView,
        with sections: UITableView.Section,
        oldSections: UITableView.Section,
        at index: Int) {
        let oldCells = oldSections.cells
        var mutableCells = oldCells
        let newCells = sections.cells
        var removedIndex: [IndexPath] = []
        var mutableIndex: Int = 0
        for (cellIndex, oldCell) in oldCells.enumerated() {
            guard newCells.contains(where: { $0.isSameMediator(with: oldCell)}) else {
                mutableCells.remove(at: mutableIndex)
                removedIndex.append(.init(row: cellIndex, section: index))
                continue
            }
            mutableIndex += 1
        }
        if !removedIndex.isEmpty {
            tableView.deleteRows(at: removedIndex, with: animationSet.deleteRowAnimation)
        }
        var reloadedIndex: [IndexPath] = []
        for (cellIndex, cell) in newCells.enumerated() {
            if let oldCell = mutableCells[safe: cellIndex],
               oldCell.isSameMediator(with: cell) {
                if reloadStrategy.shouldRefresh {
                    reloadedIndex.append(.init(row: cellIndex, section: index))
                }
            } else if let realIndex = mutableCells.firstIndex(where: { $0.isSameMediator(with: cell)}) {
                let removedCell = mutableCells.remove(at: realIndex)
                mutableCells.insert(removedCell, at: cellIndex)
                let oldIndexPath = IndexPath(row: realIndex, section: index)
                let newIndexPath = IndexPath(row: cellIndex, section: index)
                tableView.moveRow(at: oldIndexPath, to: newIndexPath)
                if reloadStrategy.shouldRefresh {
                    reloadedIndex.append(newIndexPath)
                }
            } else {
                mutableCells.insert(cell, at: cellIndex)
                tableView.insertRows(at: [.init(row: cellIndex, section: index)], with: animationSet.insertRowAnimation)
            }
        }
        if !reloadedIndex.isEmpty {
            tableView.reloadRows(at: reloadedIndex, with: animationSet.reloadRowAnimation)
        }
    }
    
    func dataIsValid(_ tableView: UITableView, oldData: [UITableView.Section]) -> Bool {
        guard tableView.numberOfSections == oldData.count else { return false }
        for (section, cells) in oldData.enumerated() {
            guard tableView.numberOfRows(inSection: section) == cells.cellCount else { return false }
        }
        return true
    }
}
