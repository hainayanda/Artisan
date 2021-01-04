//
//  FragmentCell.swift
//  Artisan
//
//  Created by Nayanda Haberty (ID) on 28/08/20.
//

import Foundation
import UIKit

public protocol FragmentCell: Fragment {
    var layoutPhase: CellLayoutingPhase { get }
    var planningBehavior: CellPlanningBehavior { get }
    func planningOption(on phase: CellLayoutingPhase) -> PlanningOption
}

open class TableFragmentCell: UITableViewCell, FragmentCell {
    var _layoutPhase: CellLayoutingPhase = .firstLoad
    public internal(set) var layoutPhase: CellLayoutingPhase {
        get {
            layouted ? _layoutPhase : .firstLoad
        }
        set {
            _layoutPhase = newValue
        }
    }
    var mediator: StatedMediator?
    
    var layouted: Bool = false
    
    open var planningBehavior: CellPlanningBehavior { .planOnce }
    
    open func planContent(_ plan: InsertablePlan) { }
    
    open func fragmentWillPlanContent() {}
    
    open func fragmentDidPlanContent() {}
    
    @discardableResult
    open func layoutContentIfNeeded() -> Bool {
        defer {
            layouted = true
        }
        guard planningBehavior.whitelistedPhases.contains(layoutPhase) else {
            return false
        }
        fragmentWillPlanContent()
        contentView.planContent(planningOption(on: layoutPhase)) { content in
            planContent(content)
        }
        fragmentDidPlanContent()
        return true
    }
    
    open func calculatedCellHeight(for cellWidth: CGFloat) -> CGFloat { .automatic }
    
    open override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        let layouted = layoutContentIfNeeded()
        if layouted {
            setNeedsDisplay()
        }
        let size = super.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: horizontalFittingPriority,
            verticalFittingPriority: verticalFittingPriority
        )
        let cellHeight = calculatedCellHeight(for: size.width)
        let height = cellHeight == .automatic ? size.height : cellHeight
        return CGSize(width: size.width, height: height)
    }
    
    open func planningOption(on phase: CellLayoutingPhase) -> PlanningOption {
        switch phase {
        case .firstLoad:
            return .append
        default:
            return .startFresh
        }
    }
    
    open override func prepareForReuse() {
        layoutPhase = .reused
        layoutContentIfNeeded()
    }
    
    open override func setNeedsLayout() {
        defer {
            super.setNeedsLayout()
        }
        guard layouted else { return }
        layoutPhase = .setNeedsLayout
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        layoutContentIfNeeded()
        layoutPhase = .none
    }
}

open class CollectionFragmentCell: UICollectionViewCell, FragmentCell {
    var _layoutPhase: CellLayoutingPhase = .firstLoad
    public internal(set) var layoutPhase: CellLayoutingPhase {
        get {
            layouted ? _layoutPhase : .firstLoad
        }
        set {
            _layoutPhase = newValue
        }
    }
    var mediator: StatedMediator?
    
    var layouted: Bool = false
    
    open var planningBehavior: CellPlanningBehavior { .planOnce }
    
    var collectionContentSize: CGSize = UIScreen.main.bounds.size
    
    open func planContent(_ layout: InsertablePlan) { }
    
    open func fragmentWillPlanContent() {}
    
    open func fragmentDidPlanContent() {}
    
    @discardableResult
    open func layoutContentIfNeeded() -> Bool {
        defer {
            layouted = true
        }
        guard planningBehavior.whitelistedPhases.contains(layoutPhase) else {
            return false
        }
        fragmentWillPlanContent()
        contentView.planContent(planningOption(on: layoutPhase)) { content in
            planContent(content)
        }
        fragmentDidPlanContent()
        return true
    }
    
    open func calculatedCellSize(for collectionContentSize: CGSize) -> CGSize { .automatic }
    
    open override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let layouted = layoutContentIfNeeded()
        if layouted {
            setNeedsDisplay()
        }
        let calculatedSize = calculatedCellSize(for: collectionContentSize)
        let automatedSize = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        let size: CGSize = .init(
            width: calculatedSize.width == .automatic ? automatedSize.width : calculatedSize.width,
            height: calculatedSize.height == .automatic ? automatedSize.height : calculatedSize.height
        )
        var newFrame = layoutAttributes.frame
        newFrame.size = size
        layoutAttributes.frame = newFrame
        return layoutAttributes
    }
    
    open func planningOption(on phase: CellLayoutingPhase) -> PlanningOption {
        switch phase {
        case .firstLoad:
            return .append
        default:
            return .startFresh
        }
    }
    
    open override func prepareForReuse() {
        layoutPhase = .reused
        layoutContentIfNeeded()
    }
    
    open override func setNeedsLayout() {
        defer {
            super.setNeedsLayout()
        }
        guard layouted else { return }
        layoutPhase = .setNeedsLayout
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        layoutContentIfNeeded()
        layoutPhase = .none
    }
}
