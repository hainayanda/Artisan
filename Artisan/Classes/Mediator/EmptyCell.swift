//
//  EmptyCell.swift
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
