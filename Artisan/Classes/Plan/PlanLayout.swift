//
//  ViewLayout.swift
//  Artisan
//
//  Created by Nayanda Haberty (ID) on 27/08/20.
//

import Foundation

@dynamicMemberLookup
public class PlanLayout<View: UIView>: Planable {
    public typealias PropertyPlaner<Property> = ((Property) -> PlanLayout<View>)
    
    public var plannedConstraints: [NSLayoutConstraint] = []
    public var view: View
    public var context: PlanContext
    
    init(view: View, context: PlanContext) {
        self.view = view
        self.context = context
        self.context.currentView = view
    }
    
    @discardableResult
    public func planContent(_ containerBuilder: (LayoutPlan<View>) -> Void) -> Self {
        defer {
            context.currentView = view
        }
        let container = LayoutPlan(view: self.view, context: context)
        containerBuilder(container)
        for layoutable in container.fittedPlans {
            plannedConstraints.append(contentsOf: layoutable.plannedConstraints)
        }
        return self
    }
    
    public subscript<Property>(dynamicMember keyPath: WritableKeyPath<View, Property>) -> PropertyPlaner<Property> {
        // retained on purpose
        return { value in
            self.view[keyPath: keyPath] = value
            return self
        }
    }
}
