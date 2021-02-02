//
//  UICollectionView+Mediator.swift
//  Artisan
//
//  Created by Nayanda Haberty (ID) on 12/08/20.
//

import Foundation
#if canImport(UIKit)
import UIKit

public typealias CollectionSection = UICollectionView.Section
public typealias SupplementedCollectionSection = UICollectionView.SupplementedSection

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
    
    public var cells: [AnyCollectionCellMediator] {
        get {
            mediator.sections.first?.cells ?? []
        }
        set {
            let section = Section(identifier: "single_section", cells: newValue)
            mediator.sections = [section]
        }
    }
    
    public var reloadStrategy: CellReloadStrategy {
        get {
            mediator.reloadStrategy
        }
        set {
            mediator.reloadStrategy = newValue
        }
    }
    
    public func cellSizeFromMediator(at indexPath: IndexPath) -> CGSize {
        let contentSize: CGSize = sizeOfContent
        let collectionFlow = collectionViewLayout as? UICollectionViewFlowLayout
        let estimatedSize = collectionFlow?.estimatedItemSize
        let itemSize = collectionFlow?.itemSize
        let flowSize = (itemSize ?? estimatedSize) ?? .automatic
        let collectionCell = cellForItem(at: indexPath)
        let currentSize = collectionCell?.bounds.size ?? .zero
        let calculatedSize = collectionCell?.sizeThatFits(sizeOfContent) ?? .zero
        let actualSizeFromCell = currentSize.isVisible ? currentSize : (calculatedSize.isVisible ? calculatedSize : .zero)
        guard let cell = sections[safe: indexPath.section]?.cells[safe: indexPath.item] else {
            return flowSize.isCalculated ? flowSize : actualSizeFromCell
        }
        let customCellSize = cell.customCellSize(for: contentSize)
        let defaultSize = cell.defaultCellSize(for: contentSize)
        let artisanSize = customCellSize.isCalculated ? customCellSize : defaultSize
        return artisanSize.isCalculated ? artisanSize : (flowSize.isCalculated ? flowSize : actualSizeFromCell)
    }
    
    public func appendWithCell(_ builder: (CollectionCellBuilder) -> Void) {
        guard !sections.isEmpty else {
            buildWithCells(builder)
            return
        }
        let collectionBuilder = CollectionCellBuilder(sections: sections)
        builder(collectionBuilder)
        sections = collectionBuilder.build()
    }
    
    public func buildWithCells(withFirstSectionId firstSection: String, _ builder: (CollectionCellBuilder) -> Void) {
        buildWithCells(withFirstSection: Section(identifier: firstSection), builder)
    }
    
    public func buildWithCells(withFirstSection firstSection: UICollectionView.Section? = nil, _ builder: (CollectionCellBuilder) -> Void) {
        let collectionBuilder = CollectionCellBuilder(section: firstSection ?? Section(identifier: "first_section"))
        builder(collectionBuilder)
        sections = collectionBuilder.build()
    }
    
    public func whenDidReloadCells(then: ((Bool) -> Void)?) {
        mediator.whenDidReloadCells(then: then)
    }
    
    public class Mediator: ViewMediator<UICollectionView> {
        var tapGestureRecognizer: UITapGestureRecognizer = build(UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))) {
            $0.numberOfTouchesRequired = 1
            $0.isEnabled = true
            $0.cancelsTouchesInView = false
        }
        var applicableSections: [Section] = []
        @ObservableState public var sections: [Section] = []
        public var reloadStrategy: CellReloadStrategy = .reloadArrangementDifference
        var didReloadAction: ((Bool) -> Void)?
        
        public override func bonding(with view: UICollectionView) {
            super.bonding(with: view)
            $sections.observe(observer: self, on: .main, syncIfPossible: false).didSet { mediator, changes  in
                guard let collection = mediator.view else { return }
                let newSection = changes.new
                collection.registerNewCell(from: newSection)
                let oldSection = mediator.applicableSections
                mediator.applicableSections = newSection
                mediator.reload(collection, with: newSection, oldSections: oldSection, completion: mediator.didReloadAction)
            }
        }
        
        public func whenDidReloadCells(then: ((Bool) -> Void)?) {
            didReloadAction = then
        }
        
        public override func didApplying(_ view: UICollectionView) {
            view.dataSource = self
            view.addGestureRecognizer(tapGestureRecognizer)
        }
        
        @objc public func didTap(_ gesture: UITapGestureRecognizer) {
            guard let collection = view else { return }
            let location = gesture.location(in: collection)
            guard let indexPath = collection.indexPathForItem(at: location),
                  let cell = collection.cellForItem(at: indexPath),
                  let mediator = cell.getMediator() as? AnyCollectionCellMediator else {
                return
            }
            mediator.didTap(cell: cell)
        }
    }
    
    open class Section: Identifiable, Equatable {
        public var index: String?
        public var cells: [AnyCollectionCellMediator]
        public var cellCount: Int { cells.count }
        public var identifier: AnyHashable
        
        public init(identifier: AnyHashable = String.randomString(), index: String? = nil, cells: [AnyCollectionCellMediator] = []) {
            self.identifier = identifier
            self.cells = cells
            self.index = index
        }
        
        public func add(cell: AnyCollectionCellMediator) {
            cells.append(cell)
        }
        
        public func add(cells: [AnyCollectionCellMediator]) {
            self.cells.append(contentsOf: cells)
        }
        
        func isSameSection(with other: Section) -> Bool {
            if other === self { return true }
            return other.identifier == identifier
        }
        
        public func clear() {
            cells.removeAll()
        }
        
        public func copy() -> Section {
            return Section(identifier: identifier, cells: cells)
        }
        
        public static func == (lhs: UICollectionView.Section, rhs: UICollectionView.Section) -> Bool {
            let left = lhs.copy()
            let right = rhs.copy()
            guard left.identifier == right.identifier,
                  left.cells.count == right.cells.count else { return false }
            for (index, cell) in left.cells.enumerated() where !right.cells[index].isSameMediator(with: cell) {
                return false
            }
            return true
        }
    }
    
    public class SupplementedSection: Section {
        
        public var header: AnyCollectionCellMediator?
        public var footer: AnyCollectionCellMediator?
        
        public init(header: AnyCollectionCellMediator? = nil, footer: AnyCollectionCellMediator? = nil, identifier: AnyHashable = String.randomString(), index: String? = nil, cells: [AnyCollectionCellMediator] = []) {
            self.header = header
            self.footer = footer
            super.init(identifier: identifier, index: index, cells: cells)
        }
        
        public override func copy() -> Section {
            return SupplementedSection(header: header, footer: footer, identifier: identifier, cells: cells)
        }
        
        public static func == (lhs: UICollectionView.SupplementedSection, rhs: UICollectionView.SupplementedSection) -> Bool {
            guard let left = lhs.copy() as? UICollectionView.SupplementedSection,
                  let right = rhs.copy() as? UICollectionView.SupplementedSection else {
                return false
            }
            guard left.identifier == right.identifier,
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
    
    func registerNewCell(from sections: [UICollectionView.Section]) {
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
    
    var sizeOfContent: CGSize {
        let contentWidth: CGFloat = contentSize.width
        let contentHeight: CGFloat = contentSize.height
        let contentInset: UIEdgeInsets = self.contentInset
        let sectionInset: UIEdgeInsets = (collectionViewLayout as? UICollectionViewFlowLayout)?
            .sectionInset ?? .zero
        let collectionContentWidth = contentWidth - contentInset.horizontal.both - sectionInset.horizontal.both
        let collectionContentHeight = contentHeight - contentInset.vertical.both - sectionInset.vertical.both
        return .init(width: collectionContentWidth, height: collectionContentHeight)
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
            cellLayoutable.collectionContentSize = collectionView.sizeOfContent
        }
        cellMediator.apply(cell: cell)
        return cell
    }
    
    public func indexTitles(for collectionView: UICollectionView) -> [String]? {
        var titles: [String] = []
        var titleCount: Int = 0
        self.applicableSections.forEach {
            if let title = $0.index {
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
#endif
