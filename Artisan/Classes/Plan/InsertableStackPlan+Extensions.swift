//
//  InsertableStackPlan+Extensions.swift
//  Artisan
//
//  Created by Nayanda Haberty (ID) on 08/09/20.
//

import Foundation
import UIKit
import WebKit

extension InsertableViewPlan where View: UIStackView {
    func fitStackedAndCreateView<View: UIView>(thenAssignTo view: inout View?) -> PlanLayout<View> {
        let viewToFitStacked = view ?? .init()
        defer {
            view = viewToFitStacked
        }
        return fitStacked(viewToFitStacked)
    }
    
    //MARK: UIView
    @discardableResult
    public func fitStackedView(assignTo view: inout UIView?) -> PlanLayout<UIView> {
        fitStackedAndCreateView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func fitStackedView() -> PlanLayout<UIView> {
        fitStacked(UIView())
    }
    
    @available(iOS 11.0, *)
    public func fitSpace(by space: CGFloat) -> Bool {
        guard let viewBefore = view.arrangedSubviews.last else {
            return false
        }
        view.setCustomSpacing(space, after: viewBefore)
        return true
    }
    
    public func fitVSpace(by space: CGFloat) {
        fitStacked(UIView())
            .backgroundColor(.clear)
            .height(.equalTo(space), priority: .required)
    }
    
    public func fitHSpace(by space: CGFloat) {
        fitStacked(UIView())
            .backgroundColor(.clear)
            .width(.equalTo(space), priority: .required)
    }
    
    //MARK: UIActivityIndicatorView
    
    @discardableResult
    public func fitStackedActivityIndicator(assignTo view: inout UIActivityIndicatorView?) -> PlanLayout<UIActivityIndicatorView> {
        fitStackedAndCreateView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func fitStackedActivityIndicator() -> PlanLayout<UIActivityIndicatorView> {
        fitStacked(.init())
    }
    
    //MARK: UIButton
    
    @discardableResult
    public func fitStackedButton(assignTo view: inout UIButton?) -> PlanLayout<UIButton> {
        fitStackedAndCreateView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func fitStackedButton() -> PlanLayout<UIButton> {
        fitStacked(.init())
    }
    
    //MARK: UIDatePicker
    
    @discardableResult
    public func fitStackedDatePicker(assignTo view: inout UIDatePicker?) -> PlanLayout<UIDatePicker> {
        fitStackedAndCreateView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func fitStackedDatePicker() -> PlanLayout<UIDatePicker> {
        fitStacked(.init())
    }
    
    //MARK: UIPickerView
    
    @discardableResult
    public func fitStackedPicker(assignTo view: inout UIPickerView?) -> PlanLayout<UIPickerView> {
        fitStackedAndCreateView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func fitStackedPicker() -> PlanLayout<UIPickerView> {
        fitStacked(.init())
    }
    
    //MARK: UIImageView
    
    @discardableResult
    public func fitStackedImageView(assignTo view: inout UIImageView?) -> PlanLayout<UIImageView> {
        fitStackedAndCreateView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func fitStackedImageView() -> PlanLayout<UIImageView> {
        fitStacked(.init())
    }
    
    //MARK: UIPageControl
    
    @discardableResult
    public func fitStackedPageControl(assignTo view: inout UIPageControl?) -> PlanLayout<UIPageControl> {
        fitStackedAndCreateView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func fitStackedPageControl() -> PlanLayout<UIPageControl> {
        fitStacked(.init())
    }
    
    //MARK: UIProgressView
    
    @discardableResult
    public func fitStackedProgress(assignTo view: inout UIProgressView?) -> PlanLayout<UIProgressView> {
        fitStackedAndCreateView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func fitStackedProgress() -> PlanLayout<UIProgressView> {
        fitStacked(.init())
    }
    
    //MARK: UISearchBar
    
    @discardableResult
    public func fitStackedSearchBar(assignTo view: inout UISearchBar?) -> PlanLayout<UISearchBar> {
        fitStackedAndCreateView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func fitStackedSearchBar() -> PlanLayout<UISearchBar> {
        fitStacked(.init())
    }
    
    @available(iOS 13.0, *)
    @discardableResult
    public func fitStackedSearchField(assignTo view: inout UISearchTextField?) -> PlanLayout<UISearchTextField> {
        fitStackedAndCreateView(thenAssignTo: &view)
    }
    
    @available(iOS 13.0, *)
    @discardableResult
    public func fitStackedSearchField() -> PlanLayout<UISearchTextField> {
        fitStacked(.init())
    }
    
    //MARK: UISegmentedControl
    
    @discardableResult
    public func fitStackedSegmentedControl(assignTo view: inout UISegmentedControl?) -> PlanLayout<UISegmentedControl> {
        fitStackedAndCreateView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func fitStackedSegmentedControl() -> PlanLayout<UISegmentedControl> {
        fitStacked(.init())
    }
    
    //MARK: UISlider
    
    @discardableResult
    public func fitStackedSlider(assignTo view: inout UISlider?) -> PlanLayout<UISlider> {
        fitStackedAndCreateView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func fitStackedSlider() -> PlanLayout<UISlider> {
        fitStacked(.init())
    }
    
    //MARK: UIStackView
    
    @discardableResult
    public func fitStackedStack(assignTo view: inout UIStackView?) -> PlanLayout<UIStackView> {
        fitStackedAndCreateView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func fitStackedStack() -> PlanLayout<UIStackView> {
        fitStacked(.init())
    }
    
    @discardableResult
    public func fitStackedVStack(assignTo view: inout UIStackView?) -> PlanLayout<UIStackView> {
        let layout = fitStackedAndCreateView(thenAssignTo: &view)
        view?.axis = .vertical
        return layout
    }
    
    @discardableResult
    public func fitStackedVStack() -> PlanLayout<UIStackView> {
        let stack: UIStackView = .init()
        stack.axis = .vertical
        return fitStacked(stack)
    }
    
    @discardableResult
    public func fitStackedHStack(assignTo view: inout UIStackView?) -> PlanLayout<UIStackView> {
        let layout = fitStackedAndCreateView(thenAssignTo: &view)
        view?.axis = .horizontal
        return layout
    }
    
    @discardableResult
    public func fitStackedHStack() -> PlanLayout<UIStackView> {
        let stack: UIStackView = .init()
        stack.axis = .horizontal
        return fitStacked(stack)
    }
    
    //MARK: UIStepper
    
    @discardableResult
    public func fitStackedStepper(assignTo view: inout UIStepper?) -> PlanLayout<UIStepper> {
        fitStackedAndCreateView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func fitStackedStepper() -> PlanLayout<UIStepper> {
        fitStacked(.init())
    }
    
    //MARK: UISwitch
    
    @discardableResult
    public func fitStackedSwitch(assignTo view: inout UISwitch?) -> PlanLayout<UISwitch> {
        fitStackedAndCreateView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func fitStackedSwitch() -> PlanLayout<UISwitch> {
        fitStacked(.init())
    }
    
    //MARK: UITextField
    
    @discardableResult
    public func fitStackedTextField(assignTo view: inout UITextField?) -> PlanLayout<UITextField> {
        fitStackedAndCreateView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func fitStackedTextField() -> PlanLayout<UITextField> {
        fitStacked(.init())
    }
    
    //MARK: UITextView
    
    @discardableResult
    public func fitStackedTextView(assignTo view: inout UITextView?) -> PlanLayout<UITextView> {
        fitStackedAndCreateView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func fitStackedTextView() -> PlanLayout<UITextView> {
        fitStacked(.init())
    }
    
    //MARK: UIToolbar
    
    @discardableResult
    public func fitStackedToolbar(assignTo view: inout UIToolbar?) -> PlanLayout<UIToolbar> {
        fitStackedAndCreateView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func fitStackedToolbar() -> PlanLayout<UIToolbar> {
        fitStacked(.init())
    }
    
    //MARK: WKWebView
    
    @discardableResult
    public func fitStackedWebView(assignTo view: inout WKWebView?) -> PlanLayout<WKWebView> {
        fitStackedAndCreateView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func fitStackedWebView() -> PlanLayout<WKWebView> {
        fitStacked(.init())
    }
    
    //MARK: UIScrollView
    
    @discardableResult
    public func fitStackedScroll(assignTo view: inout UIScrollView?) -> PlanLayout<UIScrollView> {
        fitStackedAndCreateView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func fitStackedScroll() -> PlanLayout<UIScrollView> {
        fitStacked(.init())
    }
    
    //MARK: UITableView
    
    @discardableResult
    public func fitStackedTable(assignTo view: inout UITableView?) -> PlanLayout<UITableView> {
        fitStackedAndCreateView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func fitStackedTable() -> PlanLayout<UITableView> {
        fitStacked(.init())
    }
    
    //MARK: UICollectionView
    
    @discardableResult
    public func fitStackedCollection(assignTo view: inout UICollectionView?) -> PlanLayout<UICollectionView> {
        let collectionTofitStacked = view ?? .init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        defer {
            view = collectionTofitStacked
        }
        return fitStacked(collectionTofitStacked)
    }
    
    @discardableResult
    public func fitStackedCollection() -> PlanLayout<UICollectionView> {
        fitStacked(.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()))
    }
    
    //MARK: UILabel
    
    @discardableResult
    public func fitStackedLabel(assignTo view: inout UILabel?) -> PlanLayout<UILabel> {
        fitStackedAndCreateView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func fitStackedLabel() -> PlanLayout<UILabel> {
        fitStacked(.init())
    }
    
    //MARK: UIVisualEffectView
    
    @discardableResult
    public func fitStackedVisualEffect(assignTo view: inout UIVisualEffectView?) -> PlanLayout<UIVisualEffectView> {
        fitStackedAndCreateView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func fitStackedVisualEffect() -> PlanLayout<UIVisualEffectView> {
        fitStacked(.init())
    }
    
    //MARK: UINavigationBar
    
    @discardableResult
    public func fitStackedNavigation(assignTo view: inout UINavigationBar?) -> PlanLayout<UINavigationBar> {
        fitStackedAndCreateView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func fitStackedNavigation() -> PlanLayout<UINavigationBar> {
        fitStacked(.init())
    }
    
    //MARK: UITabBar
    
    @discardableResult
    public func fitStackedTabBar(assignTo view: inout UITabBar?) -> PlanLayout<UITabBar> {
        fitStackedAndCreateView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func fitStackedTabBar() -> PlanLayout<UITabBar> {
        fitStacked(.init())
    }
}
