//
//  Planer.swift
//  Artisan
//
//  Created by Nayanda Haberty (ID) on 18/08/20.
//

import Foundation
#if canImport(UIKit)
import UIKit
import Draftsman
import Pharos

public extension Planer {
    
    @discardableResult
    func apply(_ applicator: (View) -> Void) -> Self {
        applicator(view)
        return self
    }
    
    @discardableResult
    func bond<Property>(_ keyPath: ReferenceWritableKeyPath<View, Property>, with relay: BondableRelay<Property>) -> Self {
        relay.bonding(with: .relay(of: view, keyPath))
        return self
    }
    
    @discardableResult
    func apply<Property>(_ keyPath: ReferenceWritableKeyPath<View, Property>, from relay: BondableRelay<Property>) -> Self {
        relay.bondAndApply(to: .relay(of: view, keyPath))
        return self
    }
    
    @discardableResult
    func map<Property>(_ keyPath: ReferenceWritableKeyPath<View, Property>, into relay: BondableRelay<Property>) -> Self {
        relay.bondAndMap(from: .relay(of: view, keyPath))
        return self
    }
    
    @discardableResult
    func apply<VM: ViewMediator<View>>(mediator: VM) -> Self {
        mediator.apply(to: view)
        return self
    }
    
    @discardableResult
    func bonding<VM: ViewMediator<View>>(with mediator: VM) -> Self {
        mediator.bonding(with: view)
        return self
    }
}
#endif
