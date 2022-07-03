//
//  ViewBindable+Retaining.swift
//  Artisan
//
//  Created by Nayanda Haberty on 02/07/22.
//

import Foundation
import Pharos
import Draftsman
#if canImport(UIKit)

var bindingRetainerAssociatedKey = "Artisan_retain_binding"

public extension ViewBindable {
    
    internal var bindingRetainer: Retainer {
        guard let retainer = objc_getAssociatedObject(self, &bindingRetainerAssociatedKey) as? Retainer else {
            let newRetainer = Retainer()
            objc_setAssociatedObject(self, &bindingRetainerAssociatedKey, newRetainer, .OBJC_ASSOCIATION_RETAIN)
            return newRetainer
        }
        return retainer
    }
}

public typealias BindBuilder = ArrayBuilder<BindRetainable>
public typealias BindRetainables = [BindRetainable]

public protocol BindRetainable {
    @discardableResult
    func whileBind<View: ViewBindable>(with viewBindable: View) -> Invokable
    func observe(on dispatcher: DispatchQueue) -> Self
    func asynchronously() -> Self
}

extension BindRetainable where Self: ObservedSubject {
    @discardableResult
    public func whileBind<View: ViewBindable>(with viewBindable: View) -> Invokable {
        retained(by: viewBindable.bindingRetainer)
    }
}

extension Observed: BindRetainable { }
#endif
