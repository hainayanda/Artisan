//
//  PlanContext.swift
//  Artisan
//
//  Created by Nayanda Haberty (ID) on 27/08/20.
//

import Foundation
import UIKit

public class PlanContext {
    weak var _delegate: PlanDelegate?
    var delegate: PlanDelegate {
        _delegate ?? DefaultPlanDelegate.shared
    }
    var currentPriority: UILayoutPriority = 999
    var mutatingPriority: UILayoutPriority {
        let newPriority: UILayoutPriority = .init(rawValue: currentPriority.rawValue - 1)
        currentPriority = newPriority
        return newPriority
    }
    var currentView: UIView {
        didSet {
            guard currentView != oldValue else { return }
            previousView = oldValue
        }
    }
    var previousView: UIView?
    
    init(delegate: PlanDelegate? = nil, currentView: UIView) {
        self._delegate = delegate
        self.currentView = currentView
    }
}
