//
//  MoveToSuperSwizzling.swift
//  Artisan
//
//  Created by Nayanda Haberty on 17/04/21.
//

import Foundation
#if canImport(UIKit)
import UIKit

var didMoveToSuperviewNotification: Notification.Name = .init("Artisan_didMoveToSuperview")
var didMoveToSuperviewSwizzled: Bool = false

extension UIView {
    
    func whenDidMoveToSuperview(then run: @escaping (UIView) -> Void) -> NSObjectProtocol? {
        if !didMoveToSuperviewSwizzled {
            let oriMethod = class_getInstanceMethod(UIView.self, #selector(UIView.didMoveToSuperview))
            let swizMethod = class_getInstanceMethod(UIView.self, #selector(UIView.observedDidMoveToSuperview))
            guard let originalMethod = oriMethod, let swizzleMethod = swizMethod else { return nil }
            method_exchangeImplementations(originalMethod, swizzleMethod)
            didMoveToSuperviewSwizzled = true
        }
        return NotificationCenter.default.addObserver(
            forName: didMoveToSuperviewNotification,
            object: self,
            queue: nil) { notification in
            guard let view = notification.object as? Self else { return }
            run(view)
        }
    }
    
    @objc func observedDidMoveToSuperview() {
        self.observedDidMoveToSuperview()
        NotificationCenter.default.post(name: didMoveToSuperviewNotification, object: self)
    }
}

var viewDidLoadNotification: Notification.Name = .init("Artisan_viewDidLoad")
var viewDidLoadSwizzled: Bool = false

extension UIViewController {
    func whenDidLoad(then run: @escaping (UIViewController) -> Void) -> NSObjectProtocol? {
        if !viewDidLoadSwizzled {
            let oriMethod = class_getInstanceMethod(UIViewController.self, #selector(UIViewController.viewDidLoad))
            let swizMethod = class_getInstanceMethod(UIViewController.self, #selector(UIViewController.observedViewDidLoad))
            guard let originalMethod = oriMethod, let swizzleMethod = swizMethod else { return nil }
            method_exchangeImplementations(originalMethod, swizzleMethod)
            viewDidLoadSwizzled = true
        }
        return NotificationCenter.default.addObserver(
            forName: viewDidLoadNotification,
            object: self,
            queue: nil) { notification in
            guard let view = notification.object as? Self else { return }
            run(view)
        }
    }
    
    @objc func observedViewDidLoad() {
        self.observedViewDidLoad()
        NotificationCenter.default.post(name: viewDidLoadNotification, object: self)
    }
}
#endif
