//
//  Cell.swift
//  Artisan
//
//  Created by Nayanda Haberty on 28/05/22.
//

import Foundation
#if canImport(UIKit)
import UIKit

public class Cell<CellType: ContentCellCompatible>: Hashable where CellType.Container: ContainerCellCompatible, CellType.Container.Cell == CellType {
    public typealias Applicator = (CellType, IndexPath) -> Void
    
    let type: CellType.Type
    var identifier: String
    var item: AnyHashable?
    var index: Int = 0
    let applicator: Applicator
    
    init(_ cellType: CellType.Type, identifier: String, _ applicator: @escaping Applicator = { _, _ in }) {
        self.applicator = applicator
        self.type = cellType
        self.identifier = identifier
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
        hasher.combine(item)
        hasher.combine(index)
    }
    
    public static func == (lhs: Cell, rhs: Cell) -> Bool {
        lhs.identifier == rhs.identifier
        && lhs.item == rhs.item && lhs.index == rhs.index
    }
    
    func addForHash(item: AnyHashable, andIndex index: Int) {
        self.item = item
        self.index = index
    }
    
    func provideCell(for container: CellType.Container, at indexPath: IndexPath) -> CellType? {
        if container.registeredCellIdentifiers[identifier] == nil {
            container.register(cell: type, identifier: identifier)
        }
        guard let cell = container.dequeueReusable(identifier: identifier, at: indexPath) else {
            return nil
        }
        applicator(cell, indexPath)
        return cell
    }
}

// MARK: TableCell

extension Cell where CellType == UITableViewCell {
    public convenience init<TableCell: UITableViewCell>(
        from cellType: TableCell.Type,
        _ applicator: @escaping (TableCell, IndexPath) -> Void = { _, _ in }) {
            self.init(cellType, identifier: TableCell.artisanReuseIdentifier) { cell, indexPath in
                guard let tableCell = cell as? TableCell else { return }
                applicator(tableCell, indexPath)
            }
        }
    
    public convenience init<TableCell: UITableViewCell & ViewBinding, TableModel: ViewModel>(
        from cellType: TableCell.Type, bindWith viewModel: TableModel
    ) where TableCell.DataBinding == TableModel.DataBinding, TableCell.Subscriber == TableModel.Subscriber {
        self.init(cellType, identifier: TableCell.artisanReuseIdentifier) { cell, indexPath in
            guard let tableCell = cell as? TableCell else { return }
            tableCell.bind(with: viewModel)
        }
    }
    
}

// MARK: CollectionCell

extension Cell where CellType == UICollectionViewCell {
    public convenience init<CollectionCell: UICollectionViewCell>(
        from cellType: CollectionCell.Type,
        _ applicator: @escaping (CollectionCell, IndexPath) -> Void = { _, _ in }) {
            self.init(cellType, identifier: CollectionCell.artisanReuseIdentifier) { cell, indexPath in
                guard let collectionCell = cell as? CollectionCell else { return }
                applicator(collectionCell, indexPath)
            }
        }
    
    public convenience init<CollectionCell: UICollectionViewCell & ViewBinding, CollectionModel: ViewModel>(
        from cellType: CollectionCell.Type, bindWith viewModel: CollectionModel
    ) where CollectionCell.DataBinding == CollectionModel.DataBinding, CollectionCell.Subscriber == CollectionModel.Subscriber {
        self.init(cellType, identifier: CollectionCell.artisanReuseIdentifier) { cell, indexPath in
            guard let collectionCell = cell as? CollectionCell else { return }
            collectionCell.bind(with: viewModel)
        }
    }
}
#endif
