//
//  ViewMediator.swift
//  Artisan
//
//  Created by Nayanda Haberty (ID) on 06/08/20.
//

import Foundation
import UIKit

extension StatedMediator {
    
    func extractBondings(from mirror: Mirror, into states: inout [ViewBondingState]) {
        for child in mirror.children {
            if let bondings = child.value as? ViewBondingState {
                states.append(bondings)
            } else if let mediator = child.value as? StatedMediator {
                states.append(contentsOf: mediator.bondingStates)
            }
        }
    }
    
    public var bondingStates: [ViewBondingState] {
        let reflection = Mirror(reflecting: self)
        var states: [ViewBondingState] = []
        var currentReflection: Mirror? = reflection
        repeat {
            guard let current: Mirror = currentReflection else {
                break
            }
            extractBondings(from: current, into: &states)
            currentReflection = current.superclassMirror
        } while currentReflection != nil
        return states
    }
    
    func extractObservables(from mirror: Mirror, into states: inout [StateObservable]) {
        for child in mirror.children {
            if let stateObservable = child.value as? StateObservable {
                states.append(stateObservable)
            } else if let mediator = child.value as? StatedMediator {
                states.append(contentsOf: mediator.observables)
            }
        }
    }
    
    public var observables: [StateObservable] {
        let reflection = Mirror(reflecting: self)
        var states: [StateObservable] = []
        var currentReflection: Mirror? = reflection
        repeat {
            guard let current: Mirror = currentReflection else {
                break
            }
            extractObservables(from: current, into: &states)
            currentReflection = current.superclassMirror
        } while currentReflection != nil
        return states
    }
    
}

@objc class AssociatedWrapper: NSObject {
    var wrapped: AnyObject
    
    init(wrapped: AnyObject) {
        self.wrapped = wrapped
    }
}

open class ViewMediator<View: NSObject>: NSObject, BondableMediator {
    weak public internal(set) var view: View?
    required public override init() {
        super.init()
        didInit()
    }
    
    deinit {
        removeBond()
    }
    
    final public func apply(to view: View) {
        willApplying(view)
        let states = bondingStates
        states.forEach {
            var state = $0
            state.removeBonding()
            state.bondingState = .applying
        }
        bonding(with: view)
        observables.forEach {
            $0.invokeWithCurrentValue()
        }
        states.forEach {
            var state = $0
            state.bondingState = .none
        }
        didApplying(view)
    }
    
    final public func map(from view: View) {
        mediatorWillMapped(from: view)
        let states = bondingStates
        states.forEach {
            var state = $0
            state.removeBonding()
            state.bondingState = .mapping
        }
        removeBond()
        bonding(with: view)
        states.forEach {
            var state = $0
            state.bondingState = .none
        }
        mediatorDidMapped(from: view)
    }
    
    open func didInit() { }
    
    open func willApplying(_ view: View) { }
    
    open func didApplying(_ view: View) { }
    
    open func mediatorWillMapped(from view: View) { }
    
    open func mediatorDidMapped(from view: View) { }
    
    open func willLoosingBond(with view: View?) { }
    
    open func didLoosingBond(with view: View?) { }
    
    open func bonding(with view: View) {
        (view.getMediator() as? StatedMediator)?.removeBond()
        let mediatorWrapper = AssociatedWrapper(wrapped: self)
        objc_setAssociatedObject(view,  &NSObject.AssociatedKey.mediator, mediatorWrapper, .OBJC_ASSOCIATION_RETAIN)
        self.view = view
        if let cell = view as? TableFragmentCell {
            cell.mediator = self
        } else if let cell = view as? CollectionFragmentCell {
            cell.mediator = self
        }
    }
    
    final public func removeBond() {
        let currentView = self.view
        willLoosingBond(with: currentView)
        if let view = self.view {
            objc_setAssociatedObject(view,  &NSObject.AssociatedKey.mediator, nil, .OBJC_ASSOCIATION_RETAIN)
            self.view = nil
        }
        bondingStates.forEach {
            $0.removeBonding()
        }
        didLoosingBond(with: currentView)
    }
}

public extension UIView {
    
    func apply<VM: BondableMediator>(mediator: VM) {
        guard let selfAsView = self as? VM.View else {
            return
        }
        mediator.apply(to: selfAsView)
    }
    
    func map<VM: BondableMediator>(to mediator: VM) {
        guard let selfAsView = self as? VM.View else {
            return
        }
        mediator.map(from: selfAsView)
    }
    
    func bond<VM: BondableMediator>(to mediator: VM) {
        guard let selfAsView = self as? VM.View else {
            return
        }
        mediator.bonding(with: selfAsView)
    }
}
