//
//  ClosureMediator.swift
//  Artisan
//
//  Created by Nayanda Haberty on 16/04/21.
//

import Foundation
#if canImport(UIKit)
import UIKit

public class ClosureMediator<View: NSObject>: ViewMediator<View> {
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

public class TableClosureMediator<Cell: UITableViewCell>: TableCellMediator<Cell> {
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

public class CollectionClosureMediator<Cell: UICollectionViewCell>: CollectionCellMediator<Cell> {
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
#endif
