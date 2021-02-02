//
//  Array+Extensions.swift
//  Artisan
//
//  Created by Nayanda Haberty (ID) on 24/08/20.
//

import Foundation
#if canImport(UIKit)
import UIKit

public class TableCellBuilder {
    var sections: [UITableView.Section]
    var lastSection: UITableView.Section {
        guard let last = sections.last else {
            let section: UITableView.Section = .init()
            sections.append(section)
            return section
        }
        return last
    }
    
    public init(sections: [UITableView.Section]) {
        self.sections = sections
    }
    
    public init(section: UITableView.Section = .init()) {
        self.sections = [section]
    }
    
    public init(sectionId: String) {
        self.sections = [.init(identifier: sectionId)]
    }
    
    @discardableResult
    public func next<Cell: AnyTableCellMediator, Item>(mediatorType: Cell.Type, fromItems items: [Item], _ builder: (inout Cell, Item) -> Void) -> TableCellBuilder {
        for item in items {
            var cell = Cell.init()
            builder(&cell, item)
            lastSection.add(cell: cell)
        }
        return self
    }
    
    @discardableResult
    public func next<Cell: AnyTableCellMediator, Item>(mediatorType: Cell.Type, fromItem item: Item, _ builder: (inout Cell, Item) -> Void) -> TableCellBuilder {
        return next(mediatorType: mediatorType, fromItems: [item], builder)
    }
    
    @discardableResult
    public func next<Cell: AnyTableCellMediator>(mediatorType: Cell.Type, count: Int, _ builder: (inout Cell, Int) -> Void) -> TableCellBuilder {
        for index in 0..<count {
            var cell = Cell.init()
            builder(&cell, index)
            lastSection.add(cell: cell)
        }
        return self
    }
    
    @discardableResult
    public func next<Cell: UITableViewCell, Item>(cellType: Cell.Type, fromItems items: [Item], _ builder: @escaping (Cell, Item) -> Void) -> TableCellBuilder {
        for item in items {
            lastSection.add(cell: TableCellApplicator<Cell> {
                builder($0, item)
            })
        }
        return self
    }
    
    @discardableResult
    public func next<Cell: UITableViewCell, Item>(cellType: Cell.Type, fromItem item: Item, _ builder: @escaping (Cell, Item) -> Void) -> TableCellBuilder {
        return next(cellType: cellType, fromItems: [item], builder)
    }
    
    @discardableResult
    public func next<Cell: UITableViewCell>(cellType: Cell.Type, count: Int, _ builder: @escaping (Cell, Int) -> Void) -> TableCellBuilder {
        for index in 0..<count {
            lastSection.add(cell: TableCellApplicator<Cell> {
                builder($0, index)
            })
        }
        return self
    }
    
    @discardableResult
    public func nextEmptyCell(with preferedHeight: CGFloat, _ builder: ((UITableViewCell) -> Void)?) -> TableCellBuilder {
        next(cellType: EmptyTableCell.self, count: 1) { cell, _ in
            cell.preferedHeight = preferedHeight
            builder?(cell)
        }
    }
    
    @discardableResult
    public func nextSection(_ section: UITableView.Section = .init()) -> TableCellBuilder {
        sections.append(section)
        return self
    }
    
    @discardableResult
    public func nextSection(_ sectionId: String) -> TableCellBuilder {
        sections.append(.init(identifier: sectionId))
        return self
    }
    
    public func build() -> [UITableView.Section] {
        return sections
    }
}

public class CollectionCellBuilder {
    var sections: [UICollectionView.Section]
    var lastSection: UICollectionView.Section {
        guard let last = sections.last else {
            let section: UICollectionView.Section = .init()
            sections.append(section)
            return section
        }
        return last
    }
    
    public init(sections: [UICollectionView.Section]) {
        self.sections = sections
    }
    
    public init(section: UICollectionView.Section = .init()) {
        self.sections = [section]
    }
    
    public init(sectionId: String = .randomString()) {
        self.sections = [.init(identifier: sectionId)]
    }
    
    @discardableResult
    public func next<Cell: AnyCollectionCellMediator, Item>(mediatorType: Cell.Type, fromItems items: [Item], _ builder: (inout Cell, Item) -> Void) -> CollectionCellBuilder {
        for item in items {
            var cell = Cell.init()
            builder(&cell, item)
            lastSection.add(cell: cell)
        }
        return self
    }
    
    @discardableResult
    public func next<Cell: AnyCollectionCellMediator, Item>(mediatorType: Cell.Type, fromItem item: Item, _ builder: (inout Cell, Item) -> Void) -> CollectionCellBuilder {
        return next(mediatorType: mediatorType, fromItems: [item], builder)
    }
    
    @discardableResult
    public func next<Cell: AnyCollectionCellMediator>(mediatorType: Cell.Type, count: Int, _ builder: (inout Cell, Int) -> Void) -> CollectionCellBuilder {
        for index in 0..<count {
            var cell = Cell.init()
            builder(&cell, index)
            lastSection.add(cell: cell)
        }
        return self
    }
    
    @discardableResult
    public func next<Cell: UICollectionViewCell, Item>(cellType: Cell.Type, fromItems items: [Item], _ builder: @escaping (Cell, Item) -> Void) -> CollectionCellBuilder {
        for item in items {
            lastSection.add(cell: CollectionCellApplicator<Cell> {
                builder($0, item)
            })
        }
        return self
    }
    
    @discardableResult
    public func next<Cell: UICollectionViewCell, Item>(cellType: Cell.Type, fromItem item: Item, _ builder: @escaping (Cell, Item) -> Void) -> CollectionCellBuilder {
        return next(cellType: cellType, fromItems: [item], builder)
    }
    
    @discardableResult
    public func next<Cell: UICollectionViewCell>(cellType: Cell.Type, count: Int, _ builder: @escaping (Cell, Int) -> Void) -> CollectionCellBuilder {
        for index in 0..<count {
            lastSection.add(cell: CollectionCellApplicator<Cell> {
                builder($0, index)
            })
        }
        return self
    }
    
    @discardableResult
    public func nextEmptyCell(with preferedSize: CGSize, _ builder: ((UICollectionViewCell) -> Void)?) -> CollectionCellBuilder {
        next(cellType: EmptyCollectionCell.self, count: 1) { cell, _ in
            cell.preferedSize = preferedSize
            builder?(cell)
        }
    }
    
    @discardableResult
    public func nextSection(_ section: UICollectionView.Section = .init()) -> CollectionCellBuilder {
        sections.append(section)
        return self
    }
    
    @discardableResult
    public func nextSection(_ sectionId: String) -> CollectionCellBuilder {
        sections.append(.init(identifier: sectionId))
        return self
    }
    
    public func build() -> [UICollectionView.Section] {
        return sections
    }
}

public extension Array where Element == UICollectionView.Section {
    static func create(section: UICollectionView.Section = .init()) -> CollectionCellBuilder {
        return .init(section: section)
    }
    
    static func create(sectionId: String = .randomString()) -> CollectionCellBuilder {
        return .init(sectionId: sectionId)
    }
    
    func append() -> CollectionCellBuilder {
        .init(sections: self)
    }
}

public extension Array where Element == UITableView.Section {
    static func create(section: UITableView.Section = .init()) -> TableCellBuilder {
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
