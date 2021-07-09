//
//  UITableView+Section.swift
//  Artisan
//
//  Created by Nayanda Haberty on 16/04/21.
//

import Foundation
#if canImport(UIKit)
import UIKit

extension UITableView {
    
    open class Section: TableSectionCompatible, Distinctable, Equatable {
        public var index: String?
        public var cells: [AnyTableCellMediator]
        public var cellCount: Int { cells.count }
        public var distinctIdentifier: AnyHashable
        
        public init(
            identifier: AnyHashable = String.randomString(),
            index: String? = nil,
            cells: [AnyTableCellMediator] = []) {
            self.distinctIdentifier = identifier
            self.cells = cells
            self.index = index
        }
        
        public init(
            identifier: AnyHashable = String.randomString(),
            index: String? = nil,
            @TableCellBuilder builder: () -> [AnyTableCellMediator]) {
            self.distinctIdentifier = identifier
            self.cells = builder()
            self.index = index
        }
        
        open func add(cell: AnyTableCellMediator) {
            cells.append(cell)
        }
        
        open func add(cells: [AnyTableCellMediator]) {
            self.cells.append(contentsOf: cells)
        }
        
        open func add(@TableCellBuilder _ builder: () -> [AnyTableCellMediator]) {
            self.cells.append(contentsOf: builder())
        }
        
        open func clear() {
            cells.removeAll()
        }
        
        open func copy() -> Section {
            return Section(identifier: distinctIdentifier, cells: cells)
        }
        
        public func getSection() -> TableSection? {
            self
        }
        
        func isSameSection(with other: Section) -> Bool {
            if other === self { return true }
            return other.distinctIdentifier == distinctIdentifier
        }
        
        public static func == (lhs: UITableView.Section, rhs: UITableView.Section) -> Bool {
            let left = lhs.copy()
            let right = rhs.copy()
            guard left.distinctIdentifier == right.distinctIdentifier,
                  left.cells.count == right.cells.count else { return false }
            for (index, cell) in left.cells.enumerated() where !right.cells[index].isSame(with: cell) {
                return false
            }
            return true
        }
    }
    
    open class TitledSection: Section {
        
        public var title: String
        
        public init(
            title: String,
            identifier: AnyHashable = String.randomString(),
            index: String? = nil,
            cells: [AnyTableCellMediator] = []) {
            self.title = title
            super.init(identifier: identifier, index: index, cells: cells)
        }
        
        public init(
            title: String,
            identifier: AnyHashable = String.randomString(),
            index: String? = nil,
            @TableCellBuilder builder: () -> [AnyTableCellMediator]) {
            self.title = title
            super.init(identifier: identifier, index: index, builder: builder)
        }
        
        open override func add(cell: AnyTableCellMediator) {
            super.add(cell: cell)
        }
        
        open override func add(cells: [AnyTableCellMediator]) {
            super.add(cells: cells)
        }
        
        open override func add(@TableCellBuilder _ builder: () -> [AnyTableCellMediator]) {
            super.add(builder)
        }
        
        open override func clear() {
            super.clear()
        }
        
        open override func copy() -> Section {
            return TitledSection(title: title, identifier: distinctIdentifier, cells: cells)
        }
        
        public static func == (lhs: UITableView.TitledSection, rhs: UITableView.TitledSection) -> Bool {
            guard let left = lhs.copy() as? UITableView.TitledSection,
                  let right = rhs.copy() as? UITableView.TitledSection else {
                return false
            }
            guard left.distinctIdentifier == right.distinctIdentifier,
                  left.title == right.title,
                  left.cells.count == right.cells.count else { return false }
            for (index, cell) in left.cells.enumerated() where !right.cells[index].isSame(with: cell) {
                return false
            }
            return true
        }
    }
}
#endif
