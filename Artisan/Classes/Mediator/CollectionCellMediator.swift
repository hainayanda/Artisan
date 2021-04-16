//
//  CollectionCellMediator.swift
//  Artisan
//
//  Created by Nayanda Haberty on 16/04/21.
//

import Foundation
#if canImport(UIKit)
import UIKit
import Draftsman
import Pharos

public protocol AnyCollectionCellMediator: CellMediator, Buildable {
    func apply(cell: UICollectionReusableView)
    func customCellSize(for collectionContentSize: CGSize) -> CGSize
    func didTap(cell: UICollectionReusableView)
}

open class CollectionCellMediator<Cell: UICollectionViewCell>: ViewMediator<Cell>, AnyCollectionCellMediator {
    
    public static var cellViewClass: AnyClass { Cell.self }
    
    public static var cellReuseIdentifier: String {
        let camelCaseName = String(describing: Cell.self)
            .filter { $0.isLetter || $0.isNumber }
            .camelCaseToSnakeCase()
        return "artisan_managed_cell_\(camelCaseName)"
    }
    
    @Observable public var distinctIdentifier: AnyHashable = UUID().uuidString
    
    open override func didInit() { }
    
    open override func willBonded(with view: Cell) { }
    
    open override func bonding(with view: Cell) { }
    
    open override func didBonded(with view: Cell) { }
    
    open override func willApplying(_ view: Cell) { }
    
    open override func didApplying(_ view: Cell) { }
    
    open func customCellSize(for collectionContentSize: CGSize) -> CGSize {
        .automatic
    }
    
    open func didTap(cell: UICollectionReusableView) { }
    
    public func apply(cell: UICollectionReusableView) {
        guard let cell = cell as? Cell else {
            fatalError("UITableViewCell type is not compatible with Mediator")
        }
        if let fragmentCell = cell as? CollectionFragmentCell {
            fragmentCell.whenNeedCellSize { [weak self] contentSize in
                self?.customCellSize(for: contentSize) ?? .automatic
            }
        }
        apply(to: cell)
    }
    
    public func isSame(with other: CellMediator) -> Bool {
        guard let otherAsSelf = other as? Self else { return false }
        if otherAsSelf === self { return true }
        return distinctIdentifier == other.distinctIdentifier
    }
    
    public func isCompatible<CellType: UIView>(with cell: CellType) -> Bool {
        cell is Cell
    }
}
#endif
