//
//  Fragment.swift
//  Artisan
//
//  Created by Nayanda Haberty (ID) on 27/08/20.
//

import Foundation
import UIKit

public protocol Fragment {
    func fragmentWillLayout()
    func planContent(_ plan: InsertablePlan)
    func fragmentDidLayout()
}

public extension Fragment {
    func fragmentWillLayout() { }
    func fragmentDidLayout() { }
}

public extension Fragment where Self: UIView {
    
    func planFragment(delegate: PlanDelegate? = nil) {
        let viewLayout = PlanLayout<Self>(view: self, context: .init(delegate: delegate, currentView: self))
        fragmentWillLayout()
        viewLayout.planContent(self.planContent(_:))
        fragmentDidLayout()
        NSLayoutConstraint.activate(viewLayout.plannedConstraints)
    }
    
    func replanContent(delegate: PlanDelegate? = nil) {
        removeAllPlannedConstraints()
        planFragment(delegate: delegate)
    }
}
