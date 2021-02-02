//
//  DiffReloader.swift
//  Artisan
//
//  Created by Nayanda Haberty on 23/12/20.
//

import Foundation

#if canImport(UIKit)
public protocol Identifiable {
    var identifier: AnyHashable { get }
    func haveSameIdentifier(with other: Identifiable) -> Bool
}

public extension Identifiable {
    func haveSameIdentifier(with other: Identifiable) -> Bool {
        identifier == other.identifier
    }
}

public protocol DiffReloaderWorker {
    func diffReloader(_ diffReloader: DiffReloader, shouldRemove identifiables: [Int: Identifiable])
    func diffReloader(_ diffReloader: DiffReloader, shouldInsert identifiable: Identifiable, at index: Int)
    func diffReloader(_ diffReloader: DiffReloader, shouldReload identifiables: [Int: (old: Identifiable, new: Identifiable)])
    func diffReloader(_ diffReloader: DiffReloader, shouldMove identifiable: Identifiable, from index: Int, to destIndex: Int)
    func diffReloader(_ diffReloader: DiffReloader, failWith error: ArtisanError)
}

public class DiffReloader {
    let worker: DiffReloaderWorker
    var sequenceLoader: [() -> Void] = []
    
    public init(worker: DiffReloaderWorker) {
        self.worker = worker
    }
    
    public func reloadDifference(
        oldIdentities: [Identifiable],
        newIdentities: [Identifiable]) {
        let oldIdentitiesAfterRemoved = removeFrom(oldIdentities: oldIdentities, notIn: newIdentities)
        reloadChanges(in: oldIdentitiesAfterRemoved, to: newIdentities)
        runQueue()
    }
    
    func removeFrom(oldIdentities: [Identifiable], notIn newIdentities: [Identifiable]) -> [Identifiable] {
        var mutableIdentities = oldIdentities
        var removedIndex: [Int: Identifiable] = [:]
        var mutableIndex: Int = 0
        for (identityIndex, oldIdentifiable) in oldIdentities.enumerated() {
            guard newIdentities.contains(where: { $0.haveSameIdentifier(with: oldIdentifiable)} ) else {
                mutableIdentities.remove(at: mutableIndex)
                removedIndex[identityIndex] = oldIdentifiable
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
    
    func reloadChanges(in oldIdentities: [Identifiable], to newIdentities: [Identifiable]) {
        var mutableIdentities = oldIdentities
        var reloadedIndex: [Int: (old: Identifiable, new: Identifiable)] = [:]
        for (identityIndex, identity) in newIdentities.enumerated() {
            if let oldIdentifiable = mutableIdentities[safe: identityIndex],
               oldIdentifiable.haveSameIdentifier(with: identity) {
                reloadedIndex[identityIndex] = (old: oldIdentifiable, new: identity)
            } else if let oldIndex = mutableIdentities.firstIndex(where: { $0.haveSameIdentifier(with: identity)}) {
                let removedIdentifiable = mutableIdentities.remove(at: oldIndex)
                guard mutableIdentities.count >= identityIndex else {
                    fail(reason: "Fail move cell from \(oldIndex) to \(identityIndex)")
                    return
                }
                mutableIdentities.insert(removedIdentifiable, at: identityIndex)
                queueLoad {
                    $0.worker.diffReloader($0, shouldMove: removedIdentifiable, from: oldIndex, to: identityIndex)
                }
                reloadedIndex[identityIndex] = (old: removedIdentifiable, new: identity)
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
