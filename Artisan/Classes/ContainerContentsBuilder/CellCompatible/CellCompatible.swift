//
//  CellCompatible.swift
//  Artisan
//
//  Created by Nayanda Haberty on 28/05/22.
//

import Foundation
#if canImport(UIKit)
import UIKit
import DiffableDataSources

// MARK: Protocols

public protocol ContainerCellCompatible where Self: UIView {
    associatedtype Cell: UIView
    associatedtype DataBinding
    
    var dataSource: DataBinding? { get set }
    func register(cell type: Cell.Type)
    func dequeueReusable(cell type: Cell.Type, at indexPath: IndexPath) -> Cell?
    
}

public protocol ContentCellCompatible where Self: UIView {
    associatedtype Container: UIView
    
    static var artisanReuseIdentifier: String { get }
}

// MARK: Extension

fileprivate var registeredCellIdentifiersAssociatedKey: String = "registeredCellIdentifiersAssociatedKey"

extension ContainerCellCompatible {
    
    var registeredCellIdentifiers: [String] {
        get {
            objc_getAssociatedObject(self, &registeredCellIdentifiersAssociatedKey) as? [String] ?? []
        }
        set {
            objc_setAssociatedObject(self, &registeredCellIdentifiersAssociatedKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}

extension ContentCellCompatible {
    public static var artisanReuseIdentifier: String { "artisan_table-cell_\(Self.self)" }
}

// MARK: UITableView

extension UITableView: ContainerCellCompatible {
    public typealias Cell = UITableViewCell
    public typealias DataBinding = UITableViewDataSource
    public typealias DiffableDataSource = TableViewDiffableDataSource<Section<Cell>, Artisan.Cell<Cell>>
    
    public func register(cell type: UITableViewCell.Type) {
        register(type, forCellReuseIdentifier: type.artisanReuseIdentifier)
    }
    
    public func dequeueReusable(cell type: UITableViewCell.Type, at indexPath: IndexPath) -> UITableViewCell? {
        dequeueReusableCell(withIdentifier: type.artisanReuseIdentifier, for: indexPath)
    }
}

extension UITableViewCell: ContentCellCompatible {
    public typealias Container = UITableView
}

// MARK: UICollectionView

extension UICollectionView: ContainerCellCompatible {
    public typealias Cell = UICollectionViewCell
    public typealias DataBinding = UICollectionViewDataSource
    
    public func register(cell type: UICollectionViewCell.Type) {
        register(type, forCellWithReuseIdentifier: type.artisanReuseIdentifier)
    }
    
    public func dequeueReusable(cell type: UICollectionViewCell.Type, at indexPath: IndexPath) -> UICollectionViewCell? {
        dequeueReusableCell(withReuseIdentifier: type.artisanReuseIdentifier, for: indexPath)
    }
}

extension UICollectionViewCell: ContentCellCompatible {
    public typealias Container = UICollectionView
}
#endif
