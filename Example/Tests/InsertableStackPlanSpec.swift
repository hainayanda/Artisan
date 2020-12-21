//
//  InsertableStackPlanSpec.swift
//  Artisan_Tests
//
//  Created by Nayanda Haberty (ID) on 08/09/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import WebKit
import UIKit
import Quick
import Nimble
@testable import Artisan

class InsertableStackPlanSpec: QuickSpec {
    override func spec() {
        describe("ViewLayout stack insertable helper") {
            var view: UIStackView!
            var testableInsertableViewPlan: TestableInsertableViewPlan<UIStackView>!
            beforeEach {
                view = .init()
                testableInsertableViewPlan = .init(view: view)
            }
            it("should fit stacked UIView") {
                var layout = testableInsertableViewPlan.fitStackedView()
                expect(view.arrangedSubviews.last).to(equal(layout.view))
                var assignedView: UIView?
                layout = testableInsertableViewPlan.fitStackedView(assignTo: &assignedView)
                expect(view.arrangedSubviews.last).to(equal(assignedView))
                expect(view.arrangedSubviews.last).to(equal(layout.view))
            }
            it("should fit stacked UIActivityIndicatorView") {
                var layout = testableInsertableViewPlan.fitStackedActivityIndicator()
                expect(view.arrangedSubviews.last).to(equal(layout.view))
                var assignedView: UIActivityIndicatorView?
                layout = testableInsertableViewPlan.fitStackedActivityIndicator(assignTo: &assignedView)
                expect(view.arrangedSubviews.last).to(equal(assignedView))
                expect(view.arrangedSubviews.last).to(equal(layout.view))
            }
            it("should fit stacked UIButton") {
                var layout = testableInsertableViewPlan.fitStackedButton()
                expect(view.arrangedSubviews.last).to(equal(layout.view))
                var assignedView: UIButton?
                layout = testableInsertableViewPlan.fitStackedButton(assignTo: &assignedView)
                expect(view.arrangedSubviews.last).to(equal(assignedView))
                expect(view.arrangedSubviews.last).to(equal(layout.view))
            }
            it("should fit stacked UIDatePicker") {
                var layout = testableInsertableViewPlan.fitStackedDatePicker()
                expect(view.arrangedSubviews.last).to(equal(layout.view))
                var assignedView: UIDatePicker?
                layout = testableInsertableViewPlan.fitStackedDatePicker(assignTo: &assignedView)
                expect(view.arrangedSubviews.last).to(equal(assignedView))
                expect(view.arrangedSubviews.last).to(equal(layout.view))
            }
            it("should fit stacked UIPickerView") {
                var layout = testableInsertableViewPlan.fitStackedPicker()
                expect(view.arrangedSubviews.last).to(equal(layout.view))
                var assignedView: UIPickerView?
                layout = testableInsertableViewPlan.fitStackedPicker(assignTo: &assignedView)
                expect(view.arrangedSubviews.last).to(equal(assignedView))
                expect(view.arrangedSubviews.last).to(equal(layout.view))
            }
            it("should fit stacked UIImageView") {
                var layout = testableInsertableViewPlan.fitStackedImageView()
                expect(view.arrangedSubviews.last).to(equal(layout.view))
                var assignedView: UIImageView?
                layout = testableInsertableViewPlan.fitStackedImageView(assignTo: &assignedView)
                expect(view.arrangedSubviews.last).to(equal(assignedView))
                expect(view.arrangedSubviews.last).to(equal(layout.view))
            }
            it("should fit stacked UIPageControl") {
                var layout = testableInsertableViewPlan.fitStackedPageControl()
                expect(view.arrangedSubviews.last).to(equal(layout.view))
                var assignedView: UIPageControl?
                layout = testableInsertableViewPlan.fitStackedPageControl(assignTo: &assignedView)
                expect(view.arrangedSubviews.last).to(equal(assignedView))
                expect(view.arrangedSubviews.last).to(equal(layout.view))
            }
            it("should fit stacked UIProgressView") {
                var layout = testableInsertableViewPlan.fitStackedProgress()
                expect(view.arrangedSubviews.last).to(equal(layout.view))
                var assignedView: UIProgressView?
                layout = testableInsertableViewPlan.fitStackedProgress(assignTo: &assignedView)
                expect(view.arrangedSubviews.last).to(equal(assignedView))
                expect(view.arrangedSubviews.last).to(equal(layout.view))
            }
            it("should fit stacked UISearchBar") {
                var layout = testableInsertableViewPlan.fitStackedSearchBar()
                expect(view.arrangedSubviews.last).to(equal(layout.view))
                var assignedView: UISearchBar?
                layout = testableInsertableViewPlan.fitStackedSearchBar(assignTo: &assignedView)
                expect(view.arrangedSubviews.last).to(equal(assignedView))
                expect(view.arrangedSubviews.last).to(equal(layout.view))
            }
            it("should fit stacked UISearchTextField") {
                guard #available(iOS 13.0, *) else { return }
                var layout = testableInsertableViewPlan.fitStackedSearchField()
                expect(view.arrangedSubviews.last).to(equal(layout.view))
                var assignedView: UISearchTextField?
                layout = testableInsertableViewPlan.fitStackedSearchField(assignTo: &assignedView)
                expect(view.arrangedSubviews.last).to(equal(assignedView))
                expect(view.arrangedSubviews.last).to(equal(layout.view))
            }
            it("should fit stacked UISegmentedControl") {
                var layout = testableInsertableViewPlan.fitStackedSegmentedControl()
                expect(view.arrangedSubviews.last).to(equal(layout.view))
                var assignedView: UISegmentedControl?
                layout = testableInsertableViewPlan.fitStackedSegmentedControl(assignTo: &assignedView)
                expect(view.arrangedSubviews.last).to(equal(assignedView))
                expect(view.arrangedSubviews.last).to(equal(layout.view))
            }
            it("should fit stacked UISlider") {
                var layout = testableInsertableViewPlan.fitStackedSlider()
                expect(view.arrangedSubviews.last).to(equal(layout.view))
                var assignedView: UISlider?
                layout = testableInsertableViewPlan.fitStackedSlider(assignTo: &assignedView)
                expect(view.arrangedSubviews.last).to(equal(assignedView))
                expect(view.arrangedSubviews.last).to(equal(layout.view))
            }
            it("should fit stacked UIStackView") {
                var layout = testableInsertableViewPlan.fitStackedStack()
                expect(view.arrangedSubviews.last).to(equal(layout.view))
                var assignedView: UIStackView?
                layout = testableInsertableViewPlan.fitStackedStack(assignTo: &assignedView)
                expect(view.arrangedSubviews.last).to(equal(assignedView))
                expect(view.arrangedSubviews.last).to(equal(layout.view))
                
                layout = testableInsertableViewPlan.fitStackedVStack()
                expect(view.arrangedSubviews.last).to(equal(layout.view))
                expect(layout.view.axis).to(equal(.vertical))
                layout = testableInsertableViewPlan.fitStackedVStack(assignTo: &assignedView)
                expect(view.arrangedSubviews.last).to(equal(assignedView))
                expect(view.arrangedSubviews.last).to(equal(layout.view))
                expect(assignedView?.axis).to(equal(.vertical))
                
                layout = testableInsertableViewPlan.fitStackedHStack()
                expect(view.arrangedSubviews.last).to(equal(layout.view))
                expect(layout.view.axis).to(equal(.horizontal))
                layout = testableInsertableViewPlan.fitStackedHStack(assignTo: &assignedView)
                expect(view.arrangedSubviews.last).to(equal(assignedView))
                expect(view.arrangedSubviews.last).to(equal(layout.view))
                expect(assignedView?.axis).to(equal(.horizontal))
            }
            it("should fit stacked UIStepper") {
                var layout = testableInsertableViewPlan.fitStackedStepper()
                expect(view.arrangedSubviews.last).to(equal(layout.view))
                var assignedView: UIStepper?
                layout = testableInsertableViewPlan.fitStackedStepper(assignTo: &assignedView)
                expect(view.arrangedSubviews.last).to(equal(assignedView))
                expect(view.arrangedSubviews.last).to(equal(layout.view))
            }
            it("should fit stacked UISwitch") {
                var layout = testableInsertableViewPlan.fitStackedSwitch()
                expect(view.arrangedSubviews.last).to(equal(layout.view))
                var assignedView: UISwitch?
                layout = testableInsertableViewPlan.fitStackedSwitch(assignTo: &assignedView)
                expect(view.arrangedSubviews.last).to(equal(assignedView))
                expect(view.arrangedSubviews.last).to(equal(layout.view))
            }
            it("should fit stacked UITextField") {
                var layout = testableInsertableViewPlan.fitStackedTextField()
                expect(view.arrangedSubviews.last).to(equal(layout.view))
                var assignedView: UITextField?
                layout = testableInsertableViewPlan.fitStackedTextField(assignTo: &assignedView)
                expect(view.arrangedSubviews.last).to(equal(assignedView))
                expect(view.arrangedSubviews.last).to(equal(layout.view))
            }
            it("should fit stacked UITextView") {
                var layout = testableInsertableViewPlan.fitStackedTextView()
                expect(view.arrangedSubviews.last).to(equal(layout.view))
                var assignedView: UITextView?
                layout = testableInsertableViewPlan.fitStackedTextView(assignTo: &assignedView)
                expect(view.arrangedSubviews.last).to(equal(assignedView))
                expect(view.arrangedSubviews.last).to(equal(layout.view))
            }
            it("should fit stacked UIToolbar") {
                var layout = testableInsertableViewPlan.fitStackedToolbar()
                expect(view.arrangedSubviews.last).to(equal(layout.view))
                var assignedView: UIToolbar?
                layout = testableInsertableViewPlan.fitStackedToolbar(assignTo: &assignedView)
                expect(view.arrangedSubviews.last).to(equal(assignedView))
                expect(view.arrangedSubviews.last).to(equal(layout.view))
            }
            it("should fit stacked WKWebView") {
                var layout = testableInsertableViewPlan.fitStackedWebView()
                expect(view.arrangedSubviews.last).to(equal(layout.view))
                var assignedView: WKWebView?
                layout = testableInsertableViewPlan.fitStackedWebView(assignTo: &assignedView)
                expect(view.arrangedSubviews.last).to(equal(assignedView))
                expect(view.arrangedSubviews.last).to(equal(layout.view))
            }
            it("should fit stacked UIScrollView") {
                var layout = testableInsertableViewPlan.fitStackedScroll()
                expect(view.arrangedSubviews.last).to(equal(layout.view))
                var assignedView: UIScrollView?
                layout = testableInsertableViewPlan.fitStackedScroll(assignTo: &assignedView)
                expect(view.arrangedSubviews.last).to(equal(assignedView))
                expect(view.arrangedSubviews.last).to(equal(layout.view))
            }
            it("should fit stacked UITableView") {
                var layout = testableInsertableViewPlan.fitStackedTable()
                expect(view.arrangedSubviews.last).to(equal(layout.view))
                var assignedView: UITableView?
                layout = testableInsertableViewPlan.fitStackedTable(assignTo: &assignedView)
                expect(view.arrangedSubviews.last).to(equal(assignedView))
                expect(view.arrangedSubviews.last).to(equal(layout.view))
            }
            it("should fit stacked UICollectionView") {
                var layout = testableInsertableViewPlan.fitStackedCollection()
                expect(view.arrangedSubviews.last).to(equal(layout.view))
                var assignedView: UICollectionView?
                layout = testableInsertableViewPlan.fitStackedCollection(assignTo: &assignedView)
                expect(view.arrangedSubviews.last).to(equal(assignedView))
                expect(view.arrangedSubviews.last).to(equal(layout.view))
            }
            it("should fit stacked UILabel") {
                var layout = testableInsertableViewPlan.fitStackedLabel()
                expect(view.arrangedSubviews.last).to(equal(layout.view))
                var assignedView: UILabel?
                layout = testableInsertableViewPlan.fitStackedLabel(assignTo: &assignedView)
                expect(view.arrangedSubviews.last).to(equal(assignedView))
                expect(view.arrangedSubviews.last).to(equal(layout.view))
            }
            it("should fit stacked UIVisualEffectView") {
                var layout = testableInsertableViewPlan.fitStackedVisualEffect()
                expect(view.arrangedSubviews.last).to(equal(layout.view))
                var assignedView: UIVisualEffectView?
                layout = testableInsertableViewPlan.fitStackedVisualEffect(assignTo: &assignedView)
                expect(view.arrangedSubviews.last).to(equal(assignedView))
                expect(view.arrangedSubviews.last).to(equal(layout.view))
            }
            it("should fit stacked UINavigationBar") {
                var layout = testableInsertableViewPlan.fitStackedNavigation()
                expect(view.arrangedSubviews.last).to(equal(layout.view))
                var assignedView: UINavigationBar?
                layout = testableInsertableViewPlan.fitStackedNavigation(assignTo: &assignedView)
                expect(view.arrangedSubviews.last).to(equal(assignedView))
                expect(view.arrangedSubviews.last).to(equal(layout.view))
            }
            it("should fit stacked UITabBar") {
                var layout = testableInsertableViewPlan.fitStackedTabBar()
                expect(view.arrangedSubviews.last).to(equal(layout.view))
                var assignedView: UITabBar?
                layout = testableInsertableViewPlan.fitStackedTabBar(assignTo: &assignedView)
                expect(view.arrangedSubviews.last).to(equal(assignedView))
                expect(view.arrangedSubviews.last).to(equal(layout.view))
            }
        }
    }
}
