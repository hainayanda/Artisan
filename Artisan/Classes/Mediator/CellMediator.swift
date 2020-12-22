//
//  CellMediator.swift
//  Artisan
//
//  Created by Nayanda Haberty (ID) on 11/08/20.
//

import Foundation
import UIKit

public protocol CellMediator: Buildable {
    static var cellViewClass: AnyClass { get }
    static var cellReuseIdentifier: String { get }
    func isSameMediator(with other: CellMediator) -> Bool
}

public extension CellMediator {
    var reuseIdentifier: String {
        Self.cellReuseIdentifier
    }
    var cellClass: AnyClass {
        Self.cellViewClass
    }
    
    func isNotSameMediator(with other: CellMediator) -> Bool {
        return !isSameMediator(with: other)
    }
}

public protocol CollectionCellMediator: CellMediator {
    func apply(cell: UICollectionReusableView)
}

public protocol TableCellMediator: CellMediator {
    func apply(cell: UITableViewCell)
}

open class TableViewCellMediator<Cell: UITableViewCell>: ViewMediator<Cell>, TableCellMediator {
    
    public static var cellViewClass: AnyClass { Cell.self }
    public static var cellReuseIdentifier: String {
        let camelCaseName = String(describing: Cell.self).filter { $0.isLetter || $0.isNumber }.camelCaseToSnakeCase()
        return "artisan_managed_cell_\(camelCaseName)"
    }
    
    public var animateInteraction: Bool = false
    public var cellIdentifier: AnyHashable  = String.randomString()
    
    public func apply(cell: UITableViewCell) {
        guard let cell = cell as? Cell else {
            fatalError("UITableViewCell type is different with Mediator")
        }
        self.apply(to: cell)
    }
    
    open override func bonding(with view: Cell) {
        super.bonding(with: view)
    }
    
    open override func willApplying(_ view: View) {
        super.willApplying(view)
    }
    
    open override func didApplying(_ view: View) {
        super.didApplying(view)
    }
    
    open override func mediatorWillMapped(from view: View) {
        super.mediatorWillMapped(from: view)
    }
    
    open override func mediatorDidMapped(from view: View) {
        super.mediatorDidMapped(from: view)
    }
    
    open override func willLoosingBond(with view: View?) {
        super.willLoosingBond(with: view)
    }
    
    open override func didLoosingBond(with view: View?) {
        super.didLoosingBond(with: view)
    }
    
    public func isSameMediator(with other: CellMediator) -> Bool {
        guard let otherAsSelf = other as? Self else { return false }
        if otherAsSelf === self { return true }
        return otherAsSelf.cellIdentifier == cellIdentifier
    }
}

open class CollectionViewCellMediator<Cell: UICollectionViewCell>: ViewMediator<Cell>, CollectionCellMediator {
    
    public static var cellViewClass: AnyClass { Cell.self }
    public static var cellReuseIdentifier: String {
        let camelCaseName = String(describing: Cell.self).filter { $0.isLetter || $0.isNumber }.camelCaseToSnakeCase()
        return "artisan_managed_cell_\(camelCaseName)"
    }
    
    public var cellIdentifier: AnyHashable  = String.randomString()
    
    public func apply(cell: UICollectionReusableView) {
        guard let cell = cell as? Cell else {
            fatalError("UICollectionViewCell type is different with Mediator")
        }
        self.apply(to: cell)
    }
    
    open override func bonding(with view: Cell) {
        super.bonding(with: view)
    }
    
    open override func willApplying(_ view: View) {
        super.willApplying(view)
    }
    
    open override func didApplying(_ view: View) {
        super.didApplying(view)
    }
    
    open override func mediatorWillMapped(from view: View) {
        super.mediatorWillMapped(from: view)
    }
    
    open override func mediatorDidMapped(from view: View) {
        super.mediatorDidMapped(from: view)
    }
    
    open override func willLoosingBond(with view: View?) {
        super.willLoosingBond(with: view)
    }
    
    open override func didLoosingBond(with view: View?) {
        super.didLoosingBond(with: view)
    }
    
    public func isSameMediator(with other: CellMediator) -> Bool {
        guard let otherAsSelf = other as? Self else { return false }
        if otherAsSelf === self { return true }
        return otherAsSelf.cellIdentifier == cellIdentifier
    }
}
