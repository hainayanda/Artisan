//
//  Array+Extensions.swift
//  Artisan
//
//  Created by Nayanda Haberty (ID) on 24/08/20.
//

import Foundation

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
    public func next<Cell: TableCellMediator, Item>(type: Cell.Type, from items: [Item], _ builder: (inout Cell, Item) -> Void) -> TableCellBuilder {
        for item in items {
            var cell = Cell.init()
            builder(&cell, item)
            lastSection.add(cell: cell)
        }
        return self
    }
    
    @discardableResult
    public func next<Cell: TableCellMediator, Item>(type: Cell.Type, from item: Item, _ builder: (inout Cell, Item) -> Void) -> TableCellBuilder {
        return next(type: type, from: [item], builder)
    }
    
    @discardableResult
    public func next<Cell: TableCellMediator>(type: Cell.Type, count: Int, _ builder: (inout Cell, Int) -> Void) -> TableCellBuilder {
        for index in 0..<count {
            var cell = Cell.init()
            builder(&cell, index)
            lastSection.add(cell: cell)
        }
        return self
    }
    
    @discardableResult
    public func next<Cell: UITableViewCell, Item>(type: Cell.Type, from items: [Item], _ builder: @escaping (Cell, Item) -> Void) -> TableCellBuilder {
        for item in items {
            lastSection.add(cell: GenericTableCellMediator<Cell> {
                builder($0, item)
            })
        }
        return self
    }
    
    @discardableResult
    public func next<Cell: UITableViewCell, Item>(type: Cell.Type, from item: Item, _ builder: @escaping (Cell, Item) -> Void) -> TableCellBuilder {
        return next(type: type, from: [item], builder)
    }
    
    @discardableResult
    public func next<Cell: UITableViewCell>(type: Cell.Type, count: Int, _ builder: @escaping (Cell, Int) -> Void) -> TableCellBuilder {
        for index in 0..<count {
            lastSection.add(cell: GenericTableCellMediator<Cell> {
                builder($0, index)
            })
        }
        return self
    }
    
    public func nextEmptyCell(with preferedHeight: CGFloat, _ builder: ((UITableViewCell) -> Void)?) {
        next(type: EmptyTableCell.self, count: 1) { cell, _ in
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
    public func next<Cell: CollectionCellMediator, Item>(type: Cell.Type, from items: [Item], _ builder: (inout Cell, Item) -> Void) -> CollectionCellBuilder {
        for item in items {
            var cell = Cell.init()
            builder(&cell, item)
            lastSection.add(cell: cell)
        }
        return self
    }
    
    @discardableResult
    public func next<Cell: CollectionCellMediator, Item>(type: Cell.Type, from item: Item, _ builder: (inout Cell, Item) -> Void) -> CollectionCellBuilder {
        return next(type: type, from: [item], builder)
    }
    
    @discardableResult
    public func next<Cell: CollectionCellMediator>(type: Cell.Type, count: Int, _ builder: (inout Cell, Int) -> Void) -> CollectionCellBuilder {
        for index in 0..<count {
            var cell = Cell.init()
            builder(&cell, index)
            lastSection.add(cell: cell)
        }
        return self
    }
    
    @discardableResult
    public func next<Cell: UICollectionViewCell, Item>(type: Cell.Type, from items: [Item], _ builder: @escaping (Cell, Item) -> Void) -> CollectionCellBuilder {
        for item in items {
            lastSection.add(cell: GenericCollectionCellMediator<Cell> {
                builder($0, item)
            })
        }
        return self
    }
    
    @discardableResult
    public func next<Cell: UICollectionViewCell, Item>(type: Cell.Type, from item: Item, _ builder: @escaping (Cell, Item) -> Void) -> CollectionCellBuilder {
        return next(type: type, from: [item], builder)
    }
    
    @discardableResult
    public func next<Cell: UICollectionViewCell>(type: Cell.Type, count: Int, _ builder: @escaping (Cell, Int) -> Void) -> CollectionCellBuilder {
        for index in 0..<count {
            lastSection.add(cell: GenericCollectionCellMediator<Cell> {
                builder($0, index)
            })
        }
        return self
    }
    
    public func nextEmptyCell(with preferedSize: CGSize, _ builder: ((UICollectionViewCell) -> Void)?) {
        next(type: EmptyCollectionCell.self, count: 1) { cell, _ in
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
