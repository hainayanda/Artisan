//
//  UIView+Extension.swift
//  Artisan
//
//  Created by Nayanda Haberty (ID) on 05/07/20.
//

import Foundation
import UIKit

extension NSObject {
    struct AssociatedKey {
        static var mediator: String = "Artisan_Mediator"
    }
    
    public func getMediator() -> AnyObject? {
        var mediator: AnyObject?
        if let cell = self as? TableFragmentCell {
            mediator = cell.mediator as AnyObject
        } else if let cell = self as? CollectionFragmentCell {
            mediator = cell.mediator as AnyObject
        }
        guard let unwrappedMediator = mediator else {
            let wrapper = objc_getAssociatedObject(self, &AssociatedKey.mediator) as? AssociatedWrapper
            return wrapper?.wrapped
        }
        return unwrappedMediator
    }
}

extension UISearchBar {
    
    var textField: UITextField {
        if #available(iOS 13, *) {
            return searchTextField
        } else {
            return self.value(forKey: "_searchField") as! UITextField
        }
    }
    
}

extension UIResponder {
    public var parentViewController: UIViewController? {
        next as? UIViewController ?? next?.parentViewController
    }
}
