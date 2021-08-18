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
import Builder

extension UICollectionView {
    
    public var mediator: UICollectionView.Mediator {
        if let mediator = getMediator() as? UICollectionView.Mediator {
            return mediator
        }
        let mediator = Mediator()
        mediator.bond(with: self)
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
            mediator.cells
        }
        set {
            mediator.cells = newValue
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
    
    public func reloadWith(@CollectionSectionBuilder _ builder: () -> [CollectionSection]) {
        sections = builder()
    }
    
    public func appendCells(@CollectionCellBuilder _ builder: () -> [AnyCollectionCellMediator]) {
        let currentSections = sections
        guard let lastSection = sections.last else {
            cells = builder()
            return
        }
        lastSection.add(builder)
        sections = currentSections
    }
    
    public func whenDidReloadCells(then: ((Bool) -> Void)?) {
        mediator.whenDidReloadCells(then: then)
    }
}

extension UICollectionView {
    
    public final class Mediator: ViewMediator<UICollectionView> {
        var tapGestureRecognizer: UITapGestureRecognizer = builder(UITapGestureRecognizer(target: self, action: #selector(didTap(_:))))
            .numberOfTouchesRequired(1)
            .isEnabled(true)
            .cancelsTouchesInView(false)
            .build()
        
        var applicableSections: [Section] = []
        var pendingSections: [Section]?
        @Observable public var sections: [Section] = []
        @Observable public var cells: [AnyCollectionCellMediator] = []
        var lock: NSLock = NSLock()
        
        public var reloadStrategy: CellReloadStrategy = .reloadArrangementDifference
        var didReloadAction: ((Bool) -> Void)?
        
        public override func willBonded(with view: UICollectionView) {
            view.dataSource = self
            view.addGestureRecognizer(tapGestureRecognizer)
        }
        
        public override func bonding(with view: UICollectionView) {
            $sections.observe(on: .main)
                .whenDidSet(invoke: self, method: Mediator.reload(with:))
            _cells.mutator { [weak self] in
                self?.sections.first?.cells ?? []
            } set: { newValue in
                self.sections = [Section(identifier: "single_section", cells: newValue)]
            }
        }
        
        public override func bondDidRemoved() {
            tapGestureRecognizer.view?.removeGestureRecognizer(tapGestureRecognizer)
        }
        
        public func whenDidReloadCells(then: ((Bool) -> Void)?) {
            didReloadAction = then
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
        
        func reload(with changes: Changes<[Section]>) {
            let lock = self.lock
            guard lock.try() else {
                pendingSections = changes.new
                return
            }
            self.load(sections: changes.new)
            while let pending = self.pendingSections {
                self.load(sections: pending)
            }
            lock.unlock()
        }
        
        func load(sections: [Section]) {
            let oldSections = applicableSections
            applicableSections = sections
            guard let view = bondedView else { return }
            view.registerNewCell(from: sections)
            reload(view, with: sections, oldSections: oldSections, completion: self.didReloadAction)
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
