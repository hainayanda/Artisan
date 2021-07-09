//
//  TableCellMediator.swift
//  Artisan
//
//  Created by Nayanda Haberty on 16/04/21.
//

import Foundation
#if canImport(UIKit)
import UIKit
import Draftsman
import Pharos

public protocol AnyTableCellMediator: TableCellCompatible, CellMediator, Buildable {
    func apply(cell: UITableViewCell)
    func customCellHeight(for cellWidth: CGFloat) -> CGFloat
    func didTap(cell: UITableViewCell)
}

open class TableCellMediator<Cell: UITableViewCell>: ViewMediator<Cell>, AnyTableCellMediator {
    
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
    
    open func customCellHeight(for cellWidth: CGFloat) -> CGFloat {
        .automatic
    }
    
    open func didTap(cell: UITableViewCell) { }
    
    public func apply(cell: UITableViewCell) {
        guard let cell = cell as? Cell else {
            fatalError("UITableViewCell type is not compatible with Mediator")
        }
        if let fragmentCell = cell as? TableFragmentCell {
            fragmentCell.whenNeedCellHeight { [weak self] width in
                self?.customCellHeight(for: width) ?? .automatic
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
    
    public func generateCellMediators() -> [AnyTableCellMediator] {
        [self]
    }
}
#endif
