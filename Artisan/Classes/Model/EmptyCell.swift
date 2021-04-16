//
//  EmptyCell.swift
//  Artisan
//
//  Created by Nayanda Haberty on 16/04/21.
//

import Foundation
#if canImport(UIKit)
import Draftsman
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
#endif
