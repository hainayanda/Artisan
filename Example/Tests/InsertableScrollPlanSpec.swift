//
//  InsertableScrollPlan.swift
//  Artisan_Tests
//
//  Created by Nayanda Haberty (ID) on 18/09/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import Quick
import Nimble
@testable import Artisan

class InsertableScrollPlanSpec: QuickSpec {
    override func spec() {
        describe("Layout insertable helper") {
            var scroll: UIScrollView!
            var testableInsertableViewPlan: TestableInsertableViewPlan<UIScrollView>!
            beforeEach {
                scroll = .init()
                testableInsertableViewPlan = .init(view: scroll)
            }
            it("should fit Vertical UIView") {
                var content: UIView?
                let layout = testableInsertableViewPlan.fitScrollVContentView(assignTo: &content)
                expect(scroll.subviews.last).to(equal(layout.view))
                expect(layout.view).to(equal(content))
            }
            it("should fit Vertical UIView") {
                let layout = testableInsertableViewPlan.fitScrollVContentView()
                expect(scroll.subviews.last).to(equal(layout.view))
            }
            it("should fit Horizontal UIView") {
                var content: UIView?
                let layout = testableInsertableViewPlan.fitScrollHContentView(assignTo: &content)
                expect(scroll.subviews.last).to(equal(layout.view))
                expect(layout.view).to(equal(content))
            }
            it("should fit Horizontal UIView") {
                let layout = testableInsertableViewPlan.fitScrollHContentView()
                expect(scroll.subviews.last).to(equal(layout.view))
            }
        }
    }
}
