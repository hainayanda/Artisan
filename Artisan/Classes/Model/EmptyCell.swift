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

public final class EmptyTableCell: TableFragmentCell {
    var preferedHeight: CGFloat = .automatic
    
    public override func calculatedCellHeight(for cellWidth: CGFloat) -> CGFloat {
        return preferedHeight
    }
}

public final class EmptyCollectionCell: CollectionFragmentCell { }
#endif
