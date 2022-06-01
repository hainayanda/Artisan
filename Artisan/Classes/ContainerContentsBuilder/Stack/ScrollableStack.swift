//
//  ScrollableStack.swift
//  Artisan
//
//  Created by Nayanda Haberty on 29/05/22.
//

import Foundation
#if canImport(UIKit)
import UIKit
import Draftsman

public class ScrollableStack: UIScrollView, Planned {
    let alignment: UIStackView.Alignment
    let axis: NSLayoutConstraint.Axis
    
    lazy var stackView: UIStackView = UIStackView(axis: axis, distribution: .equalSpacing, alignment: alignment)
    
    @LayoutPlan
    public var viewPlan: ViewPlan {
        if axis == .vertical {
            stackView.drf
                .width.equal(with: .parent)
                .edges.equal(with: .parent)
        } else {
            stackView.drf
                .height.equal(with: .parent)
                .edges.equal(with: .parent)
        }
    }
    
    public init(frame: CGRect = .zero, axis: NSLayoutConstraint.Axis, alignment: UIStackView.Alignment = .center) {
        self.axis = axis
        self.alignment = alignment
        super.init(frame: frame)
        applyPlan()
    }
    
    required init?(coder: NSCoder) {
        self.axis = .vertical
        self.alignment = .center
        super.init(coder: coder)
        applyPlan()
    }
}

extension ScrollableStack: StackCompatible {
    public var arrangedSubviews: [UIView] {
        stackView.arrangedSubviews
    }
    
    public func addArrangedSubview(_ view: UIView) {
        stackView.addArrangedSubview(view)
    }
    
    public func removeArrangedSubview(_ view: UIView) {
        stackView.removeArrangedSubview(view)
    }
    
    public func insertArrangedSubview(_ view: UIView, at stackIndex: Int) {
        stackView.insertArrangedSubview(view, at: stackIndex)
    }
    
    @available(iOS 11.0, *)
    public func setCustomSpacing(_ spacing: CGFloat, after arrangedSubview: UIView) {
        stackView.setCustomSpacing(spacing, after: arrangedSubview)
    }
    
    @available(iOS 11.0, *)
    public func customSpacing(after arrangedSubview: UIView) -> CGFloat {
        stackView.customSpacing(after: arrangedSubview)
    }
}
#endif
