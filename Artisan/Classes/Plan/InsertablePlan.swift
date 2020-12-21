//
//  InsertablePlan.swift
//  Artisan
//
//  Created by Nayanda Haberty (ID) on 27/08/20.
//

import Foundation
import UIKit

public protocol InsertablePlan: class {
    var fittedPlans: [Planer] { get set }
    var context: PlanContext { get }
    @discardableResult
    func fit<V: UIView>(_ view: V) -> PlanLayout<V>
    @discardableResult
    func fit(_ viewController: UIViewController) -> PlanLayout<UIView>
}

public protocol InsertableViewPlan: InsertablePlan {
    associatedtype View: UIView
    var view: View { get }
}

public extension InsertableViewPlan where View: UIStackView {
    @discardableResult
    func fitStacked<V>(_ view: V) -> PlanLayout<V> where V : UIView {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addArrangedSubview(view)
        let plan = PlanLayout(view: view, context: context)
        fittedPlans.append(plan)
        if let molecule = view as? Fragment {
            plan.planContent(molecule.planContent(_:))
        }
        return plan
    }
    
    @discardableResult
    func fitStacked(_ viewController: UIViewController) -> PlanLayout<UIView> {
        if let parentController: UIViewController = view.parentViewController
            ?? context.delegate.planer(neededViewControllerFor: viewController) {
            parentController.addChild(viewController)
        } else {
            context.delegate.planer(
                view,
                errorWhenPlanning: .init(
                    errorDescription: "Artisan Error: ",
                    failureReason: "Try to put UIViewController when view is not in UIViewController"
                )
            )
        }
        return fitStacked(viewController.view)
    }
}

public extension InsertableViewPlan {
    @discardableResult
    func fit<V: UIView>(_ view: V) -> PlanLayout<V> {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(view)
        let plan = PlanLayout(view: view, context: context)
        fittedPlans.append(plan)
        if let molecule = view as? Fragment {
            plan.planContent(molecule.planContent(_:))
        }
        return plan
    }
    
    @discardableResult
    func fit(_ viewController: UIViewController) -> PlanLayout<UIView> {
        if let parentController: UIViewController = view.parentViewController
            ?? context.delegate.planer(neededViewControllerFor: viewController) {
            parentController.addChild(viewController)
        } else {
            context.delegate.planer(
                view,
                errorWhenPlanning: .whenFitting(
                    UIViewController.self,
                    into: Self.self,
                    failureReason: "Try to put UIViewController when view is not in UIViewController"
                )
            )
        }
        return fit(viewController.view)
    }
}

public class LayoutPlan<View: UIView>: InsertableViewPlan {
    public var view: View
    public var fittedPlans: [Planer] = []
    public var context: PlanContext
    
    init(view: View, context: PlanContext) {
        self.view = view
        self.context = context
    }
}
