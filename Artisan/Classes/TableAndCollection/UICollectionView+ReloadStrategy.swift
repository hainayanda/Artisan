//
//  UICollectionView+ReloadStrategy.swift
//  Artisan
//
//  Created by Nayanda Haberty on 16/04/21.
//

import Foundation
#if canImport(UIKit)
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
        var canceled = false
        collectionView.performBatchUpdates({
            let sectionReloader = CollectionSectionReloader(
                collection: collectionView,
                forceRefresh: reloadStrategy.shouldRefresh
            )
            let diffReloader = DiffReloader(worker: sectionReloader)
            diffReloader.reloadDifference(oldIdentities: oldSections, newIdentities: sections)
            canceled = sectionReloader.canceled
        }, completion: { succeed in
            if canceled {
                collectionView.reloadData()
            }
            completion?(succeed)
        })
    }
    
    func dataIsValid(_ collectionView: UICollectionView, oldData: [UICollectionView.Section]) -> Bool {
        guard collectionView.numberOfSections == oldData.count else { return false }
        for (section, cells) in oldData.enumerated() {
            guard collectionView.numberOfItems(inSection: section) == cells.cellCount else { return false }
        }
        return true
    }
}

public final class CollectionSectionReloader: DiffReloaderWorker {
    let collection: UICollectionView
    let forceRefresh: Bool
    var canceled: Bool = false
    
    init(collection: UICollectionView, forceRefresh: Bool) {
        self.collection = collection
        self.forceRefresh = forceRefresh
    }
    
    public func diffReloader(_ diffReloader: DiffReloader, shouldRemove distinctables: [Int : Distinctable]) {
        collection.deleteSections(.init(distinctables.keys))
    }
    
    public func diffReloader(_ diffReloader: DiffReloader, shouldInsert distinctable: Distinctable, at index: Int) {
        collection.insertSections(.init(integer: index))
    }
    
    public func diffReloader(_ diffReloader: DiffReloader, shouldReload distinctables: [Int : (old: Distinctable, new: Distinctable)]) {
        for (index, pair) in distinctables {
            guard let oldSection = pair.old as? UICollectionView.Section,
                  let newSection = pair.new as? UICollectionView.Section else {
                continue
            }
            let cellReloader = CollectionMediatorCellReloader(section: index, collection: collection, forceRefresh: forceRefresh)
            let diffReloader = DiffReloader(worker: cellReloader)
            diffReloader.reloadDifference(oldIdentities: oldSection.cells, newIdentities: newSection.cells)
            if cellReloader.canceled {
                collection.reloadSections(IndexSet([index]))
            }
        }
    }
    
    public func diffReloader(_ diffReloader: DiffReloader, shouldMove distinctable: Distinctable, from index: Int, to destIndex: Int) {
        collection.moveSection(index, toSection: destIndex)
    }
    
    public func diffReloader(_ diffReloader: DiffReloader, failWith error: ArtisanError) {
        if let errorDescription = error.errorDescription {
            debugPrint(errorDescription)
            if let failureReason = error.failureReason {
                debugPrint(failureReason)
            }
        }
        canceled = true
    }
}

public class CollectionMediatorCellReloader: DiffReloaderWorker {
    let collection: UICollectionView
    let section: Int
    let forceRefresh: Bool
    var canceled: Bool = false
    
    init(section: Int, collection: UICollectionView, forceRefresh: Bool) {
        self.section = section
        self.collection = collection
        self.forceRefresh = forceRefresh
    }
    
    public func diffReloader(_ diffReloader: DiffReloader, shouldRemove distinctables: [Int : Distinctable]) {
        let indexPaths: [IndexPath] = distinctables.keys.compactMap { IndexPath(item: $0, section: section) }
        collection.deleteItems(at: indexPaths)
    }
    
    public func diffReloader(_ diffReloader: DiffReloader, shouldInsert distinctable: Distinctable, at index: Int) {
        collection.insertItems(at: [.init(item: index, section: section)])
    }
    
    public func diffReloader(_ diffReloader: DiffReloader, shouldReload distinctables: [Int : (old: Distinctable, new: Distinctable)]) {
        guard forceRefresh else { return }
        let indexPaths: [IndexPath] = distinctables.keys.compactMap { IndexPath(item: $0, section: section) }
        collection.reloadItems(at: indexPaths)
    }
    
    public func diffReloader(_ diffReloader: DiffReloader, shouldMove distinctable: Distinctable, from index: Int, to destIndex: Int) {
        collection.moveItem(at: .init(item: index, section: section), to: .init(item: destIndex, section: section))
    }
    
    public func diffReloader(_ diffReloader: DiffReloader, failWith error: ArtisanError) {
        if let errorDescription = error.errorDescription {
            debugPrint(errorDescription)
            if let failureReason = error.failureReason {
                debugPrint(failureReason)
            }
        }
        canceled = true
    }
}
#endif
