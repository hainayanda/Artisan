//
//  CellBuilder.swift
//  Artisan
//
//  Created by Nayanda Haberty on 28/05/22.
//

import Foundation
#if canImport(UIKit)
import UIKit
import Pharos
import DiffableDataSources
import Chary

enum CellBuildingState {
    case applying
    case free
}

class CellBuilder<Item: Hashable, CellType: ContentCellCompatible>: ObjectRetainer where CellType.Container: ContainerCellCompatible, CellType.Container.Cell == CellType {
    typealias DataBinding = CellType.Container.DataBinding
    typealias CellItem = Cell<CellType>
    
    lazy var dispatcher: DispatchQueue = DispatchQueue(label: "Artisan-CellBuilder_\(ObjectIdentifier(self).hashValue)")
    
    @Atomic var state: CellBuildingState = .free {
        didSet {
            applyPendingIfNeeded()
        }
    }
    
    @Atomic var pendingSnapshot: DiffableDataSourceSnapshot<Section<CellType>, Cell<CellType>>?
    
    var dataSource: DataBinding
    
    init(for container: CellType.Container) {
        self.dataSource = Self.createDataSource(for: container)
        container.dataSource = dataSource
        $state = dispatcher
        $pendingSnapshot = dispatcher
    }
    
    func applyIfFree(for snapshot: DiffableDataSourceSnapshot<Section<CellType>, Cell<CellType>>) {
        dispatcher.safeSync {
            switch state {
            case .applying:
                pendingSnapshot = snapshot
                return
            case .free:
                self.state = .applying
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.apply(snapshot: snapshot) {
                        self.state = .free
                    }
                }
            }
        }
    }
    
    func applyPendingIfNeeded() {
        dispatcher.safeSync {
            guard let pending = pendingSnapshot else { return }
            switch state {
            case .applying:
                return
            case .free:
                pendingSnapshot = nil
                applyIfFree(for: pending)
            }
        }
    }
    
    class func createDataSource(for container: CellType.Container) -> DataBinding {
        fatalError("createDataSource() should be overridden")
    }
    
    func apply(snapshot: DiffableDataSourceSnapshot<Section<CellType>, Cell<CellType>>, completion: @escaping () -> Void) {
        fatalError("apply(snapshot:) should be overridden")
    }
}

extension CellBuilder {
    
    // MARK: Sectioned Init
    
    convenience init(
        for container: CellType.Container,
        observableSectionItems: Observable<[Item]>,
        @SectionPlan<CellType> sectionProvider: @escaping SectionProvider<Item, CellType>
    ) {
        self.init(for: container)
        observableSectionItems
            .ignoreSameValue()
            .whenDidSet { [unowned self] changes in
                self.applyIfFree(for: changes.new.toSnapShot(using: sectionProvider))
            }.observe(on: .global(qos: .background))
            .retained(by: self)
            .fire()
    }
    
    convenience init(
        for container: CellType.Container,
        sectionItems: [Item],
        @SectionPlan<CellType> sectionProvider: @escaping SectionProvider<Item, CellType>
    ) {
        self.init(for: container)
        self.applyIfFree(for: sectionItems.toSnapShot(using: sectionProvider))
    }
    
    convenience init(
        for container: CellType.Container,
        observableSectionItem: Observable<Item>,
        @SectionPlan<CellType> sectionProvider: @escaping SingleSectionProvider<Item, CellType>
    ) {
        self.init(
            for: container,
            observableSectionItems: observableSectionItem.mapped { [$0] }) { _, item in
                return sectionProvider(item)
            }
    }
    
    convenience init(
        for container: CellType.Container,
        sectionItem: Item,
        @SectionPlan<CellType> sectionProvider: @escaping SingleSectionProvider<Item, CellType>
    ) {
        self.init(for: container, sectionItems: [sectionItem]) { _, item in
            return sectionProvider(item)
        }
    }
    
    // MARK: No Section Init
    
    convenience init(
        for container: CellType.Container,
        observableItems: Observable<[Item]>,
        @CellPlan<CellType> cellProvider: @escaping CellProvider<Item, CellType>
    ) {
        self.init(for: container)
        observableItems
            .ignoreSameValue()
            .whenDidSet { [unowned self] changes in
                var snapshot =  DiffableDataSourceSnapshot<Section<CellType>, CellItem>()
                let section = Section(items: changes.new, provider: cellProvider)
                snapshot.appendSections([section])
                snapshot.appendItems(section.cellItems)
                self.applyIfFree(for: snapshot)
            }.observe(on: .global(qos: .background))
            .retained(by: self)
            .fire()
    }
    
    convenience init(
        for container: CellType.Container,
        items: [Item],
        @CellPlan<CellType> cellProvider: @escaping CellProvider<Item, CellType>
    ) {
        self.init(for: container)
        var snapshot =  DiffableDataSourceSnapshot<Section<CellType>, CellItem>()
        let section = Section(items: items, provider: cellProvider)
        snapshot.appendSections([section])
        snapshot.appendItems(section.cellItems)
        self.applyIfFree(for: snapshot)
    }
}

// MARK: Collection

class CollectionCellBuilder<Item: Hashable>: CellBuilder<Item, UICollectionViewCell> {
    override class func createDataSource(for container: UICollectionView) -> DataBinding {
        CollectionViewDiffableDataSource<Section<UICollectionViewCell>, CellItem>(collectionView: container) { collection, index, itemCell in
            itemCell.provideCell(for: collection, at: index)
        }
    }
    
    override func apply(snapshot: DiffableDataSourceSnapshot<Section<UICollectionViewCell>, Cell<UICollectionViewCell>>, completion: @escaping () -> Void) {
        guard let dataSource = self.dataSource as? CollectionViewDiffableDataSource<Section<UICollectionViewCell>, CellItem> else {
            return
        }
        dataSource.apply(snapshot, animatingDifferences: true, completion: completion)
    }
}

// MARK: Table

class TableCellBuilder<Item: Hashable>: CellBuilder<Item, UITableViewCell> {
    override class func createDataSource(for container: UITableView) -> DataBinding {
        ArtisanTableDiffableDataSource(tableView: container) { collection, index, itemCell in
            itemCell.provideCell(for: collection, at: index)
        }
    }
    
    override func apply(snapshot: DiffableDataSourceSnapshot<Section<UITableViewCell>, Cell<UITableViewCell>>, completion: @escaping () -> Void) {
        guard let dataSource = self.dataSource as? ArtisanTableDiffableDataSource else {
            return
        }
        dataSource.apply(snapshot, animatingDifferences: true, completion: completion)
    }
}

class ArtisanTableDiffableDataSource: TableViewDiffableDataSource<Section<UITableViewCell>, Cell<UITableViewCell>> {
    var lastSnapshot: DiffableDataSourceSnapshot<Section<UITableViewCell>, Cell<UITableViewCell>>?
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let titledSection = snapshot().sectionIdentifiers[section] as? TitledSection else {
            return nil
        }
        return titledSection.title
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        guard let titledSection = snapshot().sectionIdentifiers[section] as? TitledSection else {
            return nil
        }
        return titledSection.footer
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        let indexTitles: [String] = snapshot().sectionIdentifiers.map {
            guard let titledSection = $0 as? TitledSection,
                  titledSection.indexed,
                  let firstCharacter = titledSection.title?.first ?? titledSection.footer?.first else {
                return ""
            }
            return "\(firstCharacter)"
        }
        guard !indexTitles.isAllEmptyString else {
            return nil
        }
        return indexTitles
    }
}

extension Array where Element == String {
    var isAllEmptyString: Bool {
        for element in self where !element.isEmpty {
            return false
        }
        return true
    }
}
#endif
