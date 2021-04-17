//
//  UIControl+Extensions.swift
//  Artisan
//
//  Created by Nayanda Haberty on 17/04/21.
//

import Foundation
#if canImport(UIKit)
import UIKit

class UIControlAction {
    let closure: (UIControl) -> Void
    
    init(_ closure: @escaping (UIControl) -> Void) {
        self.closure = closure
    }
    
    @objc func invoke(by control: UIControl) {
        closure(control)
    }
}

public extension UIControl {
    func whenDidTriggered(by event: UIControl.Event, do action: @escaping (UIControl) -> Void) {
        let controlAction = UIControlAction(action)
        addTarget(controlAction, action: #selector(UIControlAction.invoke(by:)), for: event)
        objc_setAssociatedObject(
            self,
            String(ObjectIdentifier(self).hashValue)
                + String(event.rawValue)
            , controlAction,
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )
    }
    
    func whenDidTriggered<Object: AnyObject>(
        by event: UIControl.Event,
        invoke object: Object,
        method: @escaping (Object) -> (UIControl) -> Void) {
        let controlAction = UIControlAction { [weak object] control in
            guard let object = object else { return }
            method(object)(control)
        }
        addTarget(controlAction, action: #selector(UIControlAction.invoke(by:)), for: event)
        objc_setAssociatedObject(
            self,
            String(ObjectIdentifier(self).hashValue)
                + String(ObjectIdentifier(object).hashValue)
                + String(event.rawValue)
            , controlAction,
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )
    }
    
    func whenValueChanged(do action: @escaping (UIControl) -> Void) {
        whenDidTriggered(by: .valueChanged, do: action)
    }
    
    func whenValueChanged<Object: AnyObject>(invoke object: Object, method: @escaping (Object) -> (UIControl) -> Void) {
        whenDidTriggered(by: .valueChanged, invoke: object, method: method)
    }
}

public extension UIButton {
    func whenDidTapped(do action: @escaping (UIButton) -> Void) {
        whenDidTriggered(by: .touchUpInside, do: { control in
            guard let button = control as? UIButton else { return }
            action(button)
        })
    }
    
    func whenDidTapped<Object: AnyObject>(invoke object: Object, method: @escaping (Object) -> (UIButton) -> Void) {
        let controlAction = UIControlAction { [weak object] control in
            guard let object = object, let button = control as? UIButton else { return }
            method(object)(button)
        }
        let event: UIControl.Event = .touchUpInside
        addTarget(controlAction, action: #selector(UIControlAction.invoke(by:)), for: event)
        objc_setAssociatedObject(
            self,
            String(ObjectIdentifier(self).hashValue)
                + String(ObjectIdentifier(object).hashValue)
                + String(event.rawValue)
            , controlAction,
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )
    }
}
#endif
