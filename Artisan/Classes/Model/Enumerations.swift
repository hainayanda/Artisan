//
//  Enumerations.swift
//  Artisan
//
//  Created by Nayanda Haberty (ID) on 27/08/20.
//

import Foundation
#if canImport(UIKit)
import UIKit

public enum AfterPlanningRoutine {
    case autoApply
    case autoMapped
    case none
}

public enum BondingState {
    case mapping
    case applying
    case none
}

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
