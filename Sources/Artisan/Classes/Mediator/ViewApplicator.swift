//
//  GenericMediator.swift
//  Artisan
//
//  Created by Nayanda Haberty on 29/01/21.
//

import Foundation

public class ViewApplicator<View: UIView>: ViewMediator<View> {
    var applicator: (View) -> Void
    
    public init(_ applicator: @escaping (View) -> Void) {
        self.applicator = applicator
    }
    
    required init() {
        self.applicator = { _ in }
    }
    
    open override func willApplying(_ view: View) {
        super.willApplying(view)
        applicator(view)
    }
}

public class TableCellApplicator<Cell: UITableViewCell>: TableCellMediator<Cell> {
    var applicator: (Cell) -> Void
    
    public init(_ applicator: @escaping (Cell) -> Void) {
        self.applicator = applicator
    }
    
    required init() {
        self.applicator = { _ in }
    }
    
    open override func willApplying(_ view: Cell) {
        super.willApplying(view)
        applicator(view)
    }
}

public class CollectionCellApplicator<Cell: UICollectionViewCell>: CollectionCellMediator<Cell> {
    var applicator: (Cell) -> Void
    
    public init(_ applicator: @escaping (Cell) -> Void) {
        self.applicator = applicator
    }
    
    required init() {
        self.applicator = { _ in }
    }
    
    open override func willApplying(_ view: Cell) {
        super.willApplying(view)
        applicator(view)
    }
}
