//
//  ViewMediator.swift
//  Artisan
//
//  Created by Nayanda Haberty (ID) on 06/08/20.
//

import Foundation
#if canImport(UIKit)
import UIKit
import Draftsman

extension AnyMediator {
    
    func extractBondings(from mirror: Mirror, into states: inout [ViewBondingState]) {
        for child in mirror.children {
            if let bondings = child.value as? ViewBondingState {
                states.append(bondings)
            } else if let mediator = child.value as? AnyMediator {
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
            } else if let mediator = child.value as? AnyMediator {
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

public extension BondableMediator {
    func createViewAndApply(_ builder: ((View) -> Void)? = nil) -> View {
        let view = View.init()
        builder?(view)
        apply(to: view)
        return view
    }
}

@objc class AssociatedWrapper: NSObject {
    var wrapped: AnyObject
    
    init(wrapped: AnyObject) {
        self.wrapped = wrapped
    }
}

open class ViewMediator<View: NSObject>: NSObject, BondableMediator {
    
    var afterPlanningRoutine: AfterPlanningRoutine { .autoApply }
    
    weak public internal(set) var view: View?
    required public override init() {
        super.init()
        didInit()
    }
    
    final public func apply(to view: View) {
        willApplying(view)
        removeBondAndAssign(bondingState: .applying)
        bonding(with: view)
        observables.forEach {
            $0.invokeWithCurrentValue()
        }
        neutralizeBond()
        didApplying(view)
    }
    
    final public func map(from view: View) {
        mediatorWillMapped(from: view)
        removeBondAndAssign(bondingState: .mapping)
        bonding(with: view)
        neutralizeBond()
        mediatorDidMapped(from: view)
    }
    
    func removeBondAndAssign(bondingState: BondingState) {
        let states = bondingStates
        states.forEach {
            var state = $0
            state.removeBonding()
            state.bondingState = bondingState
        }
        removeBond()
    }
    
    func neutralizeBond() {
        let states = bondingStates
        states.forEach {
            var state = $0
            state.bondingState = .none
        }
    }
    
    open func didInit() { }
    
    open func willApplying(_ view: View) { }
    
    open func didApplying(_ view: View) { }
    
    open func mediatorWillMapped(from view: View) { }
    
    open func mediatorDidMapped(from view: View) { }
    
    open func willLoosingBond(with view: View) { }
    
    open func didLoosingBond(with view: View) { }
    
    open func bonding(with view: View) {
        defer {
            self.view = view
            subscribeAfterPlanning(for: view)
        }
        let mediator = view.getMediator()
        if self === (mediator as? ViewMediator<View>) {
            return
        } else {
            view.setMediator(self)
        }
    }
    
    final public func removeBond() {
        guard let currentView = self.view else { return }
        willLoosingBond(with: currentView)
        objc_setAssociatedObject(currentView,  &NSObject.AssociatedKey.mediator, nil, .OBJC_ASSOCIATION_RETAIN)
        self.view = nil
        bondingStates.forEach {
            $0.removeBonding()
        }
        didLoosingBond(with: currentView)
    }
    
    func subscribeAfterPlanning(for view: View) {
        if let uiview = view as? UIView {
            uiview.whenViewDidPlanned { [weak self] view in
                guard let self = self, let view = view as? View else { return }
                switch self.afterPlanningRoutine {
                case .autoApply:
                    self.apply(to: view)
                case .autoMapped:
                    self.map(from: view)
                default:
                    break
                }
            }
        } else if let uivc = view as? UIViewController {
            uivc.whenViewDidPlanned { [weak self] view in
                guard let self = self, let view = view as? View else { return }
                switch self.afterPlanningRoutine {
                case .autoApply:
                    self.apply(to: view)
                case .autoMapped:
                    self.map(from: view)
                default:
                    break
                }
            }
        }
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
#endif
