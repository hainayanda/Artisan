//
//  UICollectionView+Mediator.swift
//  Artisan
//
//  Created by Nayanda Haberty on 16/04/21.
//

import Foundation
#if canImport(UIKit)
import UIKit
import Draftsman
import Pharos

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
            let section = Section(distinctIdentifier: "single_section", cells: newValue)
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
        return customCellSize.isCalculated ? customCellSize : (flowSize.isCalculated ? flowSize : actualSizeFromCell)
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
        buildWithCells(withFirstSection: Section(distinctIdentifier: firstSection), builder)
    }
    
    public func buildWithCells(withFirstSection firstSection: UICollectionView.Section? = nil, _ builder: (CollectionCellBuilder) -> Void) {
        let collectionBuilder = CollectionCellBuilder(section: firstSection ?? Section(distinctIdentifier: "first_section"))
        builder(collectionBuilder)
        sections = collectionBuilder.build()
    }
    
    public func whenDidReloadCells(then: ((Bool) -> Void)?) {
        mediator.whenDidReloadCells(then: then)
    }
    
    public class Mediator: ViewMediator<UICollectionView> {
        var tapGestureRecognizer: UITapGestureRecognizer = builder(UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))) {
            $0.numberOfTouchesRequired = 1
            $0.isEnabled = true
            $0.cancelsTouchesInView = false
        }
        var applicableSections: [Section] = []
        @Observable public var sections: [Section] = []
        public var reloadStrategy: CellReloadStrategy = .reloadArrangementDifference
        var didReloadAction: ((Bool) -> Void)?
        
        public override func bonding(with view: UICollectionView) {
            super.bonding(with: view)
            $sections.observe(on: .main).whenDidSet { [weak self, weak view] changes in
                guard let self = self, let collection = view else { return }
                let newSection = changes.new
                collection.registerNewCell(from: newSection)
                let oldSection = self.applicableSections
                self.applicableSections = newSection
                self.reload(collection, with: newSection, oldSections: oldSection, completion: self.didReloadAction)
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
            guard let collection = gesture.view as? UICollectionView else { return }
            let location = gesture.location(in: collection)
            guard let indexPath = collection.indexPathForItem(at: location),
                  let cell = collection.cellForItem(at: indexPath),
                  let mediator = cell.getMediator() as? AnyCollectionCellMediator else {
                return
            }
            mediator.didTap(cell: cell)
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
