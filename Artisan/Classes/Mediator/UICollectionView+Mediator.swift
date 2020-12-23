//
//  UICollectionView+Mediator.swift
//  Artisan
//
//  Created by Nayanda Haberty (ID) on 12/08/20.
//

import Foundation
import UIKit

extension UICollectionView {
    
    public var mediator: UICollectionView.Mediator {
        if let mediator = getMediator() as? UICollectionView.Mediator {
            return mediator
        }
        let mediator = Mediator()
        mediator.apply(to: self)
        return mediator
    }
    
    public var sections: [Section] {
        get {
            mediator.sections
        }
        set {
            mediator.sections = newValue
        }
    }
    
    public var cells: [CollectionCellMediator] {
        get {
            mediator.sections.first?.cells ?? []
        }
        set {
            let section = Section(identifier: "single_section", cells: newValue)
            mediator.sections = [section]
        }
    }
    
    public class Mediator: ViewMediator<UICollectionView> {
        var applicableSections: [Section] = []
        @ObservableState public var sections: [Section] = []
        public var reloadStrategy: CellReloadStrategy = .reloadArrangementDifference
        private var didReloadAction: ((Bool) -> Void)?
        
        public override func bonding(with view: UICollectionView) {
            super.bonding(with: view)
            $sections.observe(observer: self).didSet { mediator, changes  in
                guard let collection = mediator.view else { return }
                let newSection = changes.new
                collection.registerNewCell(from: newSection)
                let oldSection = mediator.applicableSections
                mediator.applicableSections = newSection
                mediator.reload(collection, with: newSection, oldSections: oldSection, completion: mediator.didReloadAction)
            }
        }
        
        public func didReloadCells(then: ((Bool) -> Void)?) {
            didReloadAction = then
        }
        
        public override func didApplying(_ view: UICollectionView) {
            view.dataSource = self
        }
    }
    
    open class Section: Equatable {
        
        public var cells: [CollectionCellMediator]
        public var cellCount: Int { cells.count }
        public var sectionIdentifier: AnyHashable
        
        public init(identifier: AnyHashable = String.randomString(), cells: [CollectionCellMediator] = []) {
            self.sectionIdentifier = identifier
            self.cells = cells
        }
        
        public func add(cell: CollectionCellMediator) {
            cells.append(cell)
        }
        
        public func add(cells: [CollectionCellMediator]) {
            self.cells.append(contentsOf: cells)
        }
        
        func isSameSection(with other: Section) -> Bool {
            if other === self { return true }
            return other.sectionIdentifier == sectionIdentifier
        }
        
        public func clear() {
            cells.removeAll()
        }
        
        public func copy() -> Section {
            return Section(identifier: sectionIdentifier, cells: cells)
        }
        
        public static func == (lhs: UICollectionView.Section, rhs: UICollectionView.Section) -> Bool {
            let left = lhs.copy()
            let right = rhs.copy()
            guard left.sectionIdentifier == right.sectionIdentifier,
                  left.cells.count == right.cells.count else { return false }
            for (index, cell) in left.cells.enumerated() where !right.cells[index].isSameMediator(with: cell) {
                return false
            }
            return true
        }
    }
    
    public class IndexedSection: Section {
        
        public var indexTitle: String
        
        public init(indexTitle: String, identifier: AnyHashable = String.randomString(), cells: [CollectionCellMediator] = []) {
            self.indexTitle = indexTitle
            super.init(identifier: identifier, cells: cells)
        }
        
        public override func copy() -> Section {
            return IndexedSection(indexTitle: indexTitle, identifier: sectionIdentifier, cells: cells)
        }
        
        public static func == (lhs: UICollectionView.IndexedSection, rhs: UICollectionView.IndexedSection) -> Bool {
            guard let left = lhs.copy() as? UICollectionView.IndexedSection,
                  let right = rhs.copy() as? UICollectionView.IndexedSection else {
                return false
            }
            guard left.sectionIdentifier == right.sectionIdentifier,
                  left.indexTitle == right.indexTitle,
                  left.cells.count == right.cells.count else { return false }
            for (index, cell) in left.cells.enumerated() where !right.cells[index].isSameMediator(with: cell) {
                return false
            }
            return true
        }
    }
    
    public class SupplementedSection: Section {
        
        public var header: CollectionCellMediator?
        public var footer: CollectionCellMediator?
        
        public init(header: CollectionCellMediator? = nil, footer: CollectionCellMediator? = nil, identifier: AnyHashable = String.randomString(), cells: [CollectionCellMediator] = []) {
            self.header = header
            self.footer = footer
            super.init(identifier: identifier, cells: cells)
        }
        
        public override func copy() -> Section {
            return SupplementedSection(header: header, footer: footer, identifier: sectionIdentifier, cells: cells)
        }
        
        public static func == (lhs: UICollectionView.SupplementedSection, rhs: UICollectionView.SupplementedSection) -> Bool {
            guard let left = lhs.copy() as? UICollectionView.SupplementedSection,
                  let right = rhs.copy() as? UICollectionView.SupplementedSection else {
                return false
            }
            guard left.sectionIdentifier == right.sectionIdentifier,
                  left.cells.count == right.cells.count else { return false }
            for (index, cell) in left.cells.enumerated() where !right.cells[index].isSameMediator(with: cell) {
                return false
            }
            if let leftHeader = left.header, let rightHeader = right.header,
               leftHeader.isNotSameMediator(with: rightHeader) {
                return false
            } else if (left.header == nil && right.header != nil) || (left.header != nil && right.header != nil) {
                return false
            }
            if let leftFooter = left.footer, let rightFooter = right.footer,
               leftFooter.isNotSameMediator(with: rightFooter) {
                return false
            } else if (left.footer == nil && right.footer != nil) || (left.footer != nil && right.footer != nil) {
                return false
            }
            return true
        }
    }
}

extension UICollectionView {
    
    private func registerNewCell(from sections: [UICollectionView.Section]) {
        self.register(
            UICollectionViewCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "Artisan_Layout_plain_\(UICollectionView.elementKindSectionHeader)"
        )
        self.register(
            UICollectionViewCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: "Artisan_Layout_plain_\(UICollectionView.elementKindSectionFooter)"
        )
        self.register(
            UICollectionViewCell.self,
            forCellWithReuseIdentifier: "Artisan_Layout_plain_cell"
        )
        var registeredCells: [String] = []
        var registeredHeaderSupplements: [String] = []
        var registeredFooterSupplements: [String] = []
        for section in sections {
            for cell in section.cells where !registeredCells.contains(cell.reuseIdentifier) {
                self.register(cell.cellClass, forCellWithReuseIdentifier: cell.reuseIdentifier)
                registeredCells.append(cell.reuseIdentifier)
            }
            if let supplementSection = section as? UICollectionView.SupplementedSection {
                if let header = supplementSection.header,
                   !registeredHeaderSupplements.contains(header.reuseIdentifier) {
                    self.register(
                        header.cellClass,
                        forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                        withReuseIdentifier: header.reuseIdentifier
                    )
                    registeredHeaderSupplements.append(header.reuseIdentifier)
                }
                if let footer = supplementSection.footer,
                   !registeredFooterSupplements.contains(footer.reuseIdentifier) {
                    self.register(
                        footer.cellClass,
                        forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                        withReuseIdentifier: footer.reuseIdentifier
                    )
                    registeredFooterSupplements.append(footer.reuseIdentifier)
                }
            }
        }
    }
}

extension UICollectionView.Mediator: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.applicableSections[safe: section]?.cellCount ?? 0
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        self.applicableSections.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = self.applicableSections[safe: indexPath.section],
              let cellMediator = section.cells[safe: indexPath.item]
        else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "Artisan_Layout_plain_cell", for: indexPath)
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellMediator.reuseIdentifier, for: indexPath)
        if let cellLayoutable = cell as? CollectionFragmentCell {
            let contentWidth: CGFloat = min(
                collectionView.contentSize.width,
                collectionView.collectionViewLayout.collectionViewContentSize.width
            )
            let contentHeight: CGFloat = min(
                collectionView.contentSize.height,
                collectionView.collectionViewLayout.collectionViewContentSize.height
            )
            let contentInset: UIEdgeInsets = collectionView.contentInset
            let sectionInset: UIEdgeInsets = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?
                .sectionInset ?? .zero
            let collectionContentWidth = contentWidth - contentInset.left -
                contentInset.right - sectionInset.left - sectionInset.left
            let collectionContentHeight = contentHeight - contentInset.top -
                contentInset.bottom - sectionInset.top - sectionInset.bottom
            cellLayoutable.collectionContentSize = CGSize(width: collectionContentWidth, height: collectionContentHeight)
        }
        cellMediator.apply(cell: cell)
        return cell
    }
    
    public func indexTitles(for collectionView: UICollectionView) -> [String]? {
        var titles: [String] = []
        var titleCount: Int = 0
        self.applicableSections.forEach {
            if let title = ($0 as? UICollectionView.IndexedSection)?.indexTitle {
                titleCount += 1
                titles.append(title)
            } else {
                titles.append("")
            }
        }
        guard titleCount > 0 else { return nil }
        return titles
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader,
           let section = applicableSections[safe: indexPath.section] as? UICollectionView.SupplementedSection,
           let header = section.header {
            let headerCell = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: header.reuseIdentifier,
                for: indexPath
            )
            header.apply(cell: headerCell as! UICollectionViewCell)
            return headerCell
        } else if kind == UICollectionView.elementKindSectionFooter,
                  let section = applicableSections[safe: indexPath.section] as? UICollectionView.SupplementedSection,
                  let footer = section.footer {
            let footerCell = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: footer.reuseIdentifier,
                for: indexPath
            )
            footer.apply(cell: footerCell as! UICollectionViewCell)
            return footerCell
        }
        return collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: "Artisan_Layout_plain_\(kind)",
            for: indexPath
        )
    }
}
