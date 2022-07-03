//
//  Maker+Extensions.swift
//  Artisan
//
//  Created by Nayanda Haberty on 30/05/22.
//

import Foundation
#if canImport(UIKit)
import UIKit
import Builder
import Pharos

public extension Maker where Object: UIView {
    func sizeToFit() -> Self {
        underlyingObject.sizeToFit()
        return self
    }
}

public extension Maker where Object: UIControl {
    func whenDidTriggered(by event: UIControl.Event, do action: @escaping (UIControl) -> Void) -> Self {
        underlyingObject.whenDidTriggered(by: event) { changes in
            guard let control = changes.source as? UIControl else { return }
            action(control)
        }.retain()
        return self
    }
    
    func whenDidTriggered<Object: AnyObject>(
        by event: UIControl.Event,
        invoke object: Object,
        method: @escaping (Object) -> (UIControl) -> Void) -> Self {
            whenDidTriggered(by: event) { [weak object] control in
                guard let object = object else { return }
                method(object)(control)
            }
        }
    
    func whenValueChanged(do action: @escaping (UIControl) -> Void) -> Self {
        whenDidTriggered(by: .valueChanged, do: action)
    }
    
    func whenValueChanged<Object: AnyObject>(invoke object: Object, method: @escaping (Object) -> (UIControl) -> Void) -> Self {
        whenDidTriggered(by: .valueChanged, invoke: object, method: method)
    }
}

public extension Maker where Object: UIButton {
    func setTitle(_ title: String?, for state: UIControl.State) -> Self {
        underlyingObject.setTitle(title, for: state)
        return self
    }
    
    func setTitleColor(_ color: UIColor?, for state: UIControl.State) -> Self {
        underlyingObject.setTitleColor(color, for: state)
        return self
    }
    
    func setTitleShadowColor(_ color: UIColor?, for state: UIControl.State) -> Self {
        underlyingObject.setTitleShadowColor(color, for: state)
        return self
    }
    
    func setImage(_ image: UIImage?, for state: UIControl.State) -> Self {
        underlyingObject.setImage(image, for: state)
        return self
    }
    
    func setBackgroundImage(_ image: UIImage?, for state: UIControl.State) -> Self {
        underlyingObject.setBackgroundImage(image, for: state)
        return self
    }
    
    @available(iOS 13.0, *)
    func setPreferredSymbolConfiguration(_ configuration: UIImage.SymbolConfiguration?, forImageIn state: UIControl.State) -> Self {
        underlyingObject.setPreferredSymbolConfiguration(configuration, forImageIn: state)
        return self
    }
    
    func setAttributedTitle(_ title: NSAttributedString?, for state: UIControl.State) -> Self {
        underlyingObject.setAttributedTitle(title, for: state)
        return self
    }
    
    func whenDidTapped(do action: @escaping (UIButton) -> Void) -> Self {
        underlyingObject.whenDidTapped { changes in
            guard let control = changes.source as? UIButton else { return }
            action(control)
        }.retain()
        return self
    }
    
    func whenDidTapped<SomeObject: AnyObject>(invoke object: SomeObject, method: @escaping (SomeObject) -> (UIButton) -> Void) -> Self {
        whenDidTapped { [weak object] button in
            guard let object = object else { return }
            method(object)(button)
        }
    }
}
#endif
