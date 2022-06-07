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
    func register(cell type: Cell.Type, identifier: String)
    func dequeueReusable(identifier: String, at indexPath: IndexPath) -> Cell?
    
}

public protocol ContentCellCompatible where Self: UIView {
    associatedtype Container: UIView
    
    static var artisanReuseIdentifier: String { get }
}

// MARK: Extension

fileprivate var cellBuilderKey: String = "cellBuilderKey"
fileprivate var registeredCellIdentifiersAssociatedKey: String = "registeredCellIdentifiersAssociatedKey"

extension ContainerCellCompatible {
    var cellBuilder: AnyCellBuilder? {
        get {
            objc_getAssociatedObject(self, &cellBuilderKey) as? AnyCellBuilder
        }
        set {
            objc_setAssociatedObject(self, &cellBuilderKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        
    }
    
    var registeredCellIdentifiers: [String: Cell.Type] {
        get {
            objc_getAssociatedObject(self, &registeredCellIdentifiersAssociatedKey) as? [String: Cell.Type] ?? [:]
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
    
    public func register(cell type: Cell.Type, identifier: String) {
        register(type, forCellReuseIdentifier: identifier)
        registeredCellIdentifiers[identifier] = type
    }
    
    public func dequeueReusable(identifier: String, at indexPath: IndexPath) -> UITableViewCell? {
        dequeueReusableCell(withIdentifier: identifier, for: indexPath)
    }
}

extension UITableViewCell: ContentCellCompatible {
    public typealias Container = UITableView
}

// MARK: UICollectionView

extension UICollectionView: ContainerCellCompatible {
    public typealias Cell = UICollectionViewCell
    public typealias DataBinding = UICollectionViewDataSource
    
    public func register(cell type: UICollectionViewCell.Type, identifier: String) {
        register(type, forCellWithReuseIdentifier: identifier)
        registeredCellIdentifiers[identifier] = type
    }
    
    public func dequeueReusable(identifier: String, at indexPath: IndexPath) -> UICollectionViewCell? {
        dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
    }
}

extension UICollectionViewCell: ContentCellCompatible {
    public typealias Container = UICollectionView
}
#endif
