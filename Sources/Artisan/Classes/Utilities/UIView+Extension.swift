//
//  UIView+Extension.swift
//  Artisan
//
//  Created by Nayanda Haberty (ID) on 05/07/20.
//

import Foundation
#if canImport(UIKit)
import UIKit

extension NSObject {
    struct AssociatedKey {
        static var mediator: String = "Artisan_Mediator"
    }
    
    public func getMediator() -> AnyMediator? {
        var mediator: AnyMediator?
        if let cell = self as? UITableViewCell {
            if let fragment = cell as? TableFragmentCell {
                mediator = fragment.mediator
            }
            if mediator == nil,
               let indexMediator = cell.getMediatorFromIndex() {
                mediator = indexMediator
                indexMediator.apply(cell: cell)
            }
        } else if let cell = self as? UICollectionViewCell {
            if let fragment = cell as? CollectionFragmentCell {
                mediator = fragment.mediator
            }
            if mediator == nil,
               let indexMediator = cell.getMediatorFromIndex() {
                mediator = indexMediator
                indexMediator.apply(cell: cell)
            }
        }
        guard let unwrappedMediator = mediator else {
            let wrapper = objc_getAssociatedObject(self, &AssociatedKey.mediator) as? AssociatedWrapper
            return wrapper?.wrapped as? AnyMediator
        }
        return unwrappedMediator
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
