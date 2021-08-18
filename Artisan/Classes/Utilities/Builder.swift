//
//  Builder.swift
//  Artisan
//
//  Created by Nayanda Haberty on 18/08/21.
//

import Foundation
#if canImport(UIKit)
import UIKit
import Builder

extension UIView: Buildable { }

public func builder<B: Buildable>(_ type: B.Type = B.self, _ builder: (inout B) -> Void) -> B {
    var buildable = B.init()
    builder(&buildable)
    return buildable
}

public func builder<Object>(_ object: Object, _ builder: (inout Object) -> Void) -> Object {
    var object = object
    builder(&object)
    return object
}
#endif
