//
//  UIView+Extension.swift
//  Artisan
//
//  Created by Nayanda Haberty (ID) on 05/07/20.
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
            objc_setAssociatedObject(self, &AssociatedKey.mediator, nil, .OBJC_ASSOCIATION_RETAIN)
            return
        }
        let wrapper: AssociatedWrapper = .init(wrapped: mediator as AnyObject)
        objc_setAssociatedObject(self, &AssociatedKey.mediator, wrapper, .OBJC_ASSOCIATION_RETAIN)
    }
}

extension UITableViewCell {
    public func getMediatorFromIndex() -> AnyTableCellMediator? {
        guard let tableView = parentTableView,
              let indexPath = tableView.indexPath(for: self),
              let section = tableView.sections[safe: indexPath.section],
              let cell = section.cells[safe: indexPath.item],
              cell.isCompatible(with: self) else {
            return nil
        }
        return cell
    }
}

extension UICollectionViewCell {
    public func getMediatorFromIndex() -> AnyCollectionCellMediator? {
        guard let collectionView = parentCollectionView,
              let indexPath = collectionView.indexPath(for: self),
              let section = collectionView.sections[safe: indexPath.section],
              let cell = section.cells[safe: indexPath.item],
              cell.isCompatible(with: self) else {
            return nil
        }
        return cell
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

extension UIView {
    func parentView<T: UIView>(of type: T.Type) -> T? {
        guard let view = superview else {
            return nil
        }
        return (view as? T) ?? view.parentView(of: T.self)
    }
}

extension UITableViewCell {
    var parentTableView: UITableView? {
        guard let nearestTable = parentView(of: UITableView.self),
              let _ = nearestTable.indexPath(for: self) else {
            return nil
        }
        return nearestTable
    }
}

extension UICollectionViewCell {
    var parentCollectionView: UICollectionView? {
        guard let nearestCollection = parentView(of: UICollectionView.self),
              let _ = nearestCollection.indexPath(for: self) else {
            return nil
        }
        return nearestCollection
    }
}
#endif
