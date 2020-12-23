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
            reloadAll(collectionView: collectionView, completion)
            return
        }
        switch self.reloadStrategy {
        case .reloadAll:
            reloadAll(collectionView: collectionView, completion)
            return
        case .reloadArrangementDifference, .reloadArrangementDifferenceAndRefresh:
            reloadBatch(collectionView, with: sections, oldSections: oldSections, completion: completion)
        }
    }
    
    func reloadAll(collectionView: UICollectionView, _ completion: ((Bool) -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            completion?(true)
        }
        collectionView.reloadData()
        CATransaction.commit()
    }
    
    func reloadBatch(
        _ collectionView: UICollectionView,
        with sections: [UICollectionView.Section],
        oldSections: [UICollectionView.Section],
        completion: ((Bool) -> Void)?) {
        collectionView.performBatchUpdates({
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
                collectionView.deleteSections(.init(removedIndex))
            }
            for (sectionIndex, section) in sections.enumerated() {
                if let oldSection = mutableSection[safe: sectionIndex],
                   oldSection.isSameSection(with: section) {
                    reloadSection(collectionView, with: section, oldSections: oldSection, at: sectionIndex)
                } else if let realIndex = mutableSection.firstIndex(where: { $0.isSameSection(with: section)}) {
                    let removedSection = mutableSection.remove(at: realIndex)
                    mutableSection.insert(removedSection, at: sectionIndex)
                    collectionView.moveSection(realIndex, toSection: sectionIndex)
                    reloadSection(collectionView, with: section, oldSections: removedSection, at: sectionIndex)
                } else {
                    mutableSection.insert(section, at: sectionIndex)
                    collectionView.insertSections(.init([sectionIndex]))
                }
            }
        },
        completion: completion
        )
    }
    
    func reloadSection(
        _ collectionView: UICollectionView,
        with sections: UICollectionView.Section,
        oldSections: UICollectionView.Section,
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
            collectionView.deleteItems(at: removedIndex)
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
                collectionView.moveItem(at: oldIndexPath, to: newIndexPath)
                if reloadStrategy.shouldRefresh {
                    reloadedIndex.append(newIndexPath)
                }
            } else {
                mutableCells.insert(cell, at: cellIndex)
                collectionView.insertItems(at: [.init(row: cellIndex, section: index)])
            }
        }
        if !reloadedIndex.isEmpty {
            collectionView.reloadItems(at: reloadedIndex)
        }
    }
    
    func dataIsValid(_ collectionView: UICollectionView, oldData: [UICollectionView.Section]) -> Bool {
        guard collectionView.numberOfSections == oldData.count else { return false }
        for (section, cells) in oldData.enumerated() {
            guard collectionView.numberOfItems(inSection: section) == cells.cellCount else { return false }
        }
        return true
    }
}
