//
//  GenericCellViewModel.swift
//  Artisan
//
//  Created by Nayanda Haberty (ID) on 24/09/20.
//

import Foundation
import UIKit

public class EmptyTableCell: TableFragmentCell {
    var preferedHeight: CGFloat = .automatic
    
    public override func calculatedCellHeight(for cellWidth: CGFloat) -> CGFloat {
        return preferedHeight
    }
}

public class EmptyCollectionCell: CollectionFragmentCell {
    var preferedSize: CGSize = .automatic
    
    public override func calculatedCellSize(for collectionContentSize: CGSize) -> CGSize {
        return preferedSize
    }
}

public class GenericTableCellMediator<Cell: UITableViewCell>: TableViewCellMediator<Cell> {
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

public class GenericCollectionCellMediator<Cell: UICollectionViewCell>: CollectionViewCellMediator<Cell> {
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
