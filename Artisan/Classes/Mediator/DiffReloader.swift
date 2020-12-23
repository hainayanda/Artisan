//
//  DiffReloader.swift
//  Artisan
//
//  Created by Nayanda Haberty on 23/12/20.
//

import Foundation

public protocol Identifiable {
    var identifier: AnyHashable { get }
    func haveSameIdentifiable(with other: Identifiable) -> Bool
}

public extension Identifiable {
    func haveSameIdentifiable(with other: Identifiable) -> Bool {
        identifier == other.identifier
    }
}

public protocol DiffReloaderWorker {
    func diffReloader(_ diffReloader: DiffReloader, shouldRemove identifiables: [Int: Identifiable])
    func diffReloader(_ diffReloader: DiffReloader, shouldInsert identifiable: Identifiable, at index: Int)
    func diffReloader(_ diffReloader: DiffReloader, shouldReload identifiables: [Int: (old: Identifiable, new: Identifiable)])
    func diffReloader(_ diffReloader: DiffReloader, shouldMove identifiable: Identifiable, from index: Int, to destIndex: Int)
}

public struct DiffReloader {
    let worker: DiffReloaderWorker
    
    public init(worker: DiffReloaderWorker) {
        self.worker = worker
    }
    
    public func reloadDifference(
        oldIdentities: [Identifiable],
        newIdentities: [Identifiable]) {
        let oldIdentitiesAfterRemoved = removeFrom(oldIdentities: oldIdentities, notIn: newIdentities)
        insert(newIdentities: newIdentities, notIn: oldIdentitiesAfterRemoved)
    }
    
    func removeFrom(oldIdentities: [Identifiable], notIn newIdentities: [Identifiable]) -> [Identifiable] {
        var mutableIdentities = oldIdentities
        var removedIndex: [Int: Identifiable] = [:]
        var mutableIndex: Int = 0
        for (identityIndex, oldIdentifiable) in oldIdentities.enumerated() {
            guard newIdentities.contains(where: { $0.haveSameIdentifiable(with: oldIdentifiable)} ) else {
                mutableIdentities.remove(at: mutableIndex)
                removedIndex[identityIndex] = oldIdentifiable
                continue
            }
            mutableIndex += 1
        }
        if !removedIndex.isEmpty {
            worker.diffReloader(self, shouldRemove: removedIndex)
        }
        return mutableIdentities
    }
    
    func insert(newIdentities: [Identifiable], notIn oldIdentities: [Identifiable]) {
        var mutableIdentities = oldIdentities
        var reloadedIndex: [Int: (old: Identifiable, new: Identifiable)] = [:]
        for (identityIndex, identity) in newIdentities.enumerated() {
            if let oldIdentifiable = mutableIdentities[safe: identityIndex],
               oldIdentifiable.haveSameIdentifiable(with: identity) {
                reloadedIndex[identityIndex] = (old: oldIdentifiable, new: identity)
            } else if let oldIndex = mutableIdentities.firstIndex(where: { $0.haveSameIdentifiable(with: identity)}) {
                let removedIdentifiable = mutableIdentities.remove(at: oldIndex)
                mutableIdentities.insert(removedIdentifiable, at: identityIndex)
                worker.diffReloader(self, shouldMove: removedIdentifiable, from: oldIndex, to: identityIndex)
                reloadedIndex[identityIndex] = (old: removedIdentifiable, new: identity)
            } else {
                mutableIdentities.insert(identity, at: identityIndex)
                worker.diffReloader(self, shouldInsert: identity, at: identityIndex)
            }
        }
        if !reloadedIndex.isEmpty {
            worker.diffReloader(self, shouldReload: reloadedIndex)
        }
    }
}
