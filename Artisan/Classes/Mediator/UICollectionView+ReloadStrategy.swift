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
            let sectionReloader = CollectionMediatorSectionReloader(
                collection: collectionView,
                forceRefresh: reloadStrategy.shouldRefresh
            )
            let diffReloader = DiffReloader(worker: sectionReloader)
            diffReloader.reloadDifference(oldIdentities: oldSections, newIdentities: sections)
        }, completion: completion)
    }
    
    func dataIsValid(_ collectionView: UICollectionView, oldData: [UICollectionView.Section]) -> Bool {
        guard collectionView.numberOfSections == oldData.count else { return false }
        for (section, cells) in oldData.enumerated() {
            guard collectionView.numberOfItems(inSection: section) == cells.cellCount else { return false }
        }
        return true
    }
}

public struct CollectionMediatorSectionReloader: DiffReloaderWorker {
    let collection: UICollectionView
    let forceRefresh: Bool
    
    init(collection: UICollectionView, forceRefresh: Bool) {
        self.collection = collection
        self.forceRefresh = forceRefresh
    }
    
    public func diffReloader(_ diffReloader: DiffReloader, shouldRemove identifiables: [Int : Identifiable]) {
        collection.deleteSections(.init(identifiables.keys))
    }
    
    public func diffReloader(_ diffReloader: DiffReloader, shouldInsert identifiable: Identifiable, at index: Int) {
        collection.insertSections(.init(integer: index))
    }
    
    public func diffReloader(_ diffReloader: DiffReloader, shouldReload identifiables: [Int : (old: Identifiable, new: Identifiable)]) {
        for (index, pair) in identifiables {
            guard let oldSection = pair.old as? UITableView.Section,
                  let newSection = pair.new as? UITableView.Section else {
                continue
            }
            let cellReloader = CollectionMediatorCellReloader(section: index, collection: collection, forceRefresh: forceRefresh)
            let diffReloader = DiffReloader(worker: cellReloader)
            diffReloader.reloadDifference(oldIdentities: oldSection.cells, newIdentities: newSection.cells)
        }
    }
    
    public func diffReloader(_ diffReloader: DiffReloader, shouldMove identifiable: Identifiable, from index: Int, to destIndex: Int) {
        collection.moveSection(index, toSection: destIndex)
    }
}

public struct CollectionMediatorCellReloader: DiffReloaderWorker {
    let collection: UICollectionView
    let section: Int
    let forceRefresh: Bool
    
    init(section: Int, collection: UICollectionView, forceRefresh: Bool) {
        self.section = section
        self.collection = collection
        self.forceRefresh = forceRefresh
    }
    
    public func diffReloader(_ diffReloader: DiffReloader, shouldRemove identifiables: [Int : Identifiable]) {
        let indexPaths: [IndexPath] = identifiables.keys.compactMap { IndexPath(item: $0, section: section) }
        collection.deleteItems(at: indexPaths)
    }
    
    public func diffReloader(_ diffReloader: DiffReloader, shouldInsert identifiable: Identifiable, at index: Int) {
        collection.insertItems(at: [.init(item: index, section: section)])
    }
    
    public func diffReloader(_ diffReloader: DiffReloader, shouldReload identifiables: [Int : (old: Identifiable, new: Identifiable)]) {
        guard forceRefresh else { return }
        let indexPaths: [IndexPath] = identifiables.keys.compactMap { IndexPath(item: $0, section: section) }
        collection.reloadItems(at: indexPaths)
    }
    
    public func diffReloader(_ diffReloader: DiffReloader, shouldMove identifiable: Identifiable, from index: Int, to destIndex: Int) {
        collection.moveItem(at: .init(item: index, section: section), to: .init(item: destIndex, section: section))
    }
}
