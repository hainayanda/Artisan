//
//  UIView+Extension.swift
//  Artisan
//
//  Created by Nayanda Haberty (ID) on 05/07/20.
//

import Foundation
#if canImport(UIKit)
import UIKit

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
    public var nextViewController: UIViewController? {
        next as? UIViewController ?? next?.nextViewController
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
    
    var parentCollectionView: UICollectionView? {
        guard let nearestCollection = parentView(of: UICollectionView.self),
              let _ = nearestCollection.indexPath(for: self) else {
            return nil
        }
        return nearestCollection
    }
    
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

extension UITableView {
    
    func registerNewCell(from sections: [UITableView.Section]) {
        var registeredCells: [String] = []
        for section in sections {
            for cell in section.cells where !registeredCells.contains(cell.reuseIdentifier) {
                self.register(cell.cellClass, forCellReuseIdentifier: cell.reuseIdentifier)
                registeredCells.append(cell.reuseIdentifier)
            }
        }
    }
    
    var sizeOfContent: CGSize {
        let width: CGFloat = contentSize.width - contentInset.horizontal.both
        let height: CGFloat = contentSize.height - contentInset.vertical.both
        return .init(width: width, height: height)
    }
}

extension UICollectionView {
    
    func registerNewCell(from sections: [UICollectionView.Section]) {
        self.register(
            UICollectionViewCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "Artisan_Layout_plain_\(UICollectionView.elementKindSectionHeader)"
        )
        self.register(
            UICollectionViewCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: "Artisan_Layout_plain_\(UICollectionView.elementKindSectionFooter)"
        )
        self.register(
            UICollectionViewCell.self,
            forCellWithReuseIdentifier: "Artisan_Layout_plain_cell"
        )
        var registeredCells: [String] = []
        var registeredHeaderSupplements: [String] = []
        var registeredFooterSupplements: [String] = []
        for section in sections {
            for cell in section.cells where !registeredCells.contains(cell.reuseIdentifier) {
                self.register(cell.cellClass, forCellWithReuseIdentifier: cell.reuseIdentifier)
                registeredCells.append(cell.reuseIdentifier)
            }
            if let supplementSection = section as? UICollectionView.SupplementedSection {
                if let header = supplementSection.header,
                   !registeredHeaderSupplements.contains(header.reuseIdentifier) {
                    self.register(
                        header.cellClass,
                        forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                        withReuseIdentifier: header.reuseIdentifier
                    )
                    registeredHeaderSupplements.append(header.reuseIdentifier)
                }
                if let footer = supplementSection.footer,
                   !registeredFooterSupplements.contains(footer.reuseIdentifier) {
                    self.register(
                        footer.cellClass,
                        forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                        withReuseIdentifier: footer.reuseIdentifier
                    )
                    registeredFooterSupplements.append(footer.reuseIdentifier)
                }
            }
        }
    }
    
    var sizeOfContent: CGSize {
        let contentWidth: CGFloat = contentSize.width
        let contentHeight: CGFloat = contentSize.height
        let contentInset: UIEdgeInsets = self.contentInset
        let sectionInset: UIEdgeInsets = (collectionViewLayout as? UICollectionViewFlowLayout)?
            .sectionInset ?? .zero
        let collectionContentWidth = contentWidth - contentInset.horizontal.both - sectionInset.horizontal.both
        let collectionContentHeight = contentHeight - contentInset.vertical.both - sectionInset.vertical.both
        return .init(width: collectionContentWidth, height: collectionContentHeight)
    }
}
#endif
