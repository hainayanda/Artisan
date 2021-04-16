//
//  AnyMediator.swift
//  Artisan
//
//  Created by Nayanda Haberty on 16/04/21.
//

import Foundation
#if canImport(UIKit)
import Pharos

public protocol AnyMediator {
    var observables: [StateObservable] { get }
    func removeBond()
    func bondDidRemoved()
}

public extension AnyMediator {
    var observables: [StateObservable] {
        Mirror(reflecting: self).observables
    }
}

extension Mirror {
    var observables: [StateObservable] {
        var observables = superclassMirror?.observables ?? []
        observables.append(contentsOf: children.compactMap { $0.value as? StateObservable })
        return observables
    }
}
#endif
