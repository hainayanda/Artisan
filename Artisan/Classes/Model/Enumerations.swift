//
//  Enumerations.swift
//  Artisan
//
//  Created by Nayanda Haberty (ID) on 27/08/20.
//

import Foundation

public enum LayoutDimension {
    case height
    case width
}

public enum LayoutRelation<Related> {
    case moreThanTo(Related)
    case lessThanTo(Related)
    case equalTo(Related)
    case moreThan
    case lessThan
    case equal
}

public enum InterRelation<Related> {
    case moreThanTo(Related)
    case lessThanTo(Related)
    case equalTo(Related)
    
    public var related: Related {
        switch self {
        case .moreThanTo(let related), .lessThanTo(let related), .equalTo(let related):
            return related
        }
    }
}

public enum MiddlePosition {
    case horizontally(LayoutRelation<InsetsConvertible>)
    case vertically(LayoutRelation<InsetsConvertible>)
}

public enum AnonymousRelation {
    case parent
    case safeArea
    case myself
    case mySafeArea
    case previous
    case previousSafeArea
    
    public var isView: Bool {
        return !isSafeArea
    }
    
    public var isSafeArea: Bool {
        switch self {
        case .mySafeArea, .safeArea, .previousSafeArea:
            return true
        default:
            return false
        }
    }
}

public enum PlanningOption {
    case append
    case renew
    case startFresh
    case startClean
    
    public var shouldRemoveOldPlannedConstraints: Bool {
        switch self {
        case .startFresh, .startClean:
            return true
        default:
            return false
        }
    }
    
    public var shouldCleanAllConstraints: Bool {
        switch self {
        case .startClean:
            return true
        default:
            return false
        }
    }
}

public enum CellLayoutingPhase: CaseIterable {
    case firstLoad
    case setNeedsLayout
    case reused
    case none
}

public enum CellPlanningBehavior {
    case planOnce
    case planOn(CellLayoutingPhase)
    case planOnEach([CellLayoutingPhase])
    case planIfPossible
    
    var whitelistedPhases: [CellLayoutingPhase] {
        switch self {
        case .planOnce:
            return [.firstLoad]
        case .planOn(let phase):
            return [phase]
        case .planOnEach(let phases):
            return phases
        default:
            return CellLayoutingPhase.allCases
        }
    }
}

public enum LayoutEdge {
    case top
    case bottom
    case left
    case right
}

public enum RelatedPosition {
    case topOf(UIView)
    case bottomOf(UIView)
    case leftOf(UIView)
    case rightOf(UIView)
    case topOfAndParallelWith(UIView)
    case bottomOfAndParallelWith(UIView)
    case leftOfAndParallelWith(UIView)
    case rightOfAndParallelWith(UIView)
}

public enum BondingState {
    case mapping
    case applying
    case none
}

public enum LayoutStackedStrategy {
    case emptying
    case append
    case replaceDifferences
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
