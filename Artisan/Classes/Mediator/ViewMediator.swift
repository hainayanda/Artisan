//
//  ViewMediator.swift
//  Artisan
//
//  Created by Nayanda Haberty (ID) on 06/08/20.
//

import Foundation
#if canImport(UIKit)
import UIKit
import Pharos
import Draftsman

open class ViewMediator<View: NSObject>: NSObject, AnyMediator, Buildable {
    
    public weak var bondedView: View?
    var didMoveToSuperviewToken: NSObjectProtocol?
    
    required public override init() {
        super.init()
        didInit()
    }
    
    open func didInit() { }
    
    open func willBonded(with view: View) { }
    
    open func bonding(with view: View) { }
    
    open func didBonded(with view: View) { }
    
    open func willApplying(_ view: View) { }
    
    open func didApplying(_ view: View) { }
    
    public func bond(with view: View) {
        let currentMediator = view.getMediator()
        guard !(self === currentMediator as? Self) && bondedView != view else {
            return
        }
        currentMediator?.removeBond()
        willBonded(with: view)
        view.setMediator(self)
        bonding(with: view)
        bondedView = view
        didBonded(with: view)
    }
    
    public func apply(to view: View) {
        bond(with: view)
        guard !pendingApply(to: view) else {
            return
        }
        willApplying(view)
        observables.forEach { $0.invokeRelayWithCurrent() }
        didApplying(view)
    }
    
    func pendingApply(to view: View) -> Bool {
        if view is UITableViewCell || view is UICollectionReusableView {
            return false
        }
        if let uiView = view as? UIView, uiView.superview == nil {
            didMoveToSuperviewToken = uiView.whenDidMoveToSuperview { [weak self] view in
                guard let self = self else { return }
                guard let view = view as? View,
                      view.getMediator() as? Self == self else {
                    self.didMoveToSuperviewToken = nil
                    return
                }
                self.didMoveToSuperviewToken = nil
                self.apply(to: view)
            }
            return true
        } else if let uiViewController = view as? UIViewController, !uiViewController.isViewLoaded {
            didMoveToSuperviewToken = uiViewController.whenDidLoad { [weak self] view in
                guard let self = self else { return }
                guard let view = view as? View,
                      view.getMediator() as? Self == self else {
                    self.didMoveToSuperviewToken = nil
                    return
                }
                self.didMoveToSuperviewToken = nil
                self.apply(to: view)
            }
            return true
        }
        return false
    }
    
    public func removeBond() {
        observables.forEach {
            $0.removeBond()
            $0.removeAllRelay()
        }
        bondedView?.setMediator(nil)
        bondedView = nil
        bondDidRemoved()
    }
    
    open func bondDidRemoved() { }
}
#endif
