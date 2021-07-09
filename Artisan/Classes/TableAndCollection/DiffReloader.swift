//
//  DiffReloader.swift
//  Artisan
//
//  Created by Nayanda Haberty on 16/04/21.
//

import Foundation
#if canImport(UIKit)
import UIKit

public protocol Distinctable {
    var distinctIdentifier: AnyHashable { get }
    func distinct(with other: Distinctable) -> Bool
    func indistinct(with other: Distinctable) -> Bool
}

public extension Distinctable {
    
    func indistinct(with other: Distinctable) -> Bool {
        distinctIdentifier == other.distinctIdentifier
    }
    
    func distinct(with other: Distinctable) -> Bool {
        !indistinct(with: other)
    }
}

public protocol DiffReloaderWorker {
    func diffReloader(_ diffReloader: DiffReloader, shouldRemove distinctables: [Int: Distinctable])
    func diffReloader(_ diffReloader: DiffReloader, shouldInsert distinctable: Distinctable, at index: Int)
    func diffReloader(_ diffReloader: DiffReloader, shouldReload distinctables: [Int: (old: Distinctable, new: Distinctable)])
    func diffReloader(_ diffReloader: DiffReloader, shouldMove distinctable: Distinctable, from index: Int, to destIndex: Int)
    func diffReloader(_ diffReloader: DiffReloader, failWith error: ArtisanError)
}

public final class DiffReloader {
    let worker: DiffReloaderWorker
    var sequenceLoader: [() -> Void] = []
    
    public init(worker: DiffReloaderWorker) {
        self.worker = worker
    }
    
    public func reloadDifference(
        oldIdentities: [Distinctable],
        newIdentities: [Distinctable]) {
        let oldIdentitiesAfterRemoved = removeFrom(oldIdentities: oldIdentities, notIn: newIdentities)
        reloadChanges(in: oldIdentitiesAfterRemoved, to: newIdentities)
        runQueue()
    }
    
    func removeFrom(oldIdentities: [Distinctable], notIn newIdentities: [Distinctable]) -> [Distinctable] {
        var mutableIdentities = oldIdentities
        var removedIndex: [Int: Distinctable] = [:]
        var mutableIndex: Int = 0
        for (identityIndex, oldDistinctable) in oldIdentities.enumerated() {
            guard newIdentities.contains(where: { $0.indistinct(with: oldDistinctable)} ) else {
                mutableIdentities.remove(at: mutableIndex)
                removedIndex[identityIndex] = oldDistinctable
                continue
            }
            mutableIndex += 1
        }
        if !removedIndex.isEmpty {
            queueLoad {
                $0.worker.diffReloader($0, shouldRemove: removedIndex)
            }
        }
        return mutableIdentities
    }
    
    func reloadChanges(in oldIdentities: [Distinctable], to newIdentities: [Distinctable]) {
        var mutableIdentities = oldIdentities
        var reloadedIndex: [Int: (old: Distinctable, new: Distinctable)] = [:]
        for (identityIndex, identity) in newIdentities.enumerated() {
            if let oldDistinctable = mutableIdentities[safe: identityIndex],
               oldDistinctable.indistinct(with: identity) {
                reloadedIndex[identityIndex] = (old: oldDistinctable, new: identity)
            } else if let oldIndex = mutableIdentities.firstIndex(where: { $0.indistinct(with: identity)}) {
                let removedDistinctable = mutableIdentities.remove(at: oldIndex)
                guard mutableIdentities.count >= identityIndex else {
                    fail(reason: "Fail move cell from \(oldIndex) to \(identityIndex)")
                    return
                }
                mutableIdentities.insert(removedDistinctable, at: identityIndex)
                queueLoad {
                    $0.worker.diffReloader($0, shouldMove: removedDistinctable, from: oldIndex, to: identityIndex)
                }
                reloadedIndex[identityIndex] = (old: removedDistinctable, new: identity)
            } else {
                guard mutableIdentities.count >= identityIndex else {
                    fail(reason: "Fail add cell to \(identityIndex)")
                    return
                }
                mutableIdentities.insert(identity, at: identityIndex)
                queueLoad {
                    $0.worker.diffReloader($0, shouldInsert: identity, at: identityIndex)
                }
            }
        }
        if !reloadedIndex.isEmpty {
            queueLoad {
                $0.worker.diffReloader($0, shouldReload: reloadedIndex)
            }
        }
    }
    
    func fail(reason: String) {
        sequenceLoader.removeAll()
        worker.diffReloader(self, failWith: .whenDiffReloading(failureReason: reason))
    }
    
    func runQueue() {
        sequenceLoader.forEach {
            $0()
        }
    }
    
    func queueLoad(_ loader: @escaping (DiffReloader) -> Void) {
        sequenceLoader.append { [weak self] in
            guard let self = self else { return }
            loader(self)
        }
    }
}
#endif
