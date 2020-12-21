//
//  FragmentCellSpec.swift
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

class FragmentCellSpec: QuickSpec {
    override func spec() {
        describe("molecule cell behaviour") {
            context("table molecule cell") {
                var tableCell: TestableTableCell!
                beforeEach {
                    tableCell = .init()
                }
                it("should layout content only first load") {
                    var layouted: Bool = false
                    tableCell.layoutPhase = .firstLoad
                    tableCell.planningBehavior = .planOnce
                    tableCell.didPlanContent = { plan in
                        expect((plan as? LayoutPlan<UIView>)?.view)
                            .to(equal(tableCell.contentView))
                        layouted = true
                    }
                    tableCell.layoutSubviews()
                    expect(layouted).to(beTrue())
                    layouted = false
                    tableCell.layoutPhase = .reused
                    tableCell.layoutSubviews()
                    expect(layouted).to(beFalse())
                    tableCell.layoutPhase = .setNeedsLayout
                    tableCell.layoutSubviews()
                    expect(layouted).to(beFalse())
                    tableCell.layoutPhase = .none
                    tableCell.layoutSubviews()
                    expect(layouted).to(beFalse())
                }
                it("should layout content only on reused and first load") {
                    var layouted: Bool = false
                    tableCell.layoutPhase = .firstLoad
                    tableCell.planningBehavior = .planOn(.reused)
                    tableCell.didPlanContent = { plan in
                        expect((plan as? LayoutPlan<UIView>)?.view)
                            .to(equal(tableCell.contentView))
                        layouted = true
                    }
                    tableCell.layoutSubviews()
                    expect(layouted).to(beTrue())
                    layouted = false
                    tableCell.layoutPhase = .reused
                    tableCell.layoutSubviews()
                    expect(layouted).to(beTrue())
                    layouted = false
                    tableCell.layoutPhase = .setNeedsLayout
                    tableCell.layoutSubviews()
                    expect(layouted).to(beFalse())
                    tableCell.layoutPhase = .none
                    tableCell.layoutSubviews()
                    expect(layouted).to(beFalse())
                }
                it("should layout content only on setNeedsLayout and first load") {
                    var layouted: Bool = false
                    tableCell.layoutPhase = .firstLoad
                    tableCell.planningBehavior = .planOn(.setNeedsLayout)
                    tableCell.didPlanContent = { plan in
                        expect((plan as? LayoutPlan<UIView>)?.view)
                            .to(equal(tableCell.contentView))
                        layouted = true
                    }
                    tableCell.layoutSubviews()
                    expect(layouted).to(beTrue())
                    layouted = false
                    tableCell.layoutPhase = .setNeedsLayout
                    tableCell.layoutSubviews()
                    expect(layouted).to(beTrue())
                    layouted = false
                    tableCell.layoutPhase = .reused
                    tableCell.layoutSubviews()
                    expect(layouted).to(beFalse())
                    tableCell.layoutPhase = .none
                    tableCell.layoutSubviews()
                    expect(layouted).to(beFalse())
                }
                it("should layout content on any given phase") {
                    var layouted: Bool = false
                    tableCell.layoutPhase = .firstLoad
                    tableCell.planningBehavior = .planOnEach([.none, .reused, .setNeedsLayout])
                    tableCell.didPlanContent = { plan in
                        expect((plan as? LayoutPlan<UIView>)?.view)
                            .to(equal(tableCell.contentView))
                        layouted = true
                    }
                    tableCell.layoutSubviews()
                    expect(layouted).to(beTrue())
                    layouted = false
                    tableCell.layoutPhase = .setNeedsLayout
                    tableCell.layoutSubviews()
                    expect(layouted).to(beTrue())
                    layouted = false
                    tableCell.layoutPhase = .reused
                    tableCell.layoutSubviews()
                    expect(layouted).to(beTrue())
                    layouted = false
                    tableCell.layoutPhase = .none
                    tableCell.layoutSubviews()
                    expect(layouted).to(beTrue())
                }
                it("should get sublayouting option") {
                    var layoutOptionPhase: CellLayoutingPhase = .none
                    var layouted: Bool = false
                    tableCell.planningBehavior = .planIfPossible
                    tableCell.didNeedPlanningOption = { phase in
                        layoutOptionPhase = phase
                        return .append
                    }
                    tableCell.didPlanContent = { plan in
                        let container = plan as? LayoutPlan<UIView>
                        expect(container?.view)
                            .to(equal(tableCell.contentView))
                        layouted = true
                    }
                    tableCell.layoutPhase = .firstLoad
                    tableCell.layoutSubviews()
                    expect(layouted).to(beTrue())
                    expect(layoutOptionPhase).to(equal(.firstLoad))
                    layouted = false
                    tableCell.layoutPhase = .reused
                    tableCell.layoutSubviews()
                    expect(layouted).to(beTrue())
                    expect(layoutOptionPhase).to(equal(.reused))
                    layouted = false
                    tableCell.layoutPhase = .setNeedsLayout
                    tableCell.layoutSubviews()
                    expect(layouted).to(beTrue())
                    expect(layoutOptionPhase).to(equal(.setNeedsLayout))
                }
                it("should use calculated size") {
                    var layoutFitted: Bool = false
                    var calculated: Bool = false
                    var tableWidth: CGFloat = .automatic
                    let tableHeight: CGFloat = .random(in: 0..<500)
                    tableCell.didLayoutFitting = { _ in
                        layoutFitted = true
                    }
                    tableCell.didCalculatedCellHeight = { width in
                        defer {
                            calculated = true
                        }
                        tableWidth = width
                        return tableHeight
                    }
                    let size = tableCell.systemLayoutSizeFitting(
                        .init(width: .random(in: 0..<50), height: .random(in: 0..<100)),
                        withHorizontalFittingPriority: .defaultHigh,
                        verticalFittingPriority: .defaultHigh
                    )
                    expect(layoutFitted).to(beTrue())
                    expect(calculated).to(beTrue())
                    expect(size).to(equal(.init(width: tableWidth, height: tableHeight)))
                }
            }
            context("collection molecule cell") {
                var collectionCell: TestableCollectionCell!
                beforeEach {
                    collectionCell = .init()
                }
                it("should layout content only first load") {
                    var layouted: Bool = false
                    collectionCell.layoutPhase = .firstLoad
                    collectionCell.planningBehavior = .planOnce
                    collectionCell.didPlanContent = { plan in
                        expect((plan as? LayoutPlan<UIView>)?.view)
                            .to(equal(collectionCell.contentView))
                        layouted = true
                    }
                    collectionCell.layoutSubviews()
                    expect(layouted).to(beTrue())
                    layouted = false
                    collectionCell.layoutPhase = .reused
                    collectionCell.layoutSubviews()
                    expect(layouted).to(beFalse())
                    collectionCell.layoutPhase = .setNeedsLayout
                    collectionCell.layoutSubviews()
                    expect(layouted).to(beFalse())
                    collectionCell.layoutPhase = .none
                    collectionCell.layoutSubviews()
                    expect(layouted).to(beFalse())
                }
                it("should layout content only on reused and first load") {
                    var layouted: Bool = false
                    collectionCell.layoutPhase = .firstLoad
                    collectionCell.planningBehavior = .planOn(.reused)
                    collectionCell.didPlanContent = { plan in
                        expect((plan as? LayoutPlan<UIView>)?.view)
                            .to(equal(collectionCell.contentView))
                        layouted = true
                    }
                    collectionCell.layoutSubviews()
                    expect(layouted).to(beTrue())
                    layouted = false
                    collectionCell.layoutPhase = .reused
                    collectionCell.layoutSubviews()
                    expect(layouted).to(beTrue())
                    layouted = false
                    collectionCell.layoutPhase = .setNeedsLayout
                    collectionCell.layoutSubviews()
                    expect(layouted).to(beFalse())
                    collectionCell.layoutPhase = .none
                    collectionCell.layoutSubviews()
                    expect(layouted).to(beFalse())
                }
                it("should layout content only on setNeedsLayout and first load") {
                    var layouted: Bool = false
                    collectionCell.layoutPhase = .firstLoad
                    collectionCell.planningBehavior = .planOn(.setNeedsLayout)
                    collectionCell.didPlanContent = { plan in
                        expect((plan as? LayoutPlan<UIView>)?.view)
                            .to(equal(collectionCell.contentView))
                        layouted = true
                    }
                    collectionCell.layoutSubviews()
                    expect(layouted).to(beTrue())
                    layouted = false
                    collectionCell.layoutPhase = .setNeedsLayout
                    collectionCell.layoutSubviews()
                    expect(layouted).to(beTrue())
                    layouted = false
                    collectionCell.layoutPhase = .reused
                    collectionCell.layoutSubviews()
                    expect(layouted).to(beFalse())
                    collectionCell.layoutPhase = .none
                    collectionCell.layoutSubviews()
                    expect(layouted).to(beFalse())
                }
                it("should layout content on any given phase") {
                    var layouted: Bool = false
                    collectionCell.layoutPhase = .firstLoad
                    collectionCell.planningBehavior = .planOnEach([.none, .reused, .setNeedsLayout])
                    collectionCell.didPlanContent = { plan in
                        expect((plan as? LayoutPlan<UIView>)?.view)
                            .to(equal(collectionCell.contentView))
                        layouted = true
                    }
                    collectionCell.layoutSubviews()
                    expect(layouted).to(beTrue())
                    layouted = false
                    collectionCell.layoutPhase = .setNeedsLayout
                    collectionCell.layoutSubviews()
                    expect(layouted).to(beTrue())
                    layouted = false
                    collectionCell.layoutPhase = .reused
                    collectionCell.layoutSubviews()
                    expect(layouted).to(beTrue())
                    layouted = false
                    collectionCell.layoutPhase = .none
                    collectionCell.layoutSubviews()
                    expect(layouted).to(beTrue())
                }
                it("should get sublayouting option") {
                    var layoutOptionPhase: CellLayoutingPhase = .none
                    var layouted: Bool = false
                    collectionCell.planningBehavior = .planIfPossible
                    collectionCell.didNeedPlanningOption = { phase in
                        layoutOptionPhase = phase
                        return .append
                    }
                    collectionCell.didPlanContent = { plan in
                        let container = plan as? LayoutPlan<UIView>
                        expect(container?.view)
                            .to(equal(collectionCell.contentView))
                        layouted = true
                    }
                    collectionCell.layoutPhase = .firstLoad
                    collectionCell.layoutSubviews()
                    expect(layouted).to(beTrue())
                    expect(layoutOptionPhase).to(equal(.firstLoad))
                    layouted = false
                    collectionCell.layoutPhase = .reused
                    collectionCell.layoutSubviews()
                    expect(layouted).to(beTrue())
                    expect(layoutOptionPhase).to(equal(.reused))
                    layouted = false
                    collectionCell.layoutPhase = .setNeedsLayout
                    collectionCell.layoutSubviews()
                    expect(layouted).to(beTrue())
                    expect(layoutOptionPhase).to(equal(.setNeedsLayout))
                }
            }
        }
    }
}

class TestableTableCell: TableFragmentCell {
    private var _layoutPhase: CellLayoutingPhase = .firstLoad
    public override var layoutPhase: CellLayoutingPhase {
        get {
            _layoutPhase
        }
        set {
            _layoutPhase = newValue
        }
    }
    private var _layoutBehaviour: CellPlanningBehavior = .planOnce
    override var planningBehavior: CellPlanningBehavior {
        get {
            _layoutBehaviour
        }
        set {
            _layoutBehaviour = newValue
        }
    }
    
    var didNeedPlanningOption: ((CellLayoutingPhase) -> PlanningOption)?
    override func planningOption(on phase: CellLayoutingPhase) -> PlanningOption {
        didNeedPlanningOption?(phase) ?? super.planningOption(on: phase)
    }
    
    var didPlanContent: ((InsertablePlan) -> Void)?
    override func planContent(_ plan: InsertablePlan) {
        didPlanContent?(plan)
    }
    
    var didCalculatedCellHeight: ((CGFloat) -> CGFloat)?
    override func calculatedCellHeight(for cellWidth: CGFloat) -> CGFloat {
        didCalculatedCellHeight?(cellWidth) ?? super.calculatedCellHeight(for: cellWidth)
    }
    
    var didLayoutFitting: ((CGSize) -> Void)?
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        let size = super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
        didLayoutFitting?(size)
        return size
    }
}

class TestableCollectionCell: CollectionFragmentCell {
    private var _layoutPhase: CellLayoutingPhase = .firstLoad
    public override var layoutPhase: CellLayoutingPhase {
        get {
            _layoutPhase
        }
        set {
            _layoutPhase = newValue
        }
    }
    private var _planningBehavior: CellPlanningBehavior = .planOnce
    override var planningBehavior: CellPlanningBehavior {
        get {
            _planningBehavior
        }
        set {
            _planningBehavior = newValue
        }
    }
    
    var didNeedPlanningOption: ((CellLayoutingPhase) -> PlanningOption)?
    override func planningOption(on phase: CellLayoutingPhase) -> PlanningOption {
        didNeedPlanningOption?(phase) ?? super.planningOption(on: phase)
    }
    
    var didPlanContent: ((InsertablePlan) -> Void)?
    override func planContent(_ plan: InsertablePlan) {
        didPlanContent?(plan)
    }
}
