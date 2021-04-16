//
//  NSObject+Extension.swift
//  Artisan
//
//  Created by Nayanda Haberty on 16/04/21.
//

import Foundation
#if canImport(UIKit)
import UIKit
import Draftsman

extension NSObject {
    struct AssociatedKey {
        static var mediator: String = "Artisan_Mediator"
    }
    
    public func getMediator() -> AnyMediator? {
        guard let wrapper = objc_getAssociatedObject(self, &AssociatedKey.mediator) as? AssociatedWrapper else {
            if let cell = self as? UITableViewCell,
               let indexMediator = cell.getMediatorFromIndex() {
                setMediator(indexMediator)
                return indexMediator
            } else if let cell = self as? UICollectionViewCell,
                      let indexMediator = cell.getMediatorFromIndex() {
                setMediator(indexMediator)
                return indexMediator
            }
            return nil
        }
        return wrapper.wrapped as? AnyMediator
    }
    
    public func setMediator(_ mediator: AnyMediator?) {
        guard let mediator = mediator else {
            objc_setAssociatedObject(self, &AssociatedKey.mediator, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return
        }
        let wrapper: AssociatedWrapper = .init(wrapped: mediator as AnyObject)
        objc_setAssociatedObject(self, &AssociatedKey.mediator, wrapper, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}

@objc class AssociatedWrapper: NSObject {
    var wrapped: AnyObject
    
    init(wrapped: AnyObject) {
        self.wrapped = wrapped
    }
}
#endif
