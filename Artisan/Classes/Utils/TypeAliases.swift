//
//  TypeAliases.swift
//  Artisan
//
//  Created by Nayanda Haberty on 31/05/22.
//

import Foundation
#if canImport(UIKit)
import UIKit

// MARK: Arrays

public typealias Cells<CellType: ContentCellCompatible> = [Cell<CellType>] where CellType.Container: ContainerCellCompatible, CellType.Container.Cell == CellType
public typealias Sections<CellType: ContentCellCompatible> = [Section<CellType>] where CellType.Container: ContainerCellCompatible, CellType.Container.Cell == CellType

// MARK: Providers

public typealias SectionProvider<Item: Hashable, CellType: ContentCellCompatible> = (Int, Item) -> Sections<CellType> where CellType.Container: ContainerCellCompatible, CellType.Container.Cell == CellType
public typealias SingleSectionProvider<Item: Hashable, CellType: ContentCellCompatible> = (Item) -> Sections<CellType> where CellType.Container: ContainerCellCompatible, CellType.Container.Cell == CellType
public typealias CellProvider<Item: Hashable, CellType: ContentCellCompatible> = (Int, Item) -> Cells<CellType> where CellType.Container: ContainerCellCompatible, CellType.Container.Cell == CellType

// MARK: Table Providers

public typealias TableCellProvider<Item: Hashable> = CellProvider<Item, UITableViewCell>
public typealias TableSectionProvider<Item: Hashable> = SectionProvider<Item, UITableViewCell>
public typealias TableSingleSectionProvider<Item: Hashable> = SingleSectionProvider<Item, UITableViewCell>

// MARK: Collection Providers

public typealias CollectionCellProvider<Item: Hashable> = CellProvider<Item, UICollectionViewCell>
public typealias CollectionSectionProvider<Item: Hashable> = SectionProvider<Item, UICollectionViewCell>
public typealias SingleCollectionSectionProvider<Item: Hashable> = SingleSectionProvider<Item, UICollectionViewCell>

// MARK: ArrayBuilder

public typealias CellPlan<CellType: ContentCellCompatible> = ArrayBuilder<Cell<CellType>> where CellType.Container: ContainerCellCompatible, CellType.Container.Cell == CellType
public typealias SectionPlan<CellType: ContentCellCompatible> = ArrayBuilder<Section<CellType>> where CellType.Container: ContainerCellCompatible, CellType.Container.Cell == CellType
public typealias TableCellPlan = CellPlan<UITableViewCell>
public typealias CollectionCellPlan = CellPlan<UICollectionViewCell>
public typealias TableSectionPlan = SectionPlan<UITableViewCell>
public typealias CollectionSectionPlan = SectionPlan<UICollectionViewCell>
#endif
