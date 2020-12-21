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
    
    public func didTapped(then: @escaping (UIButton) -> Void) {
        let tappedClosure = TappedClosure(then)
        addTarget(tappedClosure, action: #selector(TappedClosure.invoke(with:)), for: .touchUpInside)
        objc_setAssociatedObject(self, &AssociatedKey.tappedClosure, tappedClosure, .OBJC_ASSOCIATION_RETAIN)
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
