//
//  CollectionCellBuilder.swift
//  Artisan
//
//  Created by Nayanda Haberty on 16/04/21.
//

import Foundation
#if canImport(UIKit)
import UIKit

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
    
    public init(sectionId: AnyHashable = String.randomString()) {
        self.sections = [.init(distinctIdentifier: sectionId)]
    }
    
    @discardableResult
    public func next<Mediator: AnyCollectionCellMediator, Item>(
        mediator mediatorType: Mediator.Type,
        fromItems items: [Item],
        _ builder: (inout Mediator, Item) -> Void) -> CollectionCellBuilder {
        for item in items {
            var cell = Mediator.init()
            builder(&cell, item)
            lastSection.add(cell: cell)
        }
        return self
    }
    
    @discardableResult
    public func next<Mediator: AnyCollectionCellMediator, Item>(
        mediator mediatorType: Mediator.Type,
        fromItem item: Item,
        _ builder: (inout Mediator, Item) -> Void) -> CollectionCellBuilder {
        return next(mediator: mediatorType, fromItems: [item], builder)
    }
    
    @discardableResult
    public func next<Mediator: AnyCollectionCellMediator>(
        mediator mediatorType: Mediator.Type,
        _ builder: (inout Mediator) -> Void) -> CollectionCellBuilder {
        var cell = Mediator.init()
        builder(&cell)
        lastSection.add(cell: cell)
        return self
    }
    
    @discardableResult
    public func next<Mediator: AnyCollectionCellMediator>(
        mediator mediatorType: Mediator.Type,
        count: Int,
        _ builder: (inout Mediator, Int) -> Void) -> CollectionCellBuilder {
        for index in 0..<count {
            var cell = Mediator.init()
            builder(&cell, index)
            lastSection.add(cell: cell)
        }
        return self
    }
    
    @discardableResult
    public func next<Cell: UICollectionViewCell, Item>(
        cell cellType: Cell.Type,
        fromItems items: [Item],
        _ builder: @escaping (Cell, Item) -> Void) -> CollectionCellBuilder {
        for item in items {
            lastSection.add(cell: CollectionClosureMediator<Cell> {
                builder($0, item)
            })
        }
        return self
    }
    
    @discardableResult
    public func next<Cell: UICollectionViewCell, Item>(
        cell cellType: Cell.Type,
        fromItem item: Item,
        _ builder: @escaping (Cell, Item) -> Void) -> CollectionCellBuilder {
        return next(cell: cellType, fromItems: [item], builder)
    }
    
    @discardableResult
    public func next<Cell: UICollectionViewCell>(
        cell cellType: Cell.Type,
        _ builder: @escaping (Cell) -> Void) -> CollectionCellBuilder {
        lastSection.add(cell: CollectionClosureMediator<Cell> {
            builder($0)
        })
        return self
    }
    
    @discardableResult
    public func next<Cell: UICollectionViewCell>(
        cell cellType: Cell.Type,
        count: Int,
        _ builder: @escaping (Cell, Int) -> Void) -> CollectionCellBuilder {
        for index in 0..<count {
            lastSection.add(cell: CollectionClosureMediator<Cell> {
                builder($0, index)
            })
        }
        return self
    }
    
    @discardableResult
    public func nextEmptyCell(
        with preferedSize: CGSize,
        _ builder: ((UICollectionViewCell) -> Void)?) -> CollectionCellBuilder {
        next(cell: EmptyCollectionCell.self, count: 1) { cell, _ in
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
        sections.append(.init(distinctIdentifier: sectionId))
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
#endif
