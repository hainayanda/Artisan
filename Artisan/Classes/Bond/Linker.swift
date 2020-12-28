//
//  Linker.swift
//  Artisan
//
//  Created by Nayanda Haberty (ID) on 18/08/20.
//

import Foundation
import UIKit

public class PartialLinker<View: UIView, State>: AnyLinker {
    var viewListener: ((View, Changes<State>) -> Void)?
    weak var view: View?
    unowned var state: ViewState<State>
    
    init(state: ViewState<State>, view: View) {
        self.view = view
        self.state = state
    }
    
    public func observe<Observer: AnyObject>(observer: Observer, on dispatcher: DispatchQueue = OperationQueue.current?.underlyingQueue ?? .main) -> PropertyObservers<Observer, State> {
        state.observe(observer: observer, on: dispatcher)
    }
    
    @discardableResult
    public func viewDidSet<Observer: AnyObject>(observer: Observer, thenCall method: @escaping ((Observer) -> (View, Changes<State>) -> Void)) -> Self {
        viewListener = { [weak observer] view, changes in
            guard let observer = observer else { return }
            method(observer)(view, changes)
        }
        return self
    }
    
    @discardableResult
    public func viewDidSet<Observer: AnyObject>(observer: Observer, then: @escaping (Observer, View, Changes<State>) -> Void) -> Self {
        viewListener = { [weak observer] view, changes in
            guard let observer = observer else { return }
            then(observer, view, changes)
        }
        return self
    }
    
    @discardableResult
    public func viewDidSet(then: @escaping (View, Changes<State>) -> Void) -> Self {
        viewListener = then
        return self
    }
    
    func signalViewListener(from view: UIView, with newValue: Any, old oldValue: Any) {
        guard let view = self.view, let new = newValue as? State, let old = oldValue as? State else { return }
        viewListener?(view, .init(new: new, old: old, trigger: .view(view)))
    }
    
    func signalStateListener(with newValue: Any, old oldValue: Any) { }
    
    func signalApplicator(with newValue: Any) { }
}

public class Linker<View: UIView, State>: PartialLinker<View, State> {
    var stateListener: ((View, Changes<State>) -> Void)?
    var applicator: ((View, State) -> Void)?
    
    public override func observe<Observer: AnyObject>(observer: Observer, on dispatcher: DispatchQueue = OperationQueue.current?.underlyingQueue ?? .main) -> PropertyObservers<Observer, State> {
        super.observe(observer: observer, on: dispatcher)
    }
    
    @discardableResult
    public func stateDidSet<Observer: AnyObject>(observer: Observer, thenCall method: @escaping ((Observer) -> (View, Changes<State>) -> Void)) -> Self {
        stateListener = { [weak observer] view, changes in
            guard let observer = observer else { return }
            method(observer)(view, changes)
        }
        return self
    }
    
    @discardableResult
    public func stateDidSet<Observer: AnyObject>(observer: Observer, then: @escaping (Observer, View, Changes<State>) -> Void) -> Self {
        stateListener = { [weak observer] view, changes in
            guard let observer = observer else { return }
            then(observer, view, changes)
        }
        return self
    }
    
    @discardableResult
    public func stateDidSet(then: @escaping (View, Changes<State>) -> Void) -> Self {
        stateListener = then
        return self
    }
    
    @discardableResult
    public override func viewDidSet<Observer: AnyObject>(observer: Observer, thenCall method: @escaping ((Observer) -> (View, Changes<State>) -> Void)) -> Self {
        super.viewDidSet(observer: observer, thenCall: method)
        return self
    }
    
    @discardableResult
    public override func viewDidSet<Observer: AnyObject>(observer: Observer, then: @escaping (Observer, View, Changes<State>) -> Void) -> Self {
        super.viewDidSet(observer: observer, then: then)
        return self
    }
    
    @discardableResult
    public override func viewDidSet(then: @escaping (View, Changes<State>) -> Void) -> Self {
        super.viewDidSet(then: then)
        return self
    }
    
    override func signalStateListener(with newValue: Any, old oldValue: Any) {
        guard let view = self.view, let new = newValue as? State, let old = oldValue as? State else { return }
        stateListener?(view, .init(new: new, old: old, trigger: .state))
    }
    
    override func signalApplicator(with newValue: Any) {
        guard let view = self.view, let new = newValue as? State else { return }
        applicator?(view, new)
    }
}

public struct Changes<Change> {
    public var new: Change
    public var old: Change
    public var trigger: Trigger
    
    public enum Trigger: Equatable {
        case view(UIView)
        case state
        case bond
        case invoked
        
        public var triggeringView: UIView? {
            switch self {
            case .view(let view):
                return view
            default:
                return nil
            }
        }
    }
}

public extension Changes where Change: Equatable {
    var isChanging: Bool { new != old }
}

@propertyWrapper
struct Atomic<Wrapped> {
    
    private var value: Wrapped
    private let lock = NSLock()
    
    init(wrappedValue value: Wrapped) {
        self.value = value
    }
    
    var wrappedValue: Wrapped {
        get { return load() }
        set { store(newValue: newValue) }
    }
    
    func load() -> Wrapped {
        lock.lock()
        defer { lock.unlock() }
        return value
    }
    
    mutating func store(newValue: Wrapped) {
        lock.lock()
        defer { lock.unlock() }
        value = newValue
    }
}

public class WrappedPropertyObserver<Wrapped> {
    typealias SetListener = (Changes<Wrapped>) -> Void
    typealias GetListener = (Wrapped) -> Void
    var willSetListener: ((Changes<Wrapped>) -> Void)?
    var didSetListener: ((Changes<Wrapped>) -> Void)?
    var willGetListener: ((Wrapped) -> Void)?
    var didGetListener: ((Wrapped) -> Void)?
    
    var operationHandler: OperationHandler
    
    @Atomic var delay: TimeInterval = 0
    @Atomic var latestChangesTriggered: Date = .distantPast
    @Atomic var latestChanges: Changes<Wrapped>?
    @Atomic var onDelayed: Bool = false
    
    init(dispatcher: DispatchQueue, syncIfPossible: Bool) {
        operationHandler = ObservableOperationHandler(dispatcher: dispatcher, syncIfPossible: syncIfPossible)
    }
    
    func triggerDidSet(with changes: Changes<Wrapped>) {
        if let latest = self.latestChanges {
            self.latestChanges = .init(new: changes.new, old: latest.old, trigger: changes.trigger)
        } else {
            self.latestChanges = changes
        }
        let intervalFromLatestTrigger = -(latestChangesTriggered.timeIntervalSinceNow)
        guard intervalFromLatestTrigger > delay else {
            let nextTrigger = delay - intervalFromLatestTrigger
            getCurrentDispatcher().asyncAfter(deadline: .now() + nextTrigger) { [weak self] in
                guard let self = self, let changes = self.latestChanges else { return }
                self.triggerDidSet(with: changes)
            }
            return
        }
        operationHandler.addOperation { [weak self] in
            guard let self = self, let changes = self.latestChanges else { return }
            self.latestChanges = nil
            self.didSetListener?(changes)
            self.latestChangesTriggered = Date()
        }
    }
    
    func getCurrentDispatcher() -> DispatchQueue {
        OperationQueue.current?.underlyingQueue ?? .main
    }
}

public class PropertyObservers<Observer: AnyObject, Wrapped>: WrappedPropertyObserver<Wrapped> {
    typealias SetListener = (Changes<Wrapped>) -> Void
    typealias GetListener = (Wrapped) -> Void
    typealias ObservedSetListener = (Observer, Changes<Wrapped>) -> Void
    typealias ObservedGetListener = (Observer, Wrapped) -> Void
    typealias ObservedSetListenerPointer = (Observer) -> SetListener
    typealias ObservedGetListenerPointer = (Observer) -> GetListener
    weak var observer: Observer?
    
    init(obsever: Observer, dispatcher: DispatchQueue, syncIfPossible: Bool) {
        self.observer = obsever
        super.init(dispatcher: dispatcher, syncIfPossible: syncIfPossible)
    }
    
    @discardableResult
    public func delayMultipleSetTrigger(by delay: TimeInterval) -> Self {
        self.delay = delay
        return self
    }
    
    @discardableResult
    public func willSet(thenCall method: @escaping (Observer) ->((Changes<Wrapped>) -> Void)) -> Self {
        willSetListener = asListener(method: method)
        return self
    }
    
    @discardableResult
    public func willSet(then: @escaping (Observer, Changes<Wrapped>) -> Void) -> Self {
        willSetListener = asListener(closure: then)
        return self
    }
    
    @discardableResult
    public func didSet(then: @escaping (Observer, Changes<Wrapped>) -> Void) -> Self {
        didSetListener = asListener(closure: then)
        return self
    }
    
    @discardableResult
    public func didSet(thenCall method: @escaping (Observer) ->((Changes<Wrapped>) -> Void)) -> Self {
        didSetListener = asListener(method: method)
        return self
    }
    
    @discardableResult
    public func didGet(then: @escaping (Observer, Wrapped) -> Void) -> Self {
        didGetListener = asListener(closure: then)
        return self
    }
    
    @discardableResult
    public func didGet(thenCall method: @escaping (Observer) ->((Wrapped) -> Void)) -> Self {
        didGetListener = asListener(method: method)
        return self
    }
    
    @discardableResult
    public func willGet(then: @escaping (Observer, Wrapped) -> Void) -> Self {
        willGetListener = asListener(closure: then)
        return self
    }
    
    @discardableResult
    public func willGet(thenCall method: @escaping (Observer) ->((Wrapped) -> Void)) -> Self {
        willGetListener = asListener(method: method)
        return self
    }
    
    func asListener(closure: @escaping ObservedSetListener) -> SetListener {
        return { [weak self] changes in
            guard let observer = self?.observer else { return }
            closure(observer, changes)
        }
    }
    
    func asListener(closure: @escaping ObservedGetListener) -> GetListener {
        return { [weak self] value in
            guard let observer = self?.observer else { return }
            closure(observer, value)
        }
    }
    
    func asListener(method: @escaping ObservedSetListenerPointer) -> SetListener {
        return { [weak self] changes in
            guard let observer = self?.observer else { return }
            method(observer)(changes)
        }
    }
    
    func asListener(method: @escaping ObservedGetListenerPointer) -> GetListener {
        return { [weak self] value in
            guard let observer = self?.observer else { return }
            method(observer)(value)
        }
    }
}

public extension PropertyObservers where Wrapped: Equatable {
    
    @discardableResult
    func didUniqueSet(then: @escaping (Observer, Changes<Wrapped>) -> Void) -> Self {
        didSetListener = { [weak self] value in
            guard let observer = self?.observer, value.isChanging else { return }
            then(observer, value)
        }
        return self
    }
    
    @discardableResult
    func didUniqueSet(thenCall method: @escaping (Observer) ->((Changes<Wrapped>) -> Void)) -> Self {
        didSetListener = { [weak self] value in
            guard let observer = self?.observer, value.isChanging else { return }
            method(observer)(value)
        }
        return self
    }
    
    @discardableResult
    func willUniqueSet(then: @escaping (Observer, Changes<Wrapped>) -> Void) -> Self {
        willSetListener = { [weak self] value in
            guard let observer = self?.observer, value.isChanging else { return }
            then(observer, value)
        }
        return self
    }
    
    @discardableResult
    func willUniqueSet(thenCall method: @escaping (Observer) ->((Changes<Wrapped>) -> Void)) -> Self {
        willSetListener = { [weak self] value in
            guard let observer = self?.observer, value.isChanging else { return }
            method(observer)(value)
        }
        return self
    }
}
