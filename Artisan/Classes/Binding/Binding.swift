//
//  Binding.swift
//  Artisan
//
//  Created by Nayanda Haberty on 29/05/22.
//

import Foundation
#if canImport(UIKit)
import UIKit
import Pharos

// MARK: ViewBinding

public protocol ViewBinding: ObjectRetainer {
    associatedtype DataBinding
    associatedtype Subscriber

    var subscriber: Subscriber? { get set }
    func bindData(from dataBinding: DataBinding)
}

fileprivate var responderAssociatedKey: String = "responderAssociatedKey"
fileprivate var bindableModelAssociatedKey: String = "bindableModelAssociatedKey"

extension ViewBinding {
    var bindableModel: BindableModel? {
        get {
            objc_getAssociatedObject(self, &bindableModelAssociatedKey) as? BindableModel
        }
        set {
            objc_setAssociatedObject(self, &bindableModelAssociatedKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }

    public var subscriber: Subscriber? {
        get {
            objc_getAssociatedObject(self, &responderAssociatedKey) as? Subscriber
        }
        set {
            objc_setAssociatedObject(self, &responderAssociatedKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    public func tryGetViewModel<VM: ViewModel>(castedAs type: VM.Type) -> VM?  where Subscriber == VM.Subscriber, DataBinding == VM.DataBinding {
        bindableModel as? VM
    }

    public func bind<VM: ViewModel>(with viewModel: VM) where Subscriber == VM.Subscriber, DataBinding == VM.DataBinding {
        unbind()
        viewModel.willBind()
        bindableModel = viewModel
        subscriber = viewModel.asSubscriber
        bindData(from: viewModel.asDataBinding)
        viewModel.didBind()
    }

    public func unbind() {
        bindableModel?.willUnbind()
        subscriber = nil
        discardAllRetained()
        bindableModel = nil
        bindableModel?.didUnbind()
    }
}

// MARK: BindableModel

public protocol BindableModel: ObjectRetainer {
    func willBind()
    func didBind()
    func willUnbind()
    func didUnbind()
}

extension BindableModel {
    public func willBind() { }
    public func didBind() { }
    public func willUnbind() { }
    public func didUnbind() { }
}

// MARK: ViewModel

public protocol ViewModel: BindableModel {
    associatedtype Subscriber
    associatedtype DataBinding

    var asSubscriber: Subscriber { get }
    var asDataBinding: DataBinding { get }
}

extension ViewModel {

    public var asSubscriber: Subscriber {
        if Subscriber.self == Void.self {
            return Void() as! Self.Subscriber
        }
        guard let asSubscriber = self as? Subscriber else {
            fatalError("Please implement Responder protocol into ViewModel or implement input manually")
        }
        return asSubscriber
    }

    public var asDataBinding: DataBinding {
        if DataBinding.self == Void.self {
            return Void() as! Self.DataBinding
        }
        guard let asDataBinding = self as? DataBinding else {
            fatalError("Please implement DataSource protocol into ViewModel or implement output manually")
        }
        return asDataBinding
    }
}
#endif

