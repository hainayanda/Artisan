//
//  UICollectionView+Section.swift
//  Artisan
//
//  Created by Nayanda Haberty on 16/04/21.
//

import Foundation
#if canImport(UIKit)
import UIKit

public typealias CollectionSection = UICollectionView.Section
public typealias SupplementedCollectionSection = UICollectionView.SupplementedSection

extension UICollectionView {
    
    open class Section: CollectionSectionCompatible, Distinctable, Equatable {
        public var index: String?
        public var cells: [AnyCollectionCellMediator]
        public var cellCount: Int { cells.count }
        public var distinctIdentifier: AnyHashable
        
        public init(
            identifier: AnyHashable = String.randomString(),
            index: String? = nil,
            cells: [AnyCollectionCellMediator] = []) {
            self.distinctIdentifier = identifier
            self.cells = cells
            self.index = index
        }
        
        public init(
            identifier: AnyHashable = String.randomString(),
            index: String? = nil,
            @CollectionCellBuilder builder: () -> [AnyCollectionCellMediator]) {
            self.distinctIdentifier = identifier
            self.cells = builder()
            self.index = index
        }
        
        open func add(cell: AnyCollectionCellMediator) {
            cells.append(cell)
        }
        
        open func add(cells: [AnyCollectionCellMediator]) {
            self.cells.append(contentsOf: cells)
        }
        
        open func add(@CollectionCellBuilder _ builder: () -> [AnyCollectionCellMediator]) {
            self.cells.append(contentsOf: builder())
        }
        
        open func clear() {
            cells.removeAll()
        }
        
        open func copy() -> Section {
            return Section(identifier: distinctIdentifier, cells: cells)
        }
        
        public func getSection() -> CollectionSection? {
            self
        }
        
        func isSameSection(with other: Section) -> Bool {
            if other === self { return true }
            return other.distinctIdentifier == distinctIdentifier
        }
        
        public static func == (lhs: UICollectionView.Section, rhs: UICollectionView.Section) -> Bool {
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
    
    open class SupplementedSection: Section {
        
        public var header: AnyCollectionCellMediator?
        public var footer: AnyCollectionCellMediator?
        
        public init(
            header: AnyCollectionCellMediator? = nil,
            footer: AnyCollectionCellMediator? = nil,
            identifier: AnyHashable = String.randomString(),
            index: String? = nil,
            cells: [AnyCollectionCellMediator] = []) {
            self.header = header
            self.footer = footer
            super.init(identifier: identifier, index: index, cells: cells)
        }
        
        public init(
            header: AnyCollectionCellMediator? = nil,
            footer: AnyCollectionCellMediator? = nil,
            identifier: AnyHashable = String.randomString(),
            index: String? = nil,
            @CollectionCellBuilder builder: () -> [AnyCollectionCellMediator]) {
            self.header = header
            self.footer = footer
            super.init(identifier: identifier, index: index, builder: builder)
        }
        
        open override func add(cell: AnyCollectionCellMediator) {
            super.add(cell: cell)
        }
        
        open override func add(cells: [AnyCollectionCellMediator]) {
            super.add(cells: cells)
        }
        
        open override func add(@CollectionCellBuilder _ builder: () -> [AnyCollectionCellMediator]) {
            super.add(builder)
        }
        
        open override func clear() {
            super.clear()
        }
        
        open override func copy() -> Section {
            return SupplementedSection(header: header, footer: footer, identifier: distinctIdentifier, cells: cells)
        }
        
        public static func == (lhs: UICollectionView.SupplementedSection, rhs: UICollectionView.SupplementedSection) -> Bool {
            guard let left = lhs.copy() as? UICollectionView.SupplementedSection,
                  let right = rhs.copy() as? UICollectionView.SupplementedSection else {
                return false
            }
            guard left.distinctIdentifier == right.distinctIdentifier,
                  left.cells.count == right.cells.count else { return false }
            for (index, cell) in left.cells.enumerated() where !right.cells[index].isSame(with: cell) {
                return false
            }
            if let leftHeader = left.header, let rightHeader = right.header,
               leftHeader.isNotSame(with: rightHeader) {
                return false
            } else if (left.header == nil && right.header != nil) || (left.header != nil && right.header != nil) {
                return false
            }
            if let leftFooter = left.footer, let rightFooter = right.footer,
               leftFooter.isNotSame(with: rightFooter) {
                return false
            } else if (left.footer == nil && right.footer != nil) || (left.footer != nil && right.footer != nil) {
                return false
            }
            return true
        }
    }
}
#endif
