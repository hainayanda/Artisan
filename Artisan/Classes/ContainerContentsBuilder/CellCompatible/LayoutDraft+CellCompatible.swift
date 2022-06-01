//
//  LayoutAnchor+Extensions.swift
//  Artisan
//
//  Created by Nayanda Haberty on 28/05/22.
//

import Foundation
#if canImport(UIKit)
import UIKit
import Draftsman
import Pharos

// MARK: Table

fileprivate var tableBuilderAssociatedKey: String = "tableBuilderAssociatedKey"

public protocol TableDraft: ViewDraft {
    func cells<Item: Hashable>(from observableItems: Observable<[Item]>, @TableCellPlan _ provider: @escaping TableCellProvider<Item>) -> Self
    func cells<Item: Hashable>(from items: [Item], @TableCellPlan _ provider: @escaping TableCellProvider<Item>) -> Self
    func sections<Item: Hashable>(from observableSection: Observable<[Item]>, @TableSectionPlan _ provider: @escaping TableSectionProvider<Item>) -> Self
    func sections<Item: Hashable>(from sections: [Item], @TableSectionPlan _ provider: @escaping TableSectionProvider<Item>) -> Self
    func sectioned<Item: Hashable>(using observableSection: Observable<Item>, @TableSectionPlan _ provider: @escaping TableSingleSectionProvider<Item>) -> Self
    func sectioned<Item: Hashable>(using section: Item, @TableSectionPlan _ provider: @escaping TableSingleSectionProvider<Item>) -> Self
    
}

extension LayoutDraft: TableDraft where View: UITableView {

    public func cells<Item: Hashable>(from observableItems: Observable<[Item]>, @TableCellPlan _ provider: @escaping TableCellProvider<Item>) -> Self {
        let tableView = layoutExtractable
        let tableBuilder = TableCellBuilder(for: tableView, observableItems: observableItems, cellProvider: provider)
        objc_setAssociatedObject(tableView, &tableBuilderAssociatedKey, tableBuilder, .OBJC_ASSOCIATION_RETAIN)
        return self
    }

    public func cells<Item: Hashable>(from items: [Item], @TableCellPlan _ provider: @escaping TableCellProvider<Item>) -> Self {
        let tableView = layoutExtractable
        let tableBuilder = TableCellBuilder(for: tableView, items: items, cellProvider: provider)
        objc_setAssociatedObject(tableView, &tableBuilderAssociatedKey, tableBuilder, .OBJC_ASSOCIATION_RETAIN)
        return self
    }

    public func sections<Item: Hashable>(from observableSections: Observable<[Item]>, @TableSectionPlan _ provider: @escaping TableSectionProvider<Item>) -> Self {
        let tableView = layoutExtractable
        let tableBuilder = TableCellBuilder(for: tableView, observableSectionItems: observableSections, sectionProvider: provider)
        objc_setAssociatedObject(tableView, &tableBuilderAssociatedKey, tableBuilder, .OBJC_ASSOCIATION_RETAIN)
        return self
    }

    public func sections<Item: Hashable>(from sections: [Item], @TableSectionPlan _ provider: @escaping TableSectionProvider<Item>) -> Self {
        let tableView = layoutExtractable
        let tableBuilder = TableCellBuilder(for: tableView, sectionItems: sections, sectionProvider: provider)
        objc_setAssociatedObject(tableView, &tableBuilderAssociatedKey, tableBuilder, .OBJC_ASSOCIATION_RETAIN)
        return self
    }
    
    public func sectioned<Item: Hashable>(using observableSection: Observable<Item>, @TableSectionPlan _ provider: @escaping TableSingleSectionProvider<Item>) -> Self {
        let tableView = layoutExtractable
        let tableBuilder = TableCellBuilder(for: tableView, observableSectionItem: observableSection, sectionProvider: provider)
        objc_setAssociatedObject(tableView, &tableBuilderAssociatedKey, tableBuilder, .OBJC_ASSOCIATION_RETAIN)
        return self
    }

    public func sectioned<Item: Hashable>(using section: Item, @TableSectionPlan _ provider: @escaping TableSingleSectionProvider<Item>) -> Self {
        let tableView = layoutExtractable
        let tableBuilder = TableCellBuilder(for: tableView, sectionItem: section, sectionProvider: provider)
        objc_setAssociatedObject(tableView, &tableBuilderAssociatedKey, tableBuilder, .OBJC_ASSOCIATION_RETAIN)
        return self
    }
}

extension ConstraintBuilderRootRecoverable where Root: TableDraft {
    
    public func cells<Item: Hashable>(from observableItems: Observable<[Item]>, @TableCellPlan _ provider: @escaping TableCellProvider<Item>) -> Root {
        backToRoot {
            $0.cells(from: observableItems, provider)
        }
    }

    public func cells<Item: Hashable>(from items: [Item], @TableCellPlan _ provider: @escaping TableCellProvider<Item>) -> Root {
        backToRoot {
            $0.cells(from: items, provider)
        }
    }

    public func sections<Item: Hashable>(from observableSections: Observable<[Item]>, @TableSectionPlan _ provider: @escaping TableSectionProvider<Item>) -> Root {
        backToRoot {
            $0.sections(from: observableSections, provider)
        }
    }

    public func sections<Item: Hashable>(from sections: [Item], @TableSectionPlan _ provider: @escaping TableSectionProvider<Item>) -> Root {
        backToRoot {
            $0.sections(from: sections, provider)
        }
    }
    
    public func sectioned<Item: Hashable>(using observableSection: Observable<Item>, @TableSectionPlan _ provider: @escaping TableSingleSectionProvider<Item>) -> Root {
        backToRoot {
            $0.sectioned(using: observableSection, provider)
        }
    }

    public func sectioned<Item: Hashable>(using section: Item, @TableSectionPlan _ provider: @escaping TableSingleSectionProvider<Item>) -> Root {
        backToRoot {
            $0.sectioned(using: section, provider)
        }
    }
}

// MARK: Collection

fileprivate var collectionBuilderAssociatedKey: String = "collectionBuilderAssociatedKey"

public protocol CollectionDraft: ViewDraft {
    func cells<Item: Hashable>(from observableItems: Observable<[Item]>, @CollectionCellPlan _ provider: @escaping CollectionCellProvider<Item>) -> Self
    func cells<Item: Hashable>(from items: [Item], @CollectionCellPlan _ provider: @escaping CollectionCellProvider<Item>) -> Self
    func sections<Item: Hashable>(from observableSection: Observable<[Item]>, @CollectionSectionPlan _ provider: @escaping CollectionSectionProvider<Item>) -> Self
    func sections<Item: Hashable>(from sections: [Item], @CollectionSectionPlan _ provider: @escaping CollectionSectionProvider<Item>) -> Self
    func sectioned<Item: Hashable>(using observableSection: Observable<Item>, @CollectionSectionPlan _ provider: @escaping SingleCollectionSectionProvider<Item>) -> Self
    func sectioned<Item: Hashable>(using section: Item, @CollectionSectionPlan _ provider: @escaping SingleCollectionSectionProvider<Item>) -> Self
}

extension LayoutDraft: CollectionDraft where View: UICollectionView {

    public func cells<Item: Hashable>(from observableItems: Observable<[Item]>, @CollectionCellPlan _ provider: @escaping CollectionCellProvider<Item>) -> Self {
        let collectionView = layoutExtractable
        let collectionBuilder = CollectionCellBuilder(for: collectionView, observableItems: observableItems, cellProvider: provider)
        objc_setAssociatedObject(collectionView, &collectionBuilderAssociatedKey, collectionBuilder, .OBJC_ASSOCIATION_RETAIN)
        return self
    }

    public func cells<Item: Hashable>(from items: [Item], @CollectionCellPlan _ provider: @escaping CollectionCellProvider<Item>) -> Self {
        let collectionView = layoutExtractable
        let collectionBuilder = CollectionCellBuilder(for: collectionView, items: items, cellProvider: provider)
        objc_setAssociatedObject(collectionView, &collectionBuilderAssociatedKey, collectionBuilder, .OBJC_ASSOCIATION_RETAIN)
        return self
    }

    public func sections<Item: Hashable>(from observableSections: Observable<[Item]>, @CollectionSectionPlan _ provider: @escaping CollectionSectionProvider<Item>) -> Self {
        let collectionView = layoutExtractable
        let collectionBuilder = CollectionCellBuilder(for: collectionView, observableSectionItems: observableSections, sectionProvider: provider)
        objc_setAssociatedObject(collectionView, &collectionBuilderAssociatedKey, collectionBuilder, .OBJC_ASSOCIATION_RETAIN)
        return self
    }

    public func sections<Item: Hashable>(from sections: [Item], @CollectionSectionPlan _ provider: @escaping CollectionSectionProvider<Item>) -> Self {
        let collectionView = layoutExtractable
        let collectionBuilder = CollectionCellBuilder(for: collectionView, sectionItems: sections, sectionProvider: provider)
        objc_setAssociatedObject(collectionView, &collectionBuilderAssociatedKey, collectionBuilder, .OBJC_ASSOCIATION_RETAIN)
        return self
    }
    
    public func sectioned<Item: Hashable>(using observableSection: Observable<Item>, @CollectionSectionPlan _ provider: @escaping SingleCollectionSectionProvider<Item>) -> Self {
        let collectionView = layoutExtractable
        let collectionBuilder = CollectionCellBuilder(for: collectionView, observableSectionItem: observableSection, sectionProvider: provider)
        objc_setAssociatedObject(collectionView, &collectionBuilderAssociatedKey, collectionBuilder, .OBJC_ASSOCIATION_RETAIN)
        return self
    }

    public func sectioned<Item: Hashable>(using section: Item, @CollectionSectionPlan _ provider: @escaping SingleCollectionSectionProvider<Item>) -> Self {
        let collectionView = layoutExtractable
        let collectionBuilder = CollectionCellBuilder(for: collectionView, sectionItem: section, sectionProvider: provider)
        objc_setAssociatedObject(collectionView, &collectionBuilderAssociatedKey, collectionBuilder, .OBJC_ASSOCIATION_RETAIN)
        return self
    }
}

extension ConstraintBuilderRootRecoverable where Root: CollectionDraft {
    
    public func cells<Item: Hashable>(from observableItems: Observable<[Item]>, @CollectionCellPlan _ provider: @escaping CollectionCellProvider<Item>) -> Root {
        backToRoot {
            $0.cells(from: observableItems, provider)
        }
    }

    public func cells<Item: Hashable>(from items: [Item], @CollectionCellPlan _ provider: @escaping CollectionCellProvider<Item>) -> Root {
        backToRoot {
            $0.cells(from: items, provider)
        }
    }
    
    public func sections<Item: Hashable>(from observableSections: Observable<[Item]>, @CollectionSectionPlan _ provider: @escaping CollectionSectionProvider<Item>) -> Root {
        backToRoot {
            $0.sections(from: observableSections, provider)
        }
    }

    public func sections<Item: Hashable>(from sections: [Item], @CollectionSectionPlan _ provider: @escaping CollectionSectionProvider<Item>) -> Root {
        backToRoot {
            $0.sections(from: sections, provider)
        }
    }
    
    public func sectioned<Item: Hashable>(using observableSection: Observable<Item>, @CollectionSectionPlan _ provider: @escaping SingleCollectionSectionProvider<Item>) -> Root {
        backToRoot {
            $0.sectioned(using: observableSection, provider)
        }
    }

    public func sectioned<Item: Hashable>(using section: Item, @CollectionSectionPlan _ provider: @escaping SingleCollectionSectionProvider<Item>) -> Root {
        backToRoot {
            $0.sectioned(using: section, provider)
        }
    }
}
#endif
