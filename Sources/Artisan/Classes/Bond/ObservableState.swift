//
//  ObservableState.swift
//  Artisan
//
//  Created by Nayanda Haberty (ID) on 23/08/20.
//

import Foundation
#if canImport(UIKit)
import UIKit

@propertyWrapper
open class ObservableState<Wrapped>: StateObservable {
    var observers: [WrappedPropertyObserver<Wrapped>] = []
    var _wrappedValue: Wrapped
    public var wrappedValue: Wrapped {
        get {
            getAndObserve(value: _wrappedValue)
        }
        set {
            observedSet(value: newValue, from: .state)
        }
    }
    
    public var projectedValue: ObservableState<Wrapped> { self }
    
    public init(wrappedValue: Wrapped) {
        self._wrappedValue = wrappedValue
    }
    
    public func observe<Observer: AnyObject>(
        observer: Observer,
        on dispatcher: DispatchQueue = OperationQueue.current?.underlyingQueue ?? .main,
        syncIfPossible: Bool = true) -> PropertyObservers<Observer, Wrapped> {
        remove(observer: observer)
        let newObserver = PropertyObservers<Observer, Wrapped>(obsever: observer, dispatcher: dispatcher, syncIfPossible: syncIfPossible)
        self.observers.append(newObserver)
        return newObserver
    }
    
    public func remove<Observer: AnyObject>(observer: Observer) {
        self.observers.removeAll { ($0 as? PropertyObservers<Observer, Wrapped>)?.observer === observer }
    }
    
    public func removeAllObservers() {
        observers.removeAll()
    }
    
    public func invokeWithCurrentValue() {
        observers.forEach { observer in
            let changes: Changes = .init(new: _wrappedValue, old: _wrappedValue, trigger: .invoked)
            observer.triggerDidSet(with: changes)
        }
    }
    
    func getAndObserve(value: Wrapped) -> Wrapped {
        observers.forEach { observer in
            observer.willGetListener?(_wrappedValue)
        }
        defer {
            observers.forEach { observer in
                observer.didGetListener?(_wrappedValue)
            }
        }
        return _wrappedValue
    }
    
    func observedSet(value: Wrapped, from: Changes<Wrapped>.Trigger) {
        let oldValue = _wrappedValue
        let changes = Changes(new: value, old: oldValue, trigger: from)
        observedWillSet(changes: changes, from: from)
        setAndObserve(changes: changes, from: from)
    }
    
    func observedWillSet(changes: Changes<Wrapped>, from: Changes<Wrapped>.Trigger) {
        observers.forEach { observer in
            observer.willSetListener?(changes)
        }
    }
    
    func setAndObserve(changes: Changes<Wrapped>, from: Changes<Wrapped>.Trigger) {
        _wrappedValue = changes.new
        observers.forEach { observer in
            observer.triggerDidSet(with: changes)
        }
    }
}

@propertyWrapper
public class WeakObservableState<Wrapped: AnyObject>: ObservableState<Wrapped?> {
    weak var _weakWrappedValue: Wrapped?
    override var _wrappedValue: Wrapped? {
        get {
            _weakWrappedValue
        }
        set {
            _weakWrappedValue = newValue
        }
    }
    public override var wrappedValue: Wrapped? {
        get {
            super.wrappedValue
        }
        set {
            super.wrappedValue = newValue
        }
    }
    public override var projectedValue: ObservableState<Wrapped?> { self }
    
    public override init(wrappedValue: Wrapped?) {
        super.init(wrappedValue: wrappedValue)
    }
    
    public override func observe<Observer: AnyObject>(
        observer: Observer,
        on dispatcher: DispatchQueue = OperationQueue.current?.underlyingQueue ?? .main,
        syncIfPossible: Bool = true) -> PropertyObservers<Observer, Wrapped?> {
        super.observe(observer: observer, on: dispatcher, syncIfPossible: syncIfPossible)
    }
    
    public override func remove<Observer>(observer: Observer) where Observer : AnyObject {
        super.remove(observer: observer)
    }
    
    public override func removeAllObservers() {
        super.removeAllObservers()
    }
}
#endif
