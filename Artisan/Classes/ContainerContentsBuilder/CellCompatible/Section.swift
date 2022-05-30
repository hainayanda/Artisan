//
//  ContentSection.swift
//  Artisan
//
//  Created by Nayanda Haberty on 28/05/22.
//

import Foundation
#if canImport(UIKit)
import UIKit

fileprivate let sectionDefaultNoIdentifier: AnyHashable = "artisan_no_identifier"

public class Section<CellType: ContentCellCompatible>: Hashable where CellType.Container: ContainerCellCompatible, CellType.Container.Cell == CellType {
    typealias CellItem = Cell<CellType>
    var identifier: AnyHashable
    var itemIndex: Int = 0
    var index: Int = 0
    let cellItems: [CellItem]
    
    public init<Item: Hashable>(
        items: [Item],
        @CellPlan<CellType> provider: @escaping CellProvider<Item, CellType>) {
        self.identifier = sectionDefaultNoIdentifier
        self.cellItems = items.toCellItems(using: provider)
    }
    
    public func hash(into hasher: inout Hasher) {
        // use position if section have no overridden identifier
        if identifier == sectionDefaultNoIdentifier {
            hasher.combine(index)
            hasher.combine(index)
        } else {
            identifier.hash(into: &hasher)
        }
    }
    
    public static func == (lhs: Section<CellType>, rhs: Section<CellType>) -> Bool {
        if lhs.identifier == sectionDefaultNoIdentifier && rhs.identifier == sectionDefaultNoIdentifier {
            return lhs.index == rhs.index && lhs.itemIndex == rhs.itemIndex
        } else {
            return lhs.identifier == rhs.identifier
        }
    }
    
    func addForHash(itemIndex: Int, index: Int) {
        self.index = index
        self.itemIndex = itemIndex
    }
}

public class TitledSection: Section<UITableViewCell> {
    let title: String?
    let footer: String?
    let indexed: Bool
    
    public init<Item: Hashable>(
        title: String,
        indexed: Bool = false,
        items: [Item],
        @TableCellPlan provider: @escaping CellProvider<Item, UITableViewCell>) {
            self.title = title
            self.footer = nil
            self.indexed = indexed
            super.init(items: items, provider: provider)
            self.identifier = "\(title)__\(indexed)"
    }
    
    public init<Item: Hashable>(
        footer: String,
        indexed: Bool = false,
        items: [Item],
        @TableCellPlan provider: @escaping CellProvider<Item, UITableViewCell>) {
            self.title = nil
            self.footer = footer
            self.indexed = indexed
            super.init(items: items, provider: provider)
            self.identifier = "_\(footer)_\(indexed)"
    }
    
    public init<Item: Hashable>(
        title: String,
        footer: String,
        indexed: Bool = false,
        items: [Item],
        @TableCellPlan provider: @escaping CellProvider<Item, UITableViewCell>) {
            self.title = title
            self.footer = footer
            self.indexed = indexed
            super.init(items: items, provider: provider)
            self.identifier = "\(title)_\(footer)_\(indexed)"
    }
}
#endif
