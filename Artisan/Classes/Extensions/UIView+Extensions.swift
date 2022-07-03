//
//  UIView+Extensions.swift
//  Artisan
//
//  Created by Nayanda Haberty on 28/05/22.
//

import Foundation
#if canImport(UIKit)
import UIKit
import Pharos
import Builder

extension UIResponder: ObjectRetainer { }

extension UIView: Buildable { }

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
    
    @available(*, deprecated, message: "Use whenDidTriggered from Pharos instead")
    func whenValueChanged(do action: @escaping (UIControl) -> Void) {
        whenDidTriggered(by: .valueChanged) { changes in
            guard let control = changes.source as? UIControl else { return }
            action(control)
        }.retain()
    }
    
    @available(*, deprecated, message: "Use whenDidTriggered from Pharos instead")
    func whenValueChanged<Object: AnyObject>(invoke object: Object, method: @escaping (Object) -> (UIControl) -> Void) {
        whenDidTriggered(by: .valueChanged) { [weak object] changes in
            guard let object = object, let control = changes.source as? UIControl else { return }
            method(object)(control)
        }.retain()
    }
}
#endif
