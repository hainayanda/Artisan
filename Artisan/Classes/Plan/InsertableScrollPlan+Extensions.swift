//
//  InsertableScrollPlan+Extensions.swift
//  Artisan
//
//  Created by Nayanda Haberty (ID) on 18/09/20.
//

import Foundation
import UIKit

public extension InsertableViewPlan where View: UIScrollView {
    @discardableResult
    func fitScrollVContentView() -> PlanLayout<UIView> {
        fitView()
            .edges(.equal, to: .parent)
            .height(.equalTo(.parent), priority: .defaultLow)
            .width(.equalTo(view.widthAnchor))
    }
    @discardableResult
    func fitScrollHContentView() -> PlanLayout<UIView> {
        fitView()
            .edges(.equal, to: .parent)
            .width(.equalTo(.parent), priority: .defaultLow)
            .height(.equalTo(view.heightAnchor))
    }
    @discardableResult
    func fitScrollVContentView(assignTo view: inout UIView?) -> PlanLayout<UIView> {
        fitView(assignTo: &view)
            .edges(.equal, to: .parent)
            .height(.equalTo(.parent), priority: .defaultLow)
            .width(.equalTo(self.view.widthAnchor))
    }
    @discardableResult
    func fitScrollHContentView(assignTo view: inout UIView?) -> PlanLayout<UIView> {
        fitView(assignTo: &view)
            .edges(.equal, to: .parent)
            .width(.equalTo(.parent), priority: .defaultLow)
            .height(.equalTo(self.view.heightAnchor))
    }
    
    func fitAsScrollVContent<View: UIView>(_ view: View) -> PlanLayout<View> {
        fit(view)
            .edges(.equal, to: .parent)
            .height(.equalTo(.parent), priority: .defaultLow)
            .width(.equalTo(self.view.widthAnchor))
    }
    
    func fitAsScrollHContent<View: UIView>(_ view: View) -> PlanLayout<View> {
        fit(view)
            .edges(.equal, to: .parent)
            .width(.equalTo(.parent), priority: .defaultLow)
            .height(.equalTo(self.view.heightAnchor))
    }
}
