//
//  TableCellBuilder.swift
//  Artisan
//
//  Created by Nayanda Haberty on 16/04/21.
//

import Foundation
#if canImport(UIKit)
import UIKit

public class TableCellBuilder {
    var sections: [TableSection]
    var lastSection: TableSection {
        guard let last = sections.last else {
            let section: TableSection = .init()
            sections.append(section)
            return section
        }
        return last
    }
    
    public init(sections: [TableSection]) {
        self.sections = sections
    }
    
    public init(section: TableSection = .init()) {
        self.sections = [section]
    }
    
    public init(sectionId: AnyHashable = String.randomString()) {
        self.sections = [.init(distinctIdentifier: sectionId)]
    }
    
    @discardableResult
    public func next<Mediator: AnyTableCellMediator, Item>(
        mediator mediatorType: Mediator.Type,
        fromItems items: [Item],
        _ builder: (inout Mediator, Item) -> Void) -> TableCellBuilder {
        for item in items {
            var cell = Mediator.init()
            builder(&cell, item)
            lastSection.add(cell: cell)
        }
        return self
    }
    
    @discardableResult
    public func next<Mediator: AnyTableCellMediator, Item>(
        mediator mediatorType: Mediator.Type,
        fromItem item: Item,
        _ builder: (inout Mediator, Item) -> Void) -> TableCellBuilder {
        return next(mediator: mediatorType, fromItems: [item], builder)
    }
    
    @discardableResult
    public func next<Mediator: AnyTableCellMediator>(
        mediator mediatorType: Mediator.Type,
        _ builder: (inout Mediator) -> Void) -> TableCellBuilder {
        var cell = Mediator.init()
        builder(&cell)
        lastSection.add(cell: cell)
        return self
    }
    
    @discardableResult
    public func next<Mediator: AnyTableCellMediator>(
        mediator mediatorType: Mediator.Type,
        count: Int, _ builder: (inout Mediator, Int) -> Void) -> TableCellBuilder {
        for index in 0..<count {
            var cell = Mediator.init()
            builder(&cell, index)
            lastSection.add(cell: cell)
        }
        return self
    }
    
    @discardableResult
    public func next<Cell: UITableViewCell, Item>(
        cell cellType: Cell.Type,
        fromItems items: [Item],
        _ builder: @escaping (Cell, Item) -> Void) -> TableCellBuilder {
        for item in items {
            lastSection.add(cell: TableClosureMediator<Cell> {
                builder($0, item)
            })
        }
        return self
    }
    
    @discardableResult
    public func next<Cell: UITableViewCell, Item>(
        cell cellType: Cell.Type,
        fromItem item: Item,
        _ builder: @escaping (Cell, Item) -> Void) -> TableCellBuilder {
        return next(cell: cellType, fromItems: [item], builder)
    }
    
    @discardableResult
    public func next<Cell: UITableViewCell>(
        cell cellType: Cell.Type,
        _ builder: @escaping (Cell) -> Void) -> TableCellBuilder {
        lastSection.add(cell: TableClosureMediator<Cell> {
            builder($0)
        })
        return self
    }
    
    @discardableResult
    public func next<Cell: UITableViewCell>(
        cell cellType: Cell.Type,
        count: Int,
        _ builder: @escaping (Cell, Int) -> Void) -> TableCellBuilder {
        for index in 0..<count {
            lastSection.add(cell: TableClosureMediator<Cell> {
                builder($0, index)
            })
        }
        return self
    }
    
    @discardableResult
    public func nextEmptyCell(
        with preferedHeight: CGFloat,
        _ builder: ((UITableViewCell) -> Void)?) -> TableCellBuilder {
        next(cell: EmptyTableCell.self, count: 1) { cell, _ in
            cell.preferedHeight = preferedHeight
            builder?(cell)
        }
    }
    
    @discardableResult
    public func nextSection(_ section: TableSection = .init()) -> TableCellBuilder {
        sections.append(section)
        return self
    }
    
    @discardableResult
    public func nextSection(_ sectionId: String) -> TableCellBuilder {
        sections.append(.init(distinctIdentifier: sectionId))
        return self
    }
    
    public func build() -> [TableSection] {
        return sections
    }
}

public extension Array where Element == TableSection {
    static func create(section: TableSection = .init()) -> TableCellBuilder {
        return .init(section: section)
    }
    
    static func create(sectionId: String = .randomString()) -> TableCellBuilder {
        return .init(sectionId: sectionId)
    }
    
    func append() -> TableCellBuilder {
        .init(sections: self)
    }
}
#endif
