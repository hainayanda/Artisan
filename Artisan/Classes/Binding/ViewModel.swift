//
//  ViewModel.swift
//  Artisan
//
//  Created by Nayanda Haberty on 05/06/22.
//

import Foundation
#if canImport(UIKit)
import UIKit
import Pharos

public protocol ViewModel {
    func willBind()
    func didBind()
    func willUnbind()
    func didUnbind()
}

public typealias RetainingViewModel = ViewModel & ObjectRetainer

extension ViewModel {
    public func willBind() { }
    public func didBind() { }
    public func willUnbind() { }
    public func didUnbind() { }
}

public protocol IntermediateModel: Hashable {
    var distinctifier: AnyHashable { get }
}

extension IntermediateModel {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(distinctifier)
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.distinctifier == rhs.distinctifier
    }
}
#endif
