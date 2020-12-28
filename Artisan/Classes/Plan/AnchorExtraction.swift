//
//  AnchorExtraction.swift
//  Artisan
//
//  Created by Nayanda Haberty on 24/12/20.
//

import Foundation
import UIKit

extension UILayoutGuide {
    func anchor(of dimension: LayoutDimension) -> NSLayoutDimension{
        switch dimension {
        case .width:
            return widthAnchor
        default:
            return heightAnchor
        }
    }
}

extension UIView {
    func anchor(of dimension: LayoutDimension) -> NSLayoutDimension{
        switch dimension {
        case .width:
            return widthAnchor
        default:
            return heightAnchor
        }
    }
}
