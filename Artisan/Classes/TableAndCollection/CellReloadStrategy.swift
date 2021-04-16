//
//  CellReloadStrategy.swift
//  Artisan
//
//  Created by Nayanda Haberty on 16/04/21.
//

import Foundation
#if canImport(UIKit)

public enum CellReloadStrategy {
    case reloadAll
    case reloadArrangementDifference
    case reloadArrangementDifferenceAndRefresh
    
    var shouldRefresh: Bool {
        switch self {
        case .reloadArrangementDifferenceAndRefresh:
            return true
        default:
            return false
        }
    }
    
    var shouldReloadAll: Bool {
        switch self {
        case .reloadAll:
            return true
        default:
            return false
        }
    }
}
#endif
