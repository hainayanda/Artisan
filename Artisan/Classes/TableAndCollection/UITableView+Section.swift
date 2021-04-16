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
    
    open class Section: Distinctable, Equatable {
        public var index: String?
        public var cells: [AnyTableCellMediator]
        public var cellCount: Int { cells.count }
        public var distinctIdentifier: AnyHashable
        
        public init(distinctIdentifier: AnyHashable = String.randomString(), index: String? = nil, cells: [AnyTableCellMediator] = []) {
            self.distinctIdentifier = distinctIdentifier
            self.cells = cells
            self.index = index
        }
        
        public func add(cell: AnyTableCellMediator) {
            cells.append(cell)
        }
        
        public func add(cells: [AnyTableCellMediator]) {
            self.cells.append(contentsOf: cells)
        }
        
        func isSameSection(with other: Section) -> Bool {
            if other === self { return true }
            return other.distinctIdentifier == distinctIdentifier
        }
        
        public func clear() {
            cells.removeAll()
        }
        
        public func copy() -> Section {
            return Section(distinctIdentifier: distinctIdentifier, cells: cells)
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
    
    public class TitledSection: Section {
        
        public var title: String
        
        public init(title: String, distinctIdentifier: AnyHashable = String.randomString(), index: String? = nil, cells: [AnyTableCellMediator] = []) {
            self.title = title
            super.init(distinctIdentifier: distinctIdentifier, index: index, cells: cells)
        }
        
        public override func copy() -> Section {
            return TitledSection(title: title, distinctIdentifier: distinctIdentifier, cells: cells)
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
