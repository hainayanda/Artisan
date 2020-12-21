//
//  InsertableViewPlanSpec.swift
//  Artisan_Tests
//
//  Created by Nayanda Haberty (ID) on 07/09/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import WebKit
import UIKit
import Quick
import Nimble
@testable import Artisan

class InsertableViewPlanSpec: QuickSpec {
    override func spec() {
        describe("Insertable view plan helper") {
            var view: UIView!
            var testableInsertableViewPlan: TestableInsertableViewPlan<UIView>!
            beforeEach {
                view = .init()
                testableInsertableViewPlan = .init(view: view)
            }
            it("should fit UIView") {
                var layout = testableInsertableViewPlan.fitView()
                expect(view.subviews.last).to(equal(layout.view))
                var assignedView: UIView?
                layout = testableInsertableViewPlan.fitView(assignTo: &assignedView)
                expect(view.subviews.last).to(equal(assignedView))
                expect(view.subviews.last).to(equal(layout.view))
            }
            it("should fit UIActivityIndicatorView") {
                var layout = testableInsertableViewPlan.fitActivityIndicator()
                expect(view.subviews.last).to(equal(layout.view))
                var assignedView: UIActivityIndicatorView?
                layout = testableInsertableViewPlan.fitActivityIndicator(assignTo: &assignedView)
                expect(view.subviews.last).to(equal(assignedView))
                expect(view.subviews.last).to(equal(layout.view))
            }
            it("should fit UIButton") {
                var layout = testableInsertableViewPlan.fitButton()
                expect(view.subviews.last).to(equal(layout.view))
                var assignedView: UIButton?
                layout = testableInsertableViewPlan.fitButton(assignTo: &assignedView)
                expect(view.subviews.last).to(equal(assignedView))
                expect(view.subviews.last).to(equal(layout.view))
            }
            it("should fit UIDatePicker") {
                var layout = testableInsertableViewPlan.fitDatePicker()
                expect(view.subviews.last).to(equal(layout.view))
                var assignedView: UIDatePicker?
                layout = testableInsertableViewPlan.fitDatePicker(assignTo: &assignedView)
                expect(view.subviews.last).to(equal(assignedView))
                expect(view.subviews.last).to(equal(layout.view))
            }
            it("should fit UIPickerView") {
                var layout = testableInsertableViewPlan.fitPicker()
                expect(view.subviews.last).to(equal(layout.view))
                var assignedView: UIPickerView?
                layout = testableInsertableViewPlan.fitPicker(assignTo: &assignedView)
                expect(view.subviews.last).to(equal(assignedView))
                expect(view.subviews.last).to(equal(layout.view))
            }
            it("should fit UIImageView") {
                var layout = testableInsertableViewPlan.fitImageView()
                expect(view.subviews.last).to(equal(layout.view))
                var assignedView: UIImageView?
                layout = testableInsertableViewPlan.fitImageView(assignTo: &assignedView)
                expect(view.subviews.last).to(equal(assignedView))
                expect(view.subviews.last).to(equal(layout.view))
            }
            it("should fit UIPageControl") {
                var layout = testableInsertableViewPlan.fitPageControl()
                expect(view.subviews.last).to(equal(layout.view))
                var assignedView: UIPageControl?
                layout = testableInsertableViewPlan.fitPageControl(assignTo: &assignedView)
                expect(view.subviews.last).to(equal(assignedView))
                expect(view.subviews.last).to(equal(layout.view))
            }
            it("should fit UIProgressView") {
                var layout = testableInsertableViewPlan.fitProgress()
                expect(view.subviews.last).to(equal(layout.view))
                var assignedView: UIProgressView?
                layout = testableInsertableViewPlan.fitProgress(assignTo: &assignedView)
                expect(view.subviews.last).to(equal(assignedView))
                expect(view.subviews.last).to(equal(layout.view))
            }
            it("should fit UISearchBar") {
                var layout = testableInsertableViewPlan.fitSearchBar()
                expect(view.subviews.last).to(equal(layout.view))
                var assignedView: UISearchBar?
                layout = testableInsertableViewPlan.fitSearchBar(assignTo: &assignedView)
                expect(view.subviews.last).to(equal(assignedView))
                expect(view.subviews.last).to(equal(layout.view))
            }
            it("should fit UISearchTextField") {
                guard #available(iOS 13.0, *) else { return }
                var layout = testableInsertableViewPlan.fitSearchField()
                expect(view.subviews.last).to(equal(layout.view))
                var assignedView: UISearchTextField?
                layout = testableInsertableViewPlan.fitSearchField(assignTo: &assignedView)
                expect(view.subviews.last).to(equal(assignedView))
                expect(view.subviews.last).to(equal(layout.view))
            }
            it("should fit UISegmentedControl") {
                var layout = testableInsertableViewPlan.fitSegmentedControl()
                expect(view.subviews.last).to(equal(layout.view))
                var assignedView: UISegmentedControl?
                layout = testableInsertableViewPlan.fitSegmentedControl(assignTo: &assignedView)
                expect(view.subviews.last).to(equal(assignedView))
                expect(view.subviews.last).to(equal(layout.view))
            }
            it("should fit UISlider") {
                var layout = testableInsertableViewPlan.fitSlider()
                expect(view.subviews.last).to(equal(layout.view))
                var assignedView: UISlider?
                layout = testableInsertableViewPlan.fitSlider(assignTo: &assignedView)
                expect(view.subviews.last).to(equal(assignedView))
                expect(view.subviews.last).to(equal(layout.view))
            }
            it("should fit UIStackView") {
                var layout = testableInsertableViewPlan.fitStack()
                expect(view.subviews.last).to(equal(layout.view))
                var assignedView: UIStackView?
                layout = testableInsertableViewPlan.fitStack(assignTo: &assignedView)
                expect(view.subviews.last).to(equal(assignedView))
                expect(view.subviews.last).to(equal(layout.view))
                
                layout = testableInsertableViewPlan.fitVStack()
                expect(view.subviews.last).to(equal(layout.view))
                expect(layout.view.axis).to(equal(.vertical))
                layout = testableInsertableViewPlan.fitVStack(assignTo: &assignedView)
                expect(view.subviews.last).to(equal(assignedView))
                expect(view.subviews.last).to(equal(layout.view))
                expect(assignedView?.axis).to(equal(.vertical))
                
                layout = testableInsertableViewPlan.fitHStack()
                expect(view.subviews.last).to(equal(layout.view))
                expect(layout.view.axis).to(equal(.horizontal))
                layout = testableInsertableViewPlan.fitHStack(assignTo: &assignedView)
                expect(view.subviews.last).to(equal(assignedView))
                expect(view.subviews.last).to(equal(layout.view))
                expect(assignedView?.axis).to(equal(.horizontal))
            }
            it("should fit UIStepper") {
                var layout = testableInsertableViewPlan.fitStepper()
                expect(view.subviews.last).to(equal(layout.view))
                var assignedView: UIStepper?
                layout = testableInsertableViewPlan.fitStepper(assignTo: &assignedView)
                expect(view.subviews.last).to(equal(assignedView))
                expect(view.subviews.last).to(equal(layout.view))
            }
            it("should fit UISwitch") {
                var layout = testableInsertableViewPlan.fitSwitch()
                expect(view.subviews.last).to(equal(layout.view))
                var assignedView: UISwitch?
                layout = testableInsertableViewPlan.fitSwitch(assignTo: &assignedView)
                expect(view.subviews.last).to(equal(assignedView))
                expect(view.subviews.last).to(equal(layout.view))
            }
            it("should fit UITextField") {
                var layout = testableInsertableViewPlan.fitTextField()
                expect(view.subviews.last).to(equal(layout.view))
                var assignedView: UITextField?
                layout = testableInsertableViewPlan.fitTextField(assignTo: &assignedView)
                expect(view.subviews.last).to(equal(assignedView))
                expect(view.subviews.last).to(equal(layout.view))
            }
            it("should fit UITextView") {
                var layout = testableInsertableViewPlan.fitTextView()
                expect(view.subviews.last).to(equal(layout.view))
                var assignedView: UITextView?
                layout = testableInsertableViewPlan.fitTextView(assignTo: &assignedView)
                expect(view.subviews.last).to(equal(assignedView))
                expect(view.subviews.last).to(equal(layout.view))
            }
            it("should fit UIToolbar") {
                var layout = testableInsertableViewPlan.fitToolbar()
                expect(view.subviews.last).to(equal(layout.view))
                var assignedView: UIToolbar?
                layout = testableInsertableViewPlan.fitToolbar(assignTo: &assignedView)
                expect(view.subviews.last).to(equal(assignedView))
                expect(view.subviews.last).to(equal(layout.view))
            }
            it("should fit WKWebView") {
                var layout = testableInsertableViewPlan.fitWebView()
                expect(view.subviews.last).to(equal(layout.view))
                var assignedView: WKWebView?
                layout = testableInsertableViewPlan.fitWebView(assignTo: &assignedView)
                expect(view.subviews.last).to(equal(assignedView))
                expect(view.subviews.last).to(equal(layout.view))
            }
            it("should fit UIScrollView") {
                var layout = testableInsertableViewPlan.fitScroll()
                expect(view.subviews.last).to(equal(layout.view))
                var assignedView: UIScrollView?
                layout = testableInsertableViewPlan.fitScroll(assignTo: &assignedView)
                expect(view.subviews.last).to(equal(assignedView))
                expect(view.subviews.last).to(equal(layout.view))
            }
            it("should fit UITableView") {
                var layout = testableInsertableViewPlan.fitTable()
                expect(view.subviews.last).to(equal(layout.view))
                var assignedView: UITableView?
                layout = testableInsertableViewPlan.fitTable(assignTo: &assignedView)
                expect(view.subviews.last).to(equal(assignedView))
                expect(view.subviews.last).to(equal(layout.view))
            }
            it("should fit UICollectionView") {
                var layout = testableInsertableViewPlan.fitCollection()
                expect(view.subviews.last).to(equal(layout.view))
                var assignedView: UICollectionView?
                layout = testableInsertableViewPlan.fitCollection(assignTo: &assignedView)
                expect(view.subviews.last).to(equal(assignedView))
                expect(view.subviews.last).to(equal(layout.view))
            }
            it("should fit UILabel") {
                var layout = testableInsertableViewPlan.fitLabel()
                expect(view.subviews.last).to(equal(layout.view))
                var assignedView: UILabel?
                layout = testableInsertableViewPlan.fitLabel(assignTo: &assignedView)
                expect(view.subviews.last).to(equal(assignedView))
                expect(view.subviews.last).to(equal(layout.view))
            }
            it("should fit UIVisualEffectView") {
                var layout = testableInsertableViewPlan.fitVisualEffect()
                expect(view.subviews.last).to(equal(layout.view))
                var assignedView: UIVisualEffectView?
                layout = testableInsertableViewPlan.fitVisualEffect(assignTo: &assignedView)
                expect(view.subviews.last).to(equal(assignedView))
                expect(view.subviews.last).to(equal(layout.view))
            }
            it("should fit UINavigationBar") {
                var layout = testableInsertableViewPlan.fitNavigation()
                expect(view.subviews.last).to(equal(layout.view))
                var assignedView: UINavigationBar?
                layout = testableInsertableViewPlan.fitNavigation(assignTo: &assignedView)
                expect(view.subviews.last).to(equal(assignedView))
                expect(view.subviews.last).to(equal(layout.view))
            }
            it("should fit UITabBar") {
                var layout = testableInsertableViewPlan.fitTabBar()
                expect(view.subviews.last).to(equal(layout.view))
                var assignedView: UITabBar?
                layout = testableInsertableViewPlan.fitTabBar(assignTo: &assignedView)
                expect(view.subviews.last).to(equal(assignedView))
                expect(view.subviews.last).to(equal(layout.view))
            }
        }
    }
}

class TestableInsertableViewPlan<View: UIView>: InsertableViewPlan {
    var fittedPlans: [Planer] = []
    lazy var context: PlanContext = .init(currentView: view)
    var view: View
    
    init(view: View) {
        self.view = view
    }
}
