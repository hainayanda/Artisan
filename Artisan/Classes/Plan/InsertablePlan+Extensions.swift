//
//  InsertablePlan+Extension.swift
//  Artisan
//
//  Created by Nayanda Haberty (ID) on 03/09/20.
//

import Foundation
import UIKit
import WebKit

extension InsertablePlan {
    func fitNewView<View: UIView>(thenAssignTo view: inout View?) -> PlanLayout<View> {
        let viewToPut = view ?? .init()
        defer {
            view = viewToPut
        }
        return fit(viewToPut)
    }
    
    //MARK: UIView
    @discardableResult
    public func fitView(assignTo view: inout UIView?) -> PlanLayout<UIView> {
        fitNewView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func fitView() -> PlanLayout<UIView> {
        fit(UIView())
    }
    
    //MARK: UIActivityIndicatorView
    
    @discardableResult
    public func fitActivityIndicator(assignTo view: inout UIActivityIndicatorView?) -> PlanLayout<UIActivityIndicatorView> {
        fitNewView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func fitActivityIndicator() -> PlanLayout<UIActivityIndicatorView> {
        fit(.init())
    }
    
    //MARK: UIButton
    
    @discardableResult
    public func fitButton(assignTo view: inout UIButton?) -> PlanLayout<UIButton> {
        fitNewView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func fitButton() -> PlanLayout<UIButton> {
        fit(.init())
    }
    
    //MARK: UIDatePicker
    
    @discardableResult
    public func fitDatePicker(assignTo view: inout UIDatePicker?) -> PlanLayout<UIDatePicker> {
        fitNewView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func fitDatePicker() -> PlanLayout<UIDatePicker> {
        fit(.init())
    }
    
    //MARK: UIPickerView
    
    @discardableResult
    public func fitPicker(assignTo view: inout UIPickerView?) -> PlanLayout<UIPickerView> {
        fitNewView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func fitPicker() -> PlanLayout<UIPickerView> {
        fit(.init())
    }
    
    //MARK: UIImageView
    
    @discardableResult
    public func fitImageView(assignTo view: inout UIImageView?) -> PlanLayout<UIImageView> {
        fitNewView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func fitImageView() -> PlanLayout<UIImageView> {
        fit(.init())
    }
    
    //MARK: UIPageControl
    
    @discardableResult
    public func fitPageControl(assignTo view: inout UIPageControl?) -> PlanLayout<UIPageControl> {
        fitNewView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func fitPageControl() -> PlanLayout<UIPageControl> {
        fit(.init())
    }
    
    //MARK: UIProgressView
    
    @discardableResult
    public func fitProgress(assignTo view: inout UIProgressView?) -> PlanLayout<UIProgressView> {
        fitNewView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func fitProgress() -> PlanLayout<UIProgressView> {
        fit(.init())
    }
    
    //MARK: UISearchBar
    
    @discardableResult
    public func fitSearchBar(assignTo view: inout UISearchBar?) -> PlanLayout<UISearchBar> {
        fitNewView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func fitSearchBar() -> PlanLayout<UISearchBar> {
        fit(.init())
    }
    
    @available(iOS 13.0, *)
    @discardableResult
    public func fitSearchField(assignTo view: inout UISearchTextField?) -> PlanLayout<UISearchTextField> {
        fitNewView(thenAssignTo: &view)
    }
    
    @available(iOS 13.0, *)
    @discardableResult
    public func fitSearchField() -> PlanLayout<UISearchTextField> {
        fit(.init())
    }
    
    //MARK: UISegmentedControl
    
    @discardableResult
    public func fitSegmentedControl(assignTo view: inout UISegmentedControl?) -> PlanLayout<UISegmentedControl> {
        fitNewView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func fitSegmentedControl() -> PlanLayout<UISegmentedControl> {
        fit(.init())
    }
    
    //MARK: UISlider
    
    @discardableResult
    public func fitSlider(assignTo view: inout UISlider?) -> PlanLayout<UISlider> {
        fitNewView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func fitSlider() -> PlanLayout<UISlider> {
        fit(.init())
    }
    
    //MARK: UIStackView
    
    @discardableResult
    public func fitStack(assignTo view: inout UIStackView?) -> PlanLayout<UIStackView> {
        fitNewView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func fitStack() -> PlanLayout<UIStackView> {
        fit(.init())
    }
    
    @discardableResult
    public func fitVStack(assignTo view: inout UIStackView?) -> PlanLayout<UIStackView> {
        let layout = fitNewView(thenAssignTo: &view)
        view?.axis = .vertical
        return layout
    }
    
    @discardableResult
    public func fitVStack() -> PlanLayout<UIStackView> {
        let stack: UIStackView = .init()
        stack.axis = .vertical
        return fit(stack)
    }
    
    @discardableResult
    public func fitHStack(assignTo view: inout UIStackView?) -> PlanLayout<UIStackView> {
        let layout = fitNewView(thenAssignTo: &view)
        view?.axis = .horizontal
        return layout
    }
    
    @discardableResult
    public func fitHStack() -> PlanLayout<UIStackView> {
        let stack: UIStackView = .init()
        stack.axis = .horizontal
        return fit(stack)
    }
    
    //MARK: UIStepper
    
    @discardableResult
    public func fitStepper(assignTo view: inout UIStepper?) -> PlanLayout<UIStepper> {
        fitNewView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func fitStepper() -> PlanLayout<UIStepper> {
        fit(.init())
    }
    
    //MARK: UISwitch
    
    @discardableResult
    public func fitSwitch(assignTo view: inout UISwitch?) -> PlanLayout<UISwitch> {
        fitNewView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func fitSwitch() -> PlanLayout<UISwitch> {
        fit(.init())
    }
    
    //MARK: UITextField
    
    @discardableResult
    public func fitTextField(assignTo view: inout UITextField?) -> PlanLayout<UITextField> {
        fitNewView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func fitTextField() -> PlanLayout<UITextField> {
        fit(.init())
    }
    
    //MARK: UITextView
    
    @discardableResult
    public func fitTextView(assignTo view: inout UITextView?) -> PlanLayout<UITextView> {
        fitNewView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func fitTextView() -> PlanLayout<UITextView> {
        fit(.init())
    }
    
    //MARK: UIToolbar
    
    @discardableResult
    public func fitToolbar(assignTo view: inout UIToolbar?) -> PlanLayout<UIToolbar> {
        fitNewView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func fitToolbar() -> PlanLayout<UIToolbar> {
        fit(.init())
    }
    
    //MARK: WKWebView
    
    @discardableResult
    public func fitWebView(assignTo view: inout WKWebView?) -> PlanLayout<WKWebView> {
        fitNewView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func fitWebView() -> PlanLayout<WKWebView> {
        fit(.init())
    }
    
    //MARK: UIScrollView
    
    @discardableResult
    public func fitScroll(assignTo view: inout UIScrollView?) -> PlanLayout<UIScrollView> {
        fitNewView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func fitScroll() -> PlanLayout<UIScrollView> {
        fit(.init())
    }
    
    //MARK: UITableView
    
    @discardableResult
    public func fitTable(assignTo view: inout UITableView?) -> PlanLayout<UITableView> {
        fitNewView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func fitTable() -> PlanLayout<UITableView> {
        fit(.init())
    }
    
    //MARK: UICollectionView
    
    @discardableResult
    public func fitCollection(assignTo view: inout UICollectionView?) -> PlanLayout<UICollectionView> {
        let collectionToPut = view ?? .init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        defer {
            view = collectionToPut
        }
        return fit(collectionToPut)
    }
    
    @discardableResult
    public func fitCollection() -> PlanLayout<UICollectionView> {
        fit(.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()))
    }
    
    //MARK: UILabel
    
    @discardableResult
    public func fitLabel(assignTo view: inout UILabel?) -> PlanLayout<UILabel> {
        fitNewView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func fitLabel() -> PlanLayout<UILabel> {
        fit(.init())
    }
    
    //MARK: UIVisualEffectView
    
    @discardableResult
    public func fitVisualEffect(assignTo view: inout UIVisualEffectView?) -> PlanLayout<UIVisualEffectView> {
        fitNewView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func fitVisualEffect() -> PlanLayout<UIVisualEffectView> {
        fit(.init())
    }
    
    //MARK: UINavigationBar
    
    @discardableResult
    public func fitNavigation(assignTo view: inout UINavigationBar?) -> PlanLayout<UINavigationBar> {
        fitNewView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func fitNavigation() -> PlanLayout<UINavigationBar> {
        fit(.init())
    }
    
    //MARK: UITabBar
    
    @discardableResult
    public func fitTabBar(assignTo view: inout UITabBar?) -> PlanLayout<UITabBar> {
        fitNewView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func fitTabBar() -> PlanLayout<UITabBar> {
        fit(.init())
    }
}
