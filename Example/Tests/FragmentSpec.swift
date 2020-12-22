//
//  FragmentSpec.swift
//  Artisan_Tests
//
//  Created by Nayanda Haberty (ID) on 08/09/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import Quick
import Nimble
@testable import Artisan

class FragmentSpec: QuickSpec {
    override func spec() {
        describe("fragment view behaviour") {
            var fragment: SpiedViewFragment!
            beforeEach {
                fragment = .init()
            }
            it("should run all lifecycle") {
                var didPlan: Bool = false
                var willPlan: Bool = false
                var planed: Bool = false
                fragment.didPlan = {
                    expect(planed).to(beTrue())
                    expect(willPlan).to(beTrue())
                    didPlan = true
                }
                fragment.willPlan = {
                    expect(planed).to(beFalse())
                    expect(didPlan).to(beFalse())
                    willPlan = true
                }
                fragment.didPlanContent = { _ in
                    expect(willPlan).to(beTrue())
                    expect(didPlan).to(beFalse())
                    planed = true
                }
                fragment.replanContent()
                expect(willPlan).to(beTrue())
                expect(didPlan).to(beTrue())
                expect(planed).to(beTrue())
                didPlan = false
                willPlan = false
                planed = false
                fragment.planFragment()
                expect(willPlan).to(beTrue())
                expect(didPlan).to(beTrue())
                expect(planed).to(beTrue())
            }
        }
    }
}

class SpiedViewFragment: UIView, Fragment {
    var willPlan: (() -> Void)?
    func fragmentWillPlanContent() {
        willPlan?()
    }
    var didPlanContent: ((InsertablePlan) -> Void)?
    func planContent(_ plan: InsertablePlan) {
        didPlanContent?(plan)
    }
    var didPlan: (() -> Void)?
    func fragmentDidPlanContent() {
        didPlan?()
    }
}
