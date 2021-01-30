//
//  LinkerProtocols.swift
//  Artisan
//
//  Created by Nayanda Haberty (ID) on 04/07/20.
//

import Foundation

public protocol AnyMediator {
    var bondingStates: [ViewBondingState] { get }
    var observables: [StateObservable] { get }
    func removeBond()
}

public protocol BondableMediator: class, Buildable, AnyMediator {
    associatedtype View: NSObject
    var view: View? { get }
    func map(from view: View)
    func apply(to view: View)
    func bonding(with view: View)
    func willApplying(_ view: View)
    func didApplying(_ view: View)
    func mediatorWillMapped(from view: View)
    func mediatorDidMapped(from view: View)
    func willLoosingBond(with view: View?)
    func didLoosingBond(with view: View?)
}

public protocol Buildable {
    init()
}

public protocol ViewBondingState {
    var bondingState: BondingState { get set }
    func removeBonding()
}

public protocol ObservableView {
    associatedtype Observer
    var observer: Observer? { get }
}

public protocol StateObservable {
    func invokeWithCurrentValue()
    func remove<Observer: AnyObject>(observer: Observer)
    func removeAllObservers()
}

protocol AnyLinker {
    func signalViewListener(from view: UIView, with newValue: Any, old oldValue: Any)
    func signalStateListener(with newValue: Any, old oldValue: Any)
    func signalApplicator(with newValue: Any)
}
