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

public protocol ViewBindable: ObjectRetainer {
    associatedtype Model

    var model: Model? { get }
    func viewNeedBind(with model: Model)
}

fileprivate var bindableModelAssociatedKey: String = "bindableModelAssociatedKey"

public enum ArtisanError: Error {
    case bindingError(reason: String)
}

extension ViewBindable {
    
    public internal(set) var model: Model? {
        get {
            objc_getAssociatedObject(self, &bindableModelAssociatedKey) as? Model
        }
        set {
            objc_setAssociatedObject(self, &bindableModelAssociatedKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }

    public func bind(with model: Model) {
        let viewModel = model as? ViewModel
        unbind()
        viewModel?.willBind()
        self.model = model
        viewNeedBind(with: model)
        viewModel?.didBind()
    }

    public func unbind() {
        guard let model = model else { return }
        let viewModel = model as? ViewModel
        viewModel?.willUnbind()
        discardAllRetained()
        self.model = nil
        viewModel?.didUnbind()
    }
    
    public func binding(with model: Model) -> Self {
        bind(with: model)
        return self
    }
}
#endif

