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

public extension Planer {
    
    @discardableResult
    func apply(_ applicator: (View) -> Void) -> Self {
        applicator(view)
        return self
    }
    
    @discardableResult
    func link<Property>(_ keyPath: ReferenceWritableKeyPath<View, Property>, with viewState: ViewState<Property>) -> Self {
        viewState.bonding(with: view, keyPath)
        return self
    }
    
    @discardableResult
    func apply<Property>(_ keyPath: ReferenceWritableKeyPath<View, Property>, from viewState: ViewState<Property>) -> Self {
        viewState.apply(into: view, keyPath)
        return self
    }
    
    @discardableResult
    func map<Property>(_ keyPath: ReferenceWritableKeyPath<View, Property>, into viewState: ViewState<Property>) -> Self {
        viewState.map(from: view, keyPath)
        return self
    }
    
    @discardableResult
    func partialLink<Property>(_ keyPath: KeyPath<View, Property>, with viewState: ViewState<Property>) -> Self {
        viewState.partialBonding(with: view, keyPath)
        return self
    }
    
    @discardableResult
    func observe<Property>(_ viewState: ObservableState<Property>, didSet then: @escaping (View, Changes<Property>) -> Void) -> Self {
        viewState.observe(observer: view).didSet(then: then)
        return self
    }
    
    @discardableResult
    func whenStateChanged<Property, Result>(
        for viewState: ObservableState<Property>,
        thenAssign keyPath: ReferenceWritableKeyPath<View, Result>,
        with closure: @autoclosure @escaping () -> Result) -> Self {
        viewState.observe(observer: view).didSet { view, _ in
            view[keyPath: keyPath] = closure()
        }
        return self
    }
    
    @discardableResult
    func whenStateChanged<Property>(
        for viewState: ObservableState<Property>,
        thenAssignTo keyPath: ReferenceWritableKeyPath<View, Property>) -> Self {
        viewState.observe(observer: view).didSet { view, changes in
            view[keyPath: keyPath] = changes.new
        }
        return self
    }
    
    @discardableResult
    func apply<VM: ViewMediator<View>>(mediator: VM) -> Self {
        mediator.apply(to: view)
        return self
    }
    
    @discardableResult
    func map<VM: ViewMediator<View>>(into mediator: VM) -> Self {
        mediator.map(from: view)
        return self
    }
    
    @discardableResult
    func bonded<VM: ViewMediator<View>>(with mediator: VM) -> Self {
        mediator.bonding(with: view)
        return self
    }
}
#endif
