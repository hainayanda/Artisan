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

public enum ViewBindDispatchMode {
    case onMain
    case onMainAsynchronously
    case manual
    
    @discardableResult
    func retain<View: ViewBindable>(_ retainable: BindRetainable, with view: View) -> Invokable {
        switch self {
        case .onMain:
            return retainable.observe(on: .main)
                .whileBind(with: view)
        case .onMainAsynchronously:
            return retainable.observe(on: .main)
                .asynchronously()
                .whileBind(with: view)
        case .manual:
            return retainable.whileBind(with: view)
        }
    }
}

public protocol ViewBindable {
    associatedtype Model
    var autoBindMode: ViewBindDispatchMode { get }
    var model: Model? { get }
    func viewWillBind(with newModel: Model, oldModel: Model?)
    @BindBuilder
    func autoBinding(with model: Model) -> BindRetainables
    @BindBuilder
    func autoFireBinding(with model: Model) -> BindRetainables
    func viewNeedBind(with model: Model)
    func viewDidBind(with newModel: Model, oldModel: Model?)
}

fileprivate var bindableModelAssociatedKey: String = "bindableModelAssociatedKey"

public enum ArtisanError: Error {
    case bindingError(reason: String)
}

extension ViewBindable {
    public var autoBindMode: ViewBindDispatchMode { .onMain }
    public func viewWillBind(with newModel: Model, oldModel: Model?) { }
    public func viewDidBind(with newModel: Model, oldModel: Model?) { }
    public func autoBinding(with model: Model) -> BindRetainables { [] }
    public func autoFireBinding(with model: Model) -> BindRetainables { [] }
    public func viewNeedBind(with model: Model) { }
}

extension ViewBindable {
    
    public var model: Model? {
        get {
            objc_getAssociatedObject(self, &bindableModelAssociatedKey) as? Model
        }
    }
    
    func removeModel() {
        objc_setAssociatedObject(self, &bindableModelAssociatedKey, nil, .OBJC_ASSOCIATION_RETAIN)
    }
    
    func assignModel(with model: Model) {
        objc_setAssociatedObject(self, &bindableModelAssociatedKey, model, .OBJC_ASSOCIATION_RETAIN)
    }
    
    public func bind(with model: Model) {
        let viewModel = model as? ViewModel
        let oldModel = self.model
        unbind()
        viewWillBind(with: model, oldModel: oldModel)
        viewModel?.willBind()
        doBind(with: model)
        viewModel?.didBind()
        viewDidBind(with: model, oldModel: oldModel)
    }
    
    func doBind(with model: Model) {
        assignModel(with: model)
        viewNeedBind(with: model)
        autoBinding(with: model).forEach {
            autoBindMode.retain($0, with: self)
        }
        autoFireBinding(with: model).forEach {
            autoBindMode.retain($0, with: self).fire()
        }
    }
    
    public func unbind() {
        guard let model = model else { return }
        let viewModel = model as? ViewModel
        viewModel?.willUnbind()
        bindingRetainer.discardAll()
        removeModel()
        viewModel?.didUnbind()
    }
    
    public func binding(with model: Model) -> Self {
        bind(with: model)
        return self
    }
}
#endif

