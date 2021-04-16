//
//  CellReloadStrategy.swift
//  Artisan
//
//  Created by Nayanda Haberty (ID) on 27/08/20.
//

import Foundation

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
