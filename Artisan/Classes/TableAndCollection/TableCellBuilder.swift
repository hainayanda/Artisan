//
//  TableCellBuilder.swift
//  Artisan
//
//  Created by Nayanda Haberty on 16/04/21.
//

import Foundation
#if canImport(UIKit)
import UIKit

public protocol TableSectionCompatible {
    func getSection() -> TableSection?
}

public protocol TableCellCompatible: TableSectionCompatible {
    func generateCellMediators() -> [AnyTableCellMediator]
}

extension TableCellCompatible {
    public func getSection() -> TableSection? { nil }
}

extension UITableViewCell: TableCellCompatible { }

public extension TableCellCompatible where Self: UITableViewCell {
    func generateCellMediators() -> [AnyTableCellMediator] {
        [TableCellMediator<Self>()]
    }
}

struct EmptyTableCellCompatible: TableCellCompatible {
    func generateCellMediators() -> [AnyTableCellMediator] { [] }
}

struct ListTableCellCompatible: TableCellCompatible {
    let compatibles: [TableCellCompatible]
    func generateCellMediators() -> [AnyTableCellMediator] {
        compatibles.reduce([]) { cells, compatible in
            var mutableCells = cells
            mutableCells.append(contentsOf: compatible.generateCellMediators())
            return mutableCells
        }
    }
}

public struct ItemToTableMediator<Mediator: AnyTableCellMediator, Item>: TableCellCompatible {
    public typealias Builder = (inout Mediator, Item) -> Void
    let builder: Builder
    let items: [Item]
    
    public init(items: [Item], to mediatorType: Mediator.Type, _ builder: @escaping Builder) {
        self.items = items
        self.builder = builder
    }
    
    public func generateCellMediators() -> [AnyTableCellMediator] {
        var cells: [AnyTableCellMediator] = []
        for item in items {
            var cell = Mediator.init()
            builder(&cell, item)
            cells.append(cell)
        }
        return cells
    }
}

public struct ItemToTableCell<Cell: UITableViewCell, Item>: TableCellCompatible {
    public typealias Builder = (inout Cell, Item) -> Void
    let builder: Builder
    let items: [Item]
    
    public init(items: [Item], to cellType: Cell.Type, _ builder: @escaping Builder) {
        self.items = items
        self.builder = builder
    }
    
    public func generateCellMediators() -> [AnyTableCellMediator] {
        items.compactMap { item in
            TableClosureMediator<Cell> { cellBuilded in
                var mutableCell = cellBuilded
                builder(&mutableCell, item)
            }
        }
    }
}

@resultBuilder
public struct TableCellBuilder {
    public typealias Component = TableCellCompatible
    public typealias Result = [AnyTableCellMediator]
    
    public static func buildBlock(_ components: Component...) -> Result {
        components.reduce([], { cells, compatible in
            var mutableCells = cells
            mutableCells.append(contentsOf: compatible.generateCellMediators())
            return mutableCells
        })
    }
    
    public static func buildOptional(_ component: Component?) -> Component {
        guard let component = component else {
            return EmptyTableCellCompatible()
        }
        return component
    }
    
    public static func buildEither(first component: Component) -> Component {
        component
    }
    
    public static func buildArray(_ components: [Component]) -> Component {
        ListTableCellCompatible(compatibles: components)
    }
    
    public static func buildEither(second component: Component) -> Component {
        component
    }
}

@resultBuilder
public struct TableSectionBuilder {
    public typealias Component = TableSectionCompatible
    public typealias Result = [TableSection]
    
    public static func buildBlock(_ components: Component...) -> Result {
        var anonymousSectionCount: Int = 0
        var sections: Result = []
        var firstOrphanCell: Bool = true
        var lastSectionForOrphanCells = TableSection(identifier: anonymousSectionCount)
        for component in components {
            if let cell = component as? TableCellCompatible {
                if firstOrphanCell {
                    anonymousSectionCount += 1
                    lastSectionForOrphanCells = TableSection(identifier: anonymousSectionCount)
                    sections.append(lastSectionForOrphanCells)
                    firstOrphanCell = false
                }
                lastSectionForOrphanCells.add(cells: cell.generateCellMediators())
            } else if let section = component.getSection() {
                firstOrphanCell = true
                sections.append(section)
            }
        }
        return sections
    }
    
    public static func buildOptional(_ component: Component?) -> Component {
        guard let component = component else {
            return EmptyTableCellCompatible()
        }
        return component
    }
    
    public static func buildEither(first component: Component) -> Component {
        component
    }
    
    public static func buildEither(second component: Component) -> Component {
        component
    }
}
#endif
