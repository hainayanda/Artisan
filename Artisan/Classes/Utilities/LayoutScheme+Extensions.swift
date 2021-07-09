//
//  LayoutScheme.swift
//  Artisan
//
//  Created by Nayanda Haberty (ID) on 18/08/20.
//

import Foundation
#if canImport(UIKit)
import UIKit
import Draftsman
import Pharos

public extension LayoutScheme {
    
    internal var viewInScheme: View {
        view as! View
    }
    
    @discardableResult
    func buildView(_ applicator: (View) -> Void) -> Self {
        applicator(viewInScheme)
        return self
    }
    
    @discardableResult
    func applyTo<VM: ViewMediator<View>>(mediator: VM) -> Self {
        mediator.apply(to: viewInScheme)
        return self
    }
    
    @discardableResult
    func bondingWith<VM: ViewMediator<View>>(mediator: VM) -> Self {
        mediator.bonding(with: viewInScheme)
        return self
    }
}
#endif
