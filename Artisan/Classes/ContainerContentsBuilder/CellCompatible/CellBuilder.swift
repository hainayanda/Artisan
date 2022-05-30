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

public typealias Sections<CellType: ContentCellCompatible> = [Section<CellType>] where CellType.Container: ContainerCellCompatible, CellType.Container.Cell == CellType
public typealias SectionProvider<Item: Hashable, CellType: ContentCellCompatible> = (Int, Item) -> Sections<CellType> where CellType.Container: ContainerCellCompatible, CellType.Container.Cell == CellType
public typealias SingleSectionProvider<Item: Hashable, CellType: ContentCellCompatible> = (Item) -> Sections<CellType> where CellType.Container: ContainerCellCompatible, CellType.Container.Cell == CellType
public typealias Cells<CellType: ContentCellCompatible> = [Cell<CellType>] where CellType.Container: ContainerCellCompatible, CellType.Container.Cell == CellType
public typealias CellProvider<Item: Hashable, CellType: ContentCellCompatible> = (Int, Item) -> Cells<CellType> where CellType.Container: ContainerCellCompatible, CellType.Container.Cell == CellType

class CellBuilder<Item: Hashable, CellType: ContentCellCompatible>: ObjectRetainer where CellType.Container: ContainerCellCompatible, CellType.Container.Cell == CellType {
    
    typealias DataBinding = CellType.Container.DataBinding
    typealias CellItem = Cell<CellType>
    
    var dataSource: DataBinding
    
    init(
        for container: CellType.Container,
        observableSectionItems: Observable<[Item]>,
        @SectionPlan<CellType> sectionProvider: @escaping SectionProvider<Item, CellType>) {
            let dataSource = Self.createDataSource(for: container)
            self.dataSource = dataSource
            container.dataSource = dataSource
            observableSectionItems
                .ignoreSameValue()
                .whenDidSet { [unowned self] changes in
                    let snapshot = changes.new.toSnapShot(using: sectionProvider)
                    DispatchQueue.main.async { [weak self] in
                        self?.apply(snapshot: snapshot)
                    }
                }.retained(by: self)
                .notifyWithCurrentValue()
        }
    
    init(
        for container: CellType.Container,
        sectionItems: [Item],
        @SectionPlan<CellType> sectionProvider: @escaping SectionProvider<Item, CellType>) {
            let dataSource = Self.createDataSource(for: container)
            self.dataSource = dataSource
            container.dataSource = dataSource
            self.apply(snapshot: sectionItems.toSnapShot(using: sectionProvider))
        }
    
    init(
        for container: CellType.Container,
        observableSectionItem: Observable<Item>,
        @SectionPlan<CellType> sectionProvider: @escaping SingleSectionProvider<Item, CellType>) {
            let dataSource = Self.createDataSource(for: container)
            self.dataSource = dataSource
            container.dataSource = dataSource
            observableSectionItem
                .ignoreSameValue()
                .whenDidSet { [unowned self] changes in
                    var snapshot = DiffableDataSourceSnapshot<Section<CellType>, Cell<CellType>>()
                    sectionProvider(changes.new).enumerated().forEach { sectionIndex, section in
                            section.addForHash(itemIndex: 0, index: sectionIndex)
                            snapshot.appendSections([section])
                            snapshot.appendItems(section.cellItems)
                    }
                    DispatchQueue.main.async { [weak self] in
                        self?.apply(snapshot: snapshot)
                    }
                }.retained(by: self)
                .notifyWithCurrentValue()
        }
    
    init(
        for container: CellType.Container,
        sectionItem: Item,
        @SectionPlan<CellType> sectionProvider: @escaping SingleSectionProvider<Item, CellType>) {
            let dataSource = Self.createDataSource(for: container)
            self.dataSource = dataSource
            container.dataSource = dataSource
            var snapshot = DiffableDataSourceSnapshot<Section<CellType>, Cell<CellType>>()
            sectionProvider(sectionItem).enumerated().forEach { sectionIndex, section in
                    section.addForHash(itemIndex: 0, index: sectionIndex)
                    snapshot.appendSections([section])
                    snapshot.appendItems(section.cellItems)
            }
            DispatchQueue.main.async { [weak self] in
                self?.apply(snapshot: snapshot)
            }
        }
    
    init(
        for container: CellType.Container,
        observableItems: Observable<[Item]>,
        @CellPlan<CellType> cellProvider: @escaping CellProvider<Item, CellType>) {
            let dataSource = Self.createDataSource(for: container)
            self.dataSource = dataSource
            container.dataSource = dataSource
            observableItems
                .ignoreSameValue()
                .whenDidSet { changes in
                    var snapshot =  DiffableDataSourceSnapshot<Section<CellType>, CellItem>()
                    let section = Section(items: changes.new, provider: cellProvider)
                    snapshot.appendSections([section])
                    snapshot.appendItems(section.cellItems)
                    DispatchQueue.main.async { [weak self] in
                        self?.apply(snapshot: snapshot)
                    }
                }.retained(by: self)
                .notifyWithCurrentValue()
        }
    
    init(
        for container: CellType.Container,
        items: [Item],
        @CellPlan<CellType> cellProvider: @escaping CellProvider<Item, CellType>) {
            let dataSource = Self.createDataSource(for: container)
            self.dataSource = dataSource
            container.dataSource = dataSource
            var snapshot =  DiffableDataSourceSnapshot<Section<CellType>, CellItem>()
            let section = Section(items: items, provider: cellProvider)
            snapshot.appendSections([section])
            snapshot.appendItems(section.cellItems)
            DispatchQueue.main.async { [weak self] in
                self?.apply(snapshot: snapshot)
            }
        }
    
    class func createDataSource(for container: CellType.Container) -> DataBinding {
        fatalError("createDataSource() should be overridden")
    }
    
    func apply(snapshot: DiffableDataSourceSnapshot<Section<CellType>, Cell<CellType>>) {
        fatalError("apply(snapshot:) should be overridden")
    }
}

class CollectionCellBuilder<Item: Hashable>: CellBuilder<Item, UICollectionViewCell> {
    override class func createDataSource(for container: UICollectionView) -> DataBinding {
        CollectionViewDiffableDataSource<Section<UICollectionViewCell>, CellItem>(collectionView: container) { collection, index, itemCell in
            itemCell.provideCell(for: collection, at: index)
        }
    }
    
    override func apply(snapshot: DiffableDataSourceSnapshot<Section<UICollectionViewCell>, Cell<UICollectionViewCell>>) {
        (dataSource as? CollectionViewDiffableDataSource<Section<UICollectionViewCell>, CellItem>)?.apply(snapshot)
    }
}

class TableCellBuilder<Item: Hashable>: CellBuilder<Item, UITableViewCell> {
    override class func createDataSource(for container: UITableView) -> DataBinding {
        ArtisanTableDiffableDataSource(tableView: container) { collection, index, itemCell in
            itemCell.provideCell(for: collection, at: index)
        }
    }
    
    override func apply(snapshot: DiffableDataSourceSnapshot<Section<UITableViewCell>, Cell<UITableViewCell>>) {
        guard let dataSource = self.dataSource as? ArtisanTableDiffableDataSource else {
            return
        }
        dataSource.apply(snapshot)
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
            return true
        }
        return false
    }
}
#endif
