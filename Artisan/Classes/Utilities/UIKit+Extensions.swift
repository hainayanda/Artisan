//
//  UIKit+Extensions.swift
//  Artisan
//
//  Created by Nayanda Haberty (ID) on 07/08/20.
//

import Foundation
import UIKit

fileprivate func assignIfDifferent<V: Equatable>(into: inout V, value: V) {
    guard into != value else { return }
    into = value
}

extension UIView: Buildable { }

extension UILabel {
    public var textCompat: TextCompatible? {
        set {
            if let attributedText = newValue as? NSAttributedString {
                self.attributedText = attributedText
            } else if let text = newValue as? String {
                self.text = text
            } else {
                self.text = nil
            }
        }
        get {
            return attributedText
        }
    }
}

public protocol TextCompatible {
    var text: String { get }
    var attributedText: NSAttributedString { get }
}

extension String: TextCompatible {
    public var text: String { self }
    
    public var attributedText: NSAttributedString { .init(string: self) }
}
extension NSAttributedString: TextCompatible {
    public var text: String { self.string }
    public var attributedText: NSAttributedString { self }
}

extension UIImageView {
    
    public var imageCompat: ImageCompatible? {
        set {
            if let animation = newValue as? Animation {
                assignIfDifferent(into: &animationImages, value: animation.images)
                assignIfDifferent(into: &animationDuration, value: animation.duration)
                assignIfDifferent(into: &animationRepeatCount, value: animation.repeatCount)
                if animation.animating {
                    self.startAnimating()
                } else {
                    self.stopAnimating()
                }
                self.image = nil
            } else if let image = newValue as? UIImage {
                self.image = image
                self.animationImages = nil
            } else {
                self.image = nil
                self.animationImages = nil
            }
        }
        get {
            if let image = self.image {
                return image
            } else if let images = self.animationImages {
                return Animation(
                    images: images,
                    duration: self.animationDuration,
                    animating: self.isAnimating,
                    repeatCount: self.animationRepeatCount
                )
            }
            return nil
        }
    }
    
    public class Animation: Equatable {
        
        public var images: [UIImage]
        public var duration: TimeInterval
        public var animating: Bool
        public var repeatCount: Int
        
        public init(images: [UIImage], duration: TimeInterval, animating: Bool = true, repeatCount: Int = 0) {
            self.images = images
            self.duration = duration
            self.animating = animating
            self.repeatCount = repeatCount
        }
        
        public static func == (lhs: UIImageView.Animation, rhs: UIImageView.Animation) -> Bool {
            lhs.images == rhs.images && lhs.duration == rhs.duration
                && lhs.animating == rhs.animating && lhs.repeatCount == rhs.repeatCount
        }
        
    }
}

public protocol ImageCompatible { }

extension UIImage: ImageCompatible { }
extension UIImageView.Animation: ImageCompatible { }

extension UIButton {
    
    struct AssociatedKey {
        static var tappedClosure: String = "Artisan_Tapped_Closure"
    }
    
    @objc class TappedClosure: NSObject {
        let closure: (UIButton) -> Void
        
        init(_ closure: @escaping (UIButton) -> Void) {
            self.closure = closure
        }
        
        @objc func invoke(with sender: UIButton) {
            closure(sender)
        }
    }
    
    public func whenDidTapped(then: @escaping (UIButton) -> Void) {
        let tappedClosure = TappedClosure(then)
        addTarget(tappedClosure, action: #selector(TappedClosure.invoke(with:)), for: .touchUpInside)
        objc_setAssociatedObject(self, &AssociatedKey.tappedClosure, tappedClosure, .OBJC_ASSOCIATION_RETAIN)
    }
    
    public func whenDidTapped<Observer: AnyObject>(observing observer: Observer, then: @escaping (Observer, UIButton) -> Void) {
        let eventClosure = TappedClosure { [weak observer] button in
            guard let observer = observer else { return }
            then(observer, button)
        }
        addTarget(eventClosure, action: #selector(TappedClosure.invoke(with:)), for: .touchUpInside)
        objc_setAssociatedObject(self, &AssociatedKey.tappedClosure, eventClosure, .OBJC_ASSOCIATION_RETAIN)
    }
    
    public func whenDidTapped<Observer: AnyObject>(observing observer: Observer, thenCall method: @escaping (Observer) -> ((UIButton) -> Void)) {
        let eventClosure = TappedClosure { [weak observer] button in
            guard let observer = observer else { return }
            method(observer)(button)
        }
        addTarget(eventClosure, action: #selector(TappedClosure.invoke(with:)), for: .touchUpInside)
        objc_setAssociatedObject(self, &AssociatedKey.tappedClosure, eventClosure, .OBJC_ASSOCIATION_RETAIN)
    }
}

extension UITextField {
    
    public var textCompat: TextCompatible? {
        set {
            if let attributedText = newValue as? NSAttributedString {
                self.attributedText = attributedText
            } else if let text = newValue as? String {
                self.text = text
            } else {
                self.text = nil
            }
        }
        get {
            return attributedText
        }
    }
    
    public var placeholderCompat: TextCompatible? {
        set {
            if let attributedText = newValue as? NSAttributedString {
                self.attributedPlaceholder = attributedText
            } else if let text = newValue as? String {
                self.placeholder = text
            } else {
                self.placeholder = nil
            }
        }
        get {
            return attributedPlaceholder
        }
    }
}

extension UITextView {
    
    public var textCompat: TextCompatible? {
        set {
            if let attributedText = newValue as? NSAttributedString {
                self.attributedText = attributedText
            } else if let text = newValue as? String {
                self.text = text
            } else {
                self.text = nil
            }
        }
        get {
            return attributedText
        }
    }
}

extension UIControl {
    
    struct AssociatedKey {
        static var touchDown: String = "Artisan_touchDown_event"
        static var touchDownRepeat: String = "Artisan_touchDownRepeat_event"
        static var touchDragInside: String = "Artisan_touchDragInside_event"
        static var touchDragOutside: String = "Artisan_touchDragOutside_event"
        static var touchDragEnter: String = "Artisan_touchDragEnter_event"
        static var touchDragExit: String = "Artisan_touchDragExit_event"
        static var touchUpInside: String = "Artisan_touchUpInside_event"
        static var touchUpOutside: String = "Artisan_touchUpOutside_event"
        static var touchCancel: String = "Artisan_touchCancel_event"
        static var valueChanged: String = "Artisan_valueChanged_event"
        static var primaryActionTriggered: String = "Artisan_primaryActionTriggered_event"
        @available(iOS 14.0, *)
        static var menuActionTriggered: String = "Artisan_menuActionTriggered_event"
        static var editingDidBegin: String = "Artisan_editingDidBegin_event"
        static var editingChanged: String = "Artisan_editingChanged_event"
        static var editingDidEnd: String = "Artisan_editingDidEnd_event"
        static var editingDidEndOnExit: String = "Artisan_editingDidEndOnExit_event"
        static var allTouchEvents: String = "Artisan_allTouchEvents_event"
        static var allEditingEvents: String = "Artisan_allEditingEvents_event"
        static var applicationReserved: String = "Artisan_applicationReserved_event"
        static var systemReserved: String = "Artisan_systemReserved_event"
        static var allEvents: String = "Artisan_allEvents_event"
        
        static var eventKeys: [UIControl.Event: UnsafeRawPointer] {
            var keys: [UIControl.Event: UnsafeRawPointer] = [
                .touchDown: .init(&touchDown),
                .touchDownRepeat: .init(&touchDownRepeat),
                .touchDragInside: .init(&touchDragInside),
                .touchDragOutside: .init(&touchDragOutside),
                .touchDragEnter: .init(&touchDragEnter),
                .touchDragExit: .init(&touchDragExit),
                .touchUpInside: .init(&touchUpInside),
                .touchUpOutside: .init(&touchUpOutside),
                .touchCancel: .init(&touchCancel),
                .valueChanged: .init(&valueChanged),
                .primaryActionTriggered: .init(&primaryActionTriggered),
                .editingDidBegin: .init(&editingDidBegin),
                .editingChanged: .init(&editingChanged),
                .editingDidEnd: .init(&editingDidEnd),
                .editingDidEndOnExit: .init(&editingDidEndOnExit),
                .allTouchEvents: .init(&allTouchEvents),
                .allEditingEvents: .init(&allEditingEvents),
                .applicationReserved: .init(&applicationReserved),
                .systemReserved: .init(&systemReserved),
                .allEvents: .init(&allEvents)
            ]
            if #available(iOS 14.0, *) {
                keys[.menuActionTriggered] = .init(&menuActionTriggered)
            }
            return keys
        }
    }
    
    @objc class EventClosure: NSObject {
        let closure: (UIControl) -> Void
        
        init(_ closure: @escaping (UIControl) -> Void) {
            self.closure = closure
        }
        
        @objc func invoke(with sender: UIControl) {
            closure(sender)
        }
    }
    
    public func whenDidTriggered(by event: UIControl.Event, then: @escaping (UIControl) -> Void) {
        guard let eventAssociatedKey = AssociatedKey.eventKeys[event] else {
            return
        }
        let eventClosure = EventClosure(then)
        addTarget(eventClosure, action: #selector(EventClosure.invoke(with:)), for: event)
        objc_setAssociatedObject(self, eventAssociatedKey, eventClosure, .OBJC_ASSOCIATION_RETAIN)
    }
    
    public func whenDidTriggered<Observer: AnyObject>(by event: UIControl.Event, observing observer: Observer, then: @escaping (Observer, UIControl) -> Void) {
        guard let eventAssociatedKey = AssociatedKey.eventKeys[event] else {
            return
        }
        let eventClosure = EventClosure { [weak observer] control in
            guard let observer = observer else { return }
            then(observer, control)
        }
        addTarget(eventClosure, action: #selector(EventClosure.invoke(with:)), for: event)
        objc_setAssociatedObject(self, eventAssociatedKey, eventClosure, .OBJC_ASSOCIATION_RETAIN)
    }
    
    public func whenDidTriggered<Observer: AnyObject>(by event: UIControl.Event, observing observer: Observer, thenCall method: @escaping (Observer) -> ((UIControl) -> Void)) {
        guard let eventAssociatedKey = AssociatedKey.eventKeys[event] else {
            return
        }
        let eventClosure = EventClosure { [weak observer] control in
            guard let observer = observer else { return }
            method(observer)(control)
        }
        addTarget(eventClosure, action: #selector(EventClosure.invoke(with:)), for: event)
        objc_setAssociatedObject(self, eventAssociatedKey, eventClosure, .OBJC_ASSOCIATION_RETAIN)
    }
}

extension UIControl.Event: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.rawValue)
    }
}
