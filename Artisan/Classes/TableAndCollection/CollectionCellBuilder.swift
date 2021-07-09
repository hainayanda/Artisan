//
//  CollectionCellBuilder.swift
//  Artisan
//
//  Created by Nayanda Haberty on 16/04/21.
//

import Foundation
#if canImport(UIKit)
import UIKit

public protocol CollectionSectionCompatible {
    func getSection() -> CollectionSection?
}

public protocol CollectionCellCompatible: CollectionSectionCompatible {
    func generateCellMediators() -> [AnyCollectionCellMediator]
}

extension CollectionCellCompatible {
    public func getSection() -> CollectionSection? { nil }
}

extension UICollectionViewCell: CollectionCellCompatible { }

public extension CollectionCellCompatible where Self: UICollectionViewCell {
    func generateCellMediators() -> [AnyCollectionCellMediator] {
        [CollectionCellMediator<Self>()]
    }
}

struct EmptyCollectionCellCompatible: CollectionCellCompatible {
    func generateCellMediators() -> [AnyCollectionCellMediator] { [] }
}

struct ListCollectionCellCompatible: CollectionCellCompatible {
    let compatibles: [CollectionCellCompatible]
    func generateCellMediators() -> [AnyCollectionCellMediator] {
        compatibles.reduce([]) { cells, compatible in
            var mutableCells = cells
            mutableCells.append(contentsOf: compatible.generateCellMediators())
            return mutableCells
        }
    }
}

public struct ItemToCollectionMediator<Mediator: AnyCollectionCellMediator, Item>: CollectionCellCompatible {
    public typealias Builder = (inout Mediator, Item) -> Void
    let builder: Builder
    let items: [Item]
    
    public init(items: [Item], to mediatorType: Mediator.Type, _ builder: @escaping Builder) {
        self.items = items
        self.builder = builder
    }
    
    public func generateCellMediators() -> [AnyCollectionCellMediator] {
        var cells: [AnyCollectionCellMediator] = []
        for item in items {
            var cell = Mediator.init()
            builder(&cell, item)
            cells.append(cell)
        }
        return cells
    }
}

public struct ItemToCollectionCell<Cell: UICollectionViewCell, Item>: CollectionCellCompatible {
    public typealias Builder = (inout Cell, Item) -> Void
    let builder: Builder
    let items: [Item]
    
    public init(items: [Item], to cellType: Cell.Type, _ builder: @escaping Builder) {
        self.items = items
        self.builder = builder
    }
    
    public func generateCellMediators() -> [AnyCollectionCellMediator] {
        items.compactMap { item in
            CollectionClosureMediator<Cell> { cellBuilded in
                var mutableCell = cellBuilded
                builder(&mutableCell, item)
            }
        }
    }
}

@resultBuilder
public struct CollectionCellBuilder {
    public typealias Component = CollectionCellCompatible
    public typealias Result = [AnyCollectionCellMediator]
    
    public static func buildBlock(_ components: Component...) -> Result {
        components.reduce([], { cells, compatible in
            var mutableCells = cells
            mutableCells.append(contentsOf: compatible.generateCellMediators())
            return mutableCells
        })
    }
    
    public static func buildOptional(_ component: Component?) -> Component {
        guard let component = component else {
            return EmptyCollectionCellCompatible()
        }
        return component
    }
    
    public static func buildEither(first component: Component) -> Component {
        component
    }
    
    public static func buildArray(_ components: [Component]) -> Component {
        ListCollectionCellCompatible(compatibles: components)
    }
    
    public static func buildEither(second component: Component) -> Component {
        component
    }
}

@resultBuilder
public struct CollectionSectionBuilder {
    public typealias Component = CollectionSectionCompatible
    public typealias Result = [CollectionSection]
    
    public static func buildBlock(_ components: Component...) -> Result {
        var anonymousSectionCount: Int = 0
        var sections: Result = []
        var firstOrphanCell: Bool = true
        var lastSectionForOrphanCells = CollectionSection(identifier: anonymousSectionCount)
        for component in components {
            if let cell = component as? CollectionCellCompatible {
                if firstOrphanCell {
                    anonymousSectionCount += 1
                    lastSectionForOrphanCells = CollectionSection(identifier: anonymousSectionCount)
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
            return EmptyCollectionCellCompatible()
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
