//
//  ViewState.swift
//  Artisan
//
//  Created by Nayanda Haberty (ID) on 10/08/20.
//

import Foundation
import UIKit

@propertyWrapper
open class ViewState<Wrapped>: ObservableState<Wrapped>, ViewBondingState {
    public var bondingState: BondingState = .none
    private var linker: AnyLinker?
    private var observers: [WrappedPropertyObserver<Wrapped>] = []
    var tokens: [NSObjectProtocol] = []
    var ignoreViewListener: Bool = false
    public override var wrappedValue: Wrapped {
        get {
            getAndObserve(value: _wrappedValue)
        }
        set {
            let oldValue = _wrappedValue
            observedSet(value: newValue, from: .state)
            guard let linker = linker else { return }
            linker.signalApplicator(with: newValue)
            linker.signalStateListener(with: newValue, old: oldValue)
        }
    }
    
    public override var projectedValue: ViewState<Wrapped> { self }
    
    public override init(wrappedValue: Wrapped) {
        super.init(wrappedValue: wrappedValue)
    }
    
    deinit {
        reset()
    }
    
    public override func observe<Observer: AnyObject>(observer: Observer) -> PropertyObservers<Observer, Wrapped> {
        super.observe(observer: observer)
    }
    
    public override func remove<Observer: AnyObject>(observer: Observer) {
        super.remove(observer: observer)
    }
    
    @discardableResult
    public func partialBonding<View: UIView>(
        with view: View,
        _ keyPath: KeyPath<View, Wrapped>) -> PartialLinker<View, Wrapped> {
        removeBonding()
        observedSet(value: view[keyPath: keyPath], from: .bond)
        observe(view: view, keyPath)
        let linker: PartialLinker<View, Wrapped> = .init(view: view)
        self.linker = linker
        return linker
    }
    
    
    @discardableResult
    public func apply<View: UIView>(
        into view: View,
        _ keyPath: ReferenceWritableKeyPath<View, Wrapped>) -> Linker<View, Wrapped> {
        bondingState = .applying
        return bonding(with: view, keyPath, withState: .applying)
    }
    
    @discardableResult
    public func map<View: UIView>(
        from view: View,
        _ keyPath: ReferenceWritableKeyPath<View, Wrapped>) -> Linker<View, Wrapped> {
        bondingState = .mapping
        return bonding(with: view, keyPath, withState: .mapping)
    }
    
    @discardableResult
    public func bonding<View: UIView>(
        with view: View,
        _ keyPath: ReferenceWritableKeyPath<View, Wrapped>) -> Linker<View, Wrapped> {
        return bonding(with: view, keyPath, withState: .none)
    }
    
    @discardableResult
    func bonding<View: UIView>(
        with view: View,
        _ keyPath: ReferenceWritableKeyPath<View, Wrapped>,
        withState state: BondingState) -> Linker<View, Wrapped> {
        switch state {
        case .mapping:
            observedSet(value: view[keyPath: keyPath], from: .bond)
        case .applying:
            view[keyPath: keyPath] = wrappedValue
        case .none:
            break
        }
        observe(view: view, keyPath)
        let linker: Linker<View, Wrapped> = .init(view: view)
        self.linker = linker
        linker.applicator = { [weak self] view, newValue in
            self?.ignoreViewListener = true
            view[keyPath: keyPath] = newValue
        }
        linker.view = view
        return linker
    }
    
    public func reset() {
        removeBonding()
        removeAllObservers()
    }
    
    public func removeBonding() {
        ignoreViewListener = false
        for token in tokens {
            NotificationCenter.default.removeObserver(token)
        }
        tokens.removeAll()
        linker = nil
    }
    
    public override func removeAllObservers() {
        super.removeAllObservers()
    }
    
    @objc public func onTextInput(_ sender: Notification) {
        guard let view = sender.object as? UIView,
              let textInput = view as? UITextInput,
              let textRange = textInput.textRange(from: textInput.beginningOfDocument, to: textInput.endOfDocument),
              let newValue = textInput.text(in: textRange) as? Wrapped else { return }
        let oldValue = _wrappedValue
        observedSet(value: newValue, from: .view(view))
        linker?.signalViewListener(from: view, with: newValue, old: oldValue)
    }
    
    func observe<View: UIView>(view: View, _ keyPath: KeyPath<View, Wrapped>) {
        var observed = false
        if let field = view as? UITextInput {
            let textKeypath: KeyPath<UITextView, String?> = \.text
            let fieldKeypath: KeyPath<UITextField, String?> = \.text
            if textKeypath == keyPath || fieldKeypath == keyPath {
                tokens.append(addTextInputObserver(for: view, field))
            }
        } else if let searchBar = view as? UISearchBar {
            let textKeypath: KeyPath<UISearchBar, String?> = \.text
            if textKeypath == keyPath {
                tokens.append(addTextInputObserver(for: searchBar, searchBar.textField))
            }
        }
        if let imageView = view as? UIImageView {
            observed = observeImageCompatible(forImage: imageView, keyPath: keyPath)
        } else if let label = view as? UILabel {
            observed = observeTextCompatible(forLabel: label, keyPath: keyPath)
        } else if let textView = view as? UITextView {
            observed = observeTextCompatible(forTextView: textView, keyPath: keyPath)
        } else if let textField = view as? UITextField {
            observed = observeTextCompatible(forTextField: textField, keyPath: keyPath)
        }
        guard !observed else { return }
        tokens.append(observeChange(view: view, keyPath: keyPath))
    }
    
    //MARK: Custom View Observer
    
    func observeImageCompatible<View: UIView>(forImage imageView: UIImageView, keyPath: KeyPath<View, Wrapped>) -> Bool {
        let textCompatPath: KeyPath<UIImageView, ImageCompatible?> = \.imageCompat
        guard textCompatPath == keyPath else {
            return false
        }
        tokens.append(observeChange(view: imageView, keyPath: \.image))
        tokens.append(observeChange(view: imageView, keyPath: \.animationImages))
        return true
    }
    
    func observeTextCompatible<View: UIView>(forLabel label: UILabel, keyPath: KeyPath<View, Wrapped>) -> Bool {
        let textCompatPath: KeyPath<UILabel, TextCompatible?> = \.textCompat
        guard textCompatPath == keyPath else {
            return false
        }
        tokens.append(observeChange(view: label, keyPath: \.text))
        tokens.append(observeChange(view: label, keyPath: \.attributedText))
        return true
    }
    
    func observeTextCompatible<View: UIView>(forTextField textField: UITextField, keyPath: KeyPath<View, Wrapped>) -> Bool {
        let textCompatPath: KeyPath<UITextField, TextCompatible?> = \.textCompat
        let placeholderPath: KeyPath<UITextField, TextCompatible?> = \.placeholderCompat
        if textCompatPath == keyPath {
            tokens.append(observeChange(view: textField, keyPath: \.text))
            tokens.append(observeChange(view: textField, keyPath: \.attributedText))
            tokens.append(addTextInputObserver(for: textField, textField))
            return true
        } else if placeholderPath == keyPath {
            tokens.append(observeChange(view: textField, keyPath: \.placeholder))
            tokens.append(observeChange(view: textField, keyPath: \.attributedPlaceholder))
            return true
        }
        return false
    }
    
    func observeTextCompatible<View: UIView>(forTextView textView: UITextView, keyPath: KeyPath<View, Wrapped>) -> Bool {
        let textCompatPath: KeyPath<UILabel, TextCompatible?> = \.textCompat
        guard textCompatPath == keyPath else {
            return false
        }
        tokens.append(observeChange(view: textView, keyPath: \.text))
        tokens.append(observeChange(view: textView, keyPath: \.attributedText))
        tokens.append(addTextInputObserver(for: textView, textView))
        return true
    }
    
    func observeChange<Value, View: UIView>(view: View, keyPath: KeyPath<View, Value>) -> NSObjectProtocol {
        return view.observe(keyPath, options: [.new, .old]) { [weak self] view, changes in
            guard let self = self else { return }
            guard !self.ignoreViewListener,
                  let newValue = changes.newValue as? Wrapped,
                  let oldValue = changes.oldValue as? Wrapped else {
                self.ignoreViewListener = false
                return
            }
            self.observedSet(value: newValue, from: .view(view))
            self.linker?.signalViewListener(from: view, with: newValue, old: oldValue)
        }
    }
    
    func addTextInputObserver<View: UIView>(for view: View, _ field: UITextInput) -> NSObjectProtocol {
        let notificationName: NSNotification.Name = field as? UITextView != nil
            ? UITextView.textDidChangeNotification : UITextField.textDidChangeNotification
        return NotificationCenter.default
            .addObserver(forName: notificationName, object: field, queue: nil) { [weak self, weak view = view, weak field = field] _ in
                guard let self = self,
                      let view = view,
                      let field = field else { return }
                let oldValue = self._wrappedValue
                if let textRange = field.textRange(from: field.beginningOfDocument, to: field.endOfDocument),
                   let newValue = field.text(in: textRange) as? Wrapped {
                    self.observedSet(value: newValue, from: .view(view))
                    self.linker?.signalViewListener(from: view, with: newValue, old: oldValue)
                } else if let newValue: Wrapped = Optional<String>(nilLiteral: ()) as? Wrapped {
                    self.observedSet(value: newValue, from: .view(view))
                    self.linker?.signalViewListener(from: view, with: newValue, old: oldValue)
                }
            }
    }
}

@propertyWrapper
public class WeakViewState<Wrapped: AnyObject>: ViewState<Wrapped?> {
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
    public override var projectedValue: ViewState<Wrapped?> { self }
    
    public override init(wrappedValue: Wrapped?) {
        super.init(wrappedValue: wrappedValue)
    }
    
    public override func observe<Observer: AnyObject>(observer: Observer) -> PropertyObservers<Observer, Wrapped?> {
        super.observe(observer: observer)
    }
    
    public override func remove<Observer>(observer: Observer) where Observer : AnyObject {
        super.remove(observer: observer)
    }
    
    public override func reset() {
        super.reset()
    }
    
    public override func removeBonding() {
        super.removeBonding()
    }
    
    public override func removeAllObservers() {
        super.removeAllObservers()
    }
}
