//
//  PlanLayoutSpec.swift
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

class PlanLayoutSpec: QuickSpec {
    
    override func spec() {
        describe("view layout behaviour") {
            var view: UIView!
            var planLayoutForTest: PlanLayout<UIView>!
            beforeEach {
                view = .init()
                planLayoutForTest = .init(view: view, context: .init(currentView: view))
            }
            it("should add position constraint to other view") {
                let otherView: UIView = .init()
                let otherHAnchors = [otherView.rightAnchor, otherView.leftAnchor, otherView.centerXAnchor]
                let otherVAnchors = [otherView.topAnchor, otherView.bottomAnchor, otherView.centerYAnchor]
                let layoutRelations: [LayoutRelation<CGFloat>] = [
                    .equal, .equalTo(.random(in: -10..<10)), .lessThan,
                    .lessThanTo(.random(in: -10..<10)), .moreThan, .moreThanTo(.random(in: -10..<10))
                ]
                let comparator: (LayoutRelation<CGFloat>, CGFloat) -> Void = { relation, multiplier in
                    switch relation {
                    case .equal:
                        expect(planLayoutForTest.plannedConstraints.last?.relation).to(equal(.equal))
                    case .equalTo(let space):
                        expect(planLayoutForTest.plannedConstraints.last?.relation).to(equal(.equal))
                        expect(planLayoutForTest.plannedConstraints.last?.constant).to(equal(multiplier * space))
                    case .lessThan:
                        expect(planLayoutForTest.plannedConstraints.last?.relation).to(equal(.lessThanOrEqual))
                    case .lessThanTo(let space):
                        expect(planLayoutForTest.plannedConstraints.last?.relation).to(equal(.lessThanOrEqual))
                        expect(planLayoutForTest.plannedConstraints.last?.constant).to(equal(multiplier * space))
                    case .moreThan:
                        expect(planLayoutForTest.plannedConstraints.last?.relation).to(equal(.greaterThanOrEqual))
                    case .moreThanTo(let space):
                        expect(planLayoutForTest.plannedConstraints.last?.relation).to(equal(.greaterThanOrEqual))
                        expect(planLayoutForTest.plannedConstraints.last?.constant).to(equal(multiplier * space))
                    }
                }
                for relation in layoutRelations {
                    let priority: UILayoutPriority = .init(.random(in: 0..<1000))
                    let otherAnchor = otherHAnchors[Int.random(in: 0..<3)]
                    planLayoutForTest.left(relation, to: otherAnchor, priority: priority)
                    expect(planLayoutForTest.plannedConstraints.last?.firstItem as? UIView).to(equal(view))
                    expect(planLayoutForTest.plannedConstraints.last?.secondItem as? UIView).to(equal(otherView))
                    if #available(iOS 10.0, *) {
                        expect(planLayoutForTest.plannedConstraints.last?.firstAnchor).to(equal(view.leftAnchor))
                        expect(planLayoutForTest.plannedConstraints.last?.secondAnchor).to(equal(otherAnchor))
                    }
                    expect(planLayoutForTest.plannedConstraints.last?.priority).to(equal(priority))
                    comparator(relation, 1)
                }
                for relation in layoutRelations {
                    let priority: UILayoutPriority = .init(.random(in: 0..<1000))
                    let otherAnchor = otherHAnchors[Int.random(in: 0..<3)]
                    planLayoutForTest.right(relation, to: otherAnchor, priority: priority)
                    expect(planLayoutForTest.plannedConstraints.last?.firstItem as? UIView).to(equal(view))
                    expect(planLayoutForTest.plannedConstraints.last?.secondItem as? UIView).to(equal(otherView))
                    if #available(iOS 10.0, *) {
                        expect(planLayoutForTest.plannedConstraints.last?.firstAnchor).to(equal(view.rightAnchor))
                        expect(planLayoutForTest.plannedConstraints.last?.secondAnchor).to(equal(otherAnchor))
                    }
                    expect(planLayoutForTest.plannedConstraints.last?.priority).to(equal(priority))
                    comparator(relation, -1)
                }
                for relation in layoutRelations {
                    let priority: UILayoutPriority = .init(.random(in: 0..<1000))
                    let otherAnchor = otherVAnchors[Int.random(in: 0..<3)]
                    planLayoutForTest.top(relation, to: otherAnchor, priority: priority)
                    expect(planLayoutForTest.plannedConstraints.last?.firstItem as? UIView).to(equal(view))
                    expect(planLayoutForTest.plannedConstraints.last?.secondItem as? UIView).to(equal(otherView))
                    if #available(iOS 10.0, *) {
                        expect(planLayoutForTest.plannedConstraints.last?.firstAnchor).to(equal(view.topAnchor))
                        expect(planLayoutForTest.plannedConstraints.last?.secondAnchor).to(equal(otherAnchor))
                    }
                    expect(planLayoutForTest.plannedConstraints.last?.priority).to(equal(priority))
                    comparator(relation, 1)
                }
                for relation in layoutRelations {
                    let priority: UILayoutPriority = .init(.random(in: 0..<1000))
                    let otherAnchor = otherVAnchors[Int.random(in: 0..<3)]
                    planLayoutForTest.bottom(relation, to: otherAnchor, priority: priority)
                    expect(planLayoutForTest.plannedConstraints.last?.firstItem as? UIView).to(equal(view))
                    expect(planLayoutForTest.plannedConstraints.last?.secondItem as? UIView).to(equal(otherView))
                    if #available(iOS 10.0, *) {
                        expect(planLayoutForTest.plannedConstraints.last?.firstAnchor).to(equal(view.bottomAnchor))
                        expect(planLayoutForTest.plannedConstraints.last?.secondAnchor).to(equal(otherAnchor))
                    }
                    expect(planLayoutForTest.plannedConstraints.last?.priority).to(equal(priority))
                    comparator(relation, -1)
                }
                for relation in layoutRelations {
                    let priority: UILayoutPriority = .init(.random(in: 0..<1000))
                    let otherAnchor = otherHAnchors[Int.random(in: 0..<3)]
                    planLayoutForTest.centerX(relation, to: otherAnchor, priority: priority)
                    expect(planLayoutForTest.plannedConstraints.last?.firstItem as? UIView).to(equal(view))
                    expect(planLayoutForTest.plannedConstraints.last?.secondItem as? UIView).to(equal(otherView))
                    if #available(iOS 10.0, *) {
                        expect(planLayoutForTest.plannedConstraints.last?.firstAnchor).to(equal(view.centerXAnchor))
                        expect(planLayoutForTest.plannedConstraints.last?.secondAnchor).to(equal(otherAnchor))
                    }
                    expect(planLayoutForTest.plannedConstraints.last?.priority).to(equal(priority))
                    comparator(relation, 1)
                }
                for relation in layoutRelations {
                    let priority: UILayoutPriority = .init(.random(in: 0..<1000))
                    let otherAnchor = otherVAnchors[Int.random(in: 0..<3)]
                    planLayoutForTest.centerY(relation, to: otherAnchor, priority: priority)
                    expect(planLayoutForTest.plannedConstraints.last?.firstItem as? UIView).to(equal(view))
                    expect(planLayoutForTest.plannedConstraints.last?.secondItem as? UIView).to(equal(otherView))
                    if #available(iOS 10.0, *) {
                        expect(planLayoutForTest.plannedConstraints.last?.firstAnchor).to(equal(view.centerYAnchor))
                        expect(planLayoutForTest.plannedConstraints.last?.secondAnchor).to(equal(otherAnchor))
                    }
                    expect(planLayoutForTest.plannedConstraints.last?.priority).to(equal(priority))
                    comparator(relation, 1)
                }
            }
            it("should add position constraint to parent") {
                let parentView: UIView = .init()
                let layoutRelations: [LayoutRelation<CGFloat>] = [
                    .equal, .equalTo(.random(in: 0..<10)), .lessThan,
                    .lessThanTo(.random(in: 0..<10)), .moreThan, .moreThanTo(.random(in: 0..<10))
                ]
                parentView.addSubview(view)
                let comparator: (LayoutRelation<CGFloat>, CGFloat) -> Void = { relation, multiplier in
                    switch relation {
                    case .equal:
                        expect(planLayoutForTest.plannedConstraints.last?.relation).to(equal(.equal))
                    case .equalTo(let space):
                        expect(planLayoutForTest.plannedConstraints.last?.relation).to(equal(.equal))
                        expect(planLayoutForTest.plannedConstraints.last?.constant).to(equal(multiplier * space))
                    case .lessThan:
                        expect(planLayoutForTest.plannedConstraints.last?.relation).to(equal(.lessThanOrEqual))
                    case .lessThanTo(let space):
                        expect(planLayoutForTest.plannedConstraints.last?.relation).to(equal(.lessThanOrEqual))
                        expect(planLayoutForTest.plannedConstraints.last?.constant).to(equal(multiplier * space))
                    case .moreThan:
                        expect(planLayoutForTest.plannedConstraints.last?.relation).to(equal(.greaterThanOrEqual))
                    case .moreThanTo(let space):
                        expect(planLayoutForTest.plannedConstraints.last?.relation).to(equal(.greaterThanOrEqual))
                        expect(planLayoutForTest.plannedConstraints.last?.constant).to(equal(multiplier * space))
                    }
                }
                for relation in layoutRelations {
                    let priority: UILayoutPriority = .init(.random(in: 0..<1000))
                    planLayoutForTest.left(relation, to: .parent, priority: priority)
                    expect(planLayoutForTest.plannedConstraints.last?.firstItem as? UIView).to(equal(view))
                    expect(planLayoutForTest.plannedConstraints.last?.secondItem as? UIView).to(equal(parentView))
                    if #available(iOS 10.0, *) {
                        expect(planLayoutForTest.plannedConstraints.last?.firstAnchor).to(equal(view.leftAnchor))
                        expect(planLayoutForTest.plannedConstraints.last?.secondAnchor).to(equal(parentView.leftAnchor))
                    }
                    expect(planLayoutForTest.plannedConstraints.last?.priority).to(equal(priority))
                    comparator(relation, 1)
                    expect(planLayoutForTest.plannedConstraints.count).to(equal(1))
                }
                for relation in layoutRelations {
                    let priority: UILayoutPriority = .init(.random(in: 0..<1000))
                    planLayoutForTest.right(relation, to: .parent, priority: priority)
                    expect(planLayoutForTest.plannedConstraints.last?.firstItem as? UIView).to(equal(view))
                    expect(planLayoutForTest.plannedConstraints.last?.secondItem as? UIView).to(equal(parentView))
                    if #available(iOS 10.0, *) {
                        expect(planLayoutForTest.plannedConstraints.last?.firstAnchor).to(equal(view.rightAnchor))
                        expect(planLayoutForTest.plannedConstraints.last?.secondAnchor).to(equal(parentView.rightAnchor))
                    }
                    expect(planLayoutForTest.plannedConstraints.last?.priority).to(equal(priority))
                    comparator(relation, -1)
                    expect(planLayoutForTest.plannedConstraints.count).to(equal(2))
                }
                for relation in layoutRelations {
                    let priority: UILayoutPriority = .init(.random(in: 0..<1000))
                    planLayoutForTest.top(relation, to: .parent, priority: priority)
                    expect(planLayoutForTest.plannedConstraints.last?.firstItem as? UIView).to(equal(view))
                    expect(planLayoutForTest.plannedConstraints.last?.secondItem as? UIView).to(equal(parentView))
                    if #available(iOS 10.0, *) {
                        expect(planLayoutForTest.plannedConstraints.last?.firstAnchor).to(equal(view.topAnchor))
                        expect(planLayoutForTest.plannedConstraints.last?.secondAnchor).to(equal(parentView.topAnchor))
                    }
                    expect(planLayoutForTest.plannedConstraints.last?.priority).to(equal(priority))
                    comparator(relation, 1)
                    expect(planLayoutForTest.plannedConstraints.count).to(equal(3))
                }
                for relation in layoutRelations {
                    let priority: UILayoutPriority = .init(.random(in: 0..<1000))
                    planLayoutForTest.bottom(relation, to: .parent, priority: priority)
                    expect(planLayoutForTest.plannedConstraints.last?.firstItem as? UIView).to(equal(view))
                    expect(planLayoutForTest.plannedConstraints.last?.secondItem as? UIView).to(equal(parentView))
                    if #available(iOS 10.0, *) {
                        expect(planLayoutForTest.plannedConstraints.last?.firstAnchor).to(equal(view.bottomAnchor))
                        expect(planLayoutForTest.plannedConstraints.last?.secondAnchor).to(equal(parentView.bottomAnchor))
                    }
                    expect(planLayoutForTest.plannedConstraints.last?.priority).to(equal(priority))
                    comparator(relation, -1)
                    expect(planLayoutForTest.plannedConstraints.count).to(equal(4))
                }
                for relation in layoutRelations {
                    let priority: UILayoutPriority = .init(.random(in: 0..<1000))
                    planLayoutForTest.centerX(relation, to: .parent, priority: priority)
                    expect(planLayoutForTest.plannedConstraints.last?.firstItem as? UIView).to(equal(view))
                    expect(planLayoutForTest.plannedConstraints.last?.secondItem as? UIView).to(equal(parentView))
                    if #available(iOS 10.0, *) {
                        expect(planLayoutForTest.plannedConstraints.last?.firstAnchor).to(equal(view.centerXAnchor))
                        expect(planLayoutForTest.plannedConstraints.last?.secondAnchor).to(equal(parentView.centerXAnchor))
                    }
                    expect(planLayoutForTest.plannedConstraints.last?.priority).to(equal(priority))
                    comparator(relation, 1)
                    expect(planLayoutForTest.plannedConstraints.count).to(equal(5))
                }
                for relation in layoutRelations {
                    let priority: UILayoutPriority = .init(.random(in: 0..<1000))
                    planLayoutForTest.centerY(relation, to: .parent, priority: priority)
                    expect(planLayoutForTest.plannedConstraints.last?.firstItem as? UIView).to(equal(view))
                    expect(planLayoutForTest.plannedConstraints.last?.secondItem as? UIView).to(equal(parentView))
                    if #available(iOS 10.0, *) {
                        expect(planLayoutForTest.plannedConstraints.last?.firstAnchor).to(equal(view.centerYAnchor))
                        expect(planLayoutForTest.plannedConstraints.last?.secondAnchor).to(equal(parentView.centerYAnchor))
                    }
                    expect(planLayoutForTest.plannedConstraints.last?.priority).to(equal(priority))
                    comparator(relation, 1)
                    expect(planLayoutForTest.plannedConstraints.count).to(equal(6))
                }
            }
            it("should add dimension constraints to other view") {
                let otherView: UIView = .init()
                let otherHAnchors = [otherView.heightAnchor, otherView.widthAnchor]
                let layoutRelations: [InterRelation<NSLayoutDimension>] = [
                    .equalTo(otherHAnchors[Int.random(in: 0..<2)]),
                    .lessThanTo(otherHAnchors[Int.random(in: 0..<2)]),
                    .moreThanTo(otherHAnchors[Int.random(in: 0..<2)])
                ]
                let comparator: (InterRelation<NSLayoutDimension>) -> Void = { relation in
                    switch relation {
                    case .equalTo(let dimension):
                        expect(planLayoutForTest.plannedConstraints.last?.relation).to(equal(.equal))
                        if #available(iOS 10.0, *) {
                            expect(planLayoutForTest.plannedConstraints.last?.secondAnchor).to(equal(dimension))
                        }
                    case .lessThanTo(let dimension):
                        expect(planLayoutForTest.plannedConstraints.last?.relation).to(equal(.lessThanOrEqual))
                        if #available(iOS 10.0, *) {
                            expect(planLayoutForTest.plannedConstraints.last?.secondAnchor).to(equal(dimension))
                        }
                    case .moreThanTo(let dimension):
                        expect(planLayoutForTest.plannedConstraints.last?.relation).to(equal(.greaterThanOrEqual))
                        if #available(iOS 10.0, *) {
                            expect(planLayoutForTest.plannedConstraints.last?.secondAnchor).to(equal(dimension))
                        }
                    }
                }
                for relation in layoutRelations {
                    let multiplier: CGFloat = .random(in: 1..<5)
                    let constant: CGFloat = .random(in: 0..<20)
                    let priority: UILayoutPriority = .init(.random(in: 0..<1000))
                    planLayoutForTest.height(relation, multiplyBy: multiplier, constant: constant, priority: priority)
                    expect(planLayoutForTest.plannedConstraints.last?.firstItem as? UIView).to(equal(view))
                    expect(planLayoutForTest.plannedConstraints.last?.secondItem as? UIView).to(equal(otherView))
                    if #available(iOS 10.0, *) {
                        expect(planLayoutForTest.plannedConstraints.last?.firstAnchor).to(equal(view.heightAnchor))
                    }
                    let multiplierDifference = abs(multiplier - planLayoutForTest.plannedConstraints.last!.multiplier)
                    expect(multiplierDifference).to(beLessThan(0.0001))
                    expect(planLayoutForTest.plannedConstraints.last?.constant).to(equal(constant))
                    expect(planLayoutForTest.plannedConstraints.last?.priority).to(equal(priority))
                    comparator(relation)
                }
                for relation in layoutRelations {
                    let multiplier: CGFloat = .random(in: 1..<5)
                    let constant: CGFloat = .random(in: 0..<20)
                    let priority: UILayoutPriority = .init(.random(in: 0..<1000))
                    planLayoutForTest.width(relation, multiplyBy: multiplier, constant: constant, priority: priority)
                    expect(planLayoutForTest.plannedConstraints.last?.firstItem as? UIView).to(equal(view))
                    expect(planLayoutForTest.plannedConstraints.last?.secondItem as? UIView).to(equal(otherView))
                    if #available(iOS 10.0, *) {
                        expect(planLayoutForTest.plannedConstraints.last?.firstAnchor).to(equal(view.widthAnchor))
                    }
                    let multiplierDifference = abs(multiplier - planLayoutForTest.plannedConstraints.last!.multiplier)
                    expect(multiplierDifference).to(beLessThan(0.0001))
                    expect(planLayoutForTest.plannedConstraints.last?.constant).to(equal(constant))
                    expect(planLayoutForTest.plannedConstraints.last?.priority).to(equal(priority))
                    comparator(relation)
                }
            }
            
            it("should add dimension constraints to parent") {
                let parentView: UIView = .init()
                parentView.addSubview(view)
                let layoutRelations: [InterRelation<AnonymousRelation>] = [
                    .equalTo(.parent),
                    .lessThanTo(.parent),
                    .moreThanTo(.parent)
                ]
                let comparator: (InterRelation<AnonymousRelation>) -> Void = { relation in
                    switch relation {
                    case .equalTo(_):
                        expect(planLayoutForTest.plannedConstraints.last?.relation).to(equal(.equal))
                    case .lessThanTo(_):
                        expect(planLayoutForTest.plannedConstraints.last?.relation).to(equal(.lessThanOrEqual))
                    case .moreThanTo(_):
                        expect(planLayoutForTest.plannedConstraints.last?.relation).to(equal(.greaterThanOrEqual))
                    }
                }
                for relation in layoutRelations {
                    let multiplier: CGFloat = .random(in: 1..<5)
                    let constant: CGFloat = .random(in: 0..<20)
                    let priority: UILayoutPriority = .init(.random(in: 0..<1000))
                    planLayoutForTest.height(relation, multiplyBy: multiplier, constant: constant, priority: priority)
                    expect(planLayoutForTest.plannedConstraints.last?.firstItem as? UIView).to(equal(view))
                    expect(planLayoutForTest.plannedConstraints.last?.secondItem as? UIView).to(equal(parentView))
                    if #available(iOS 10.0, *) {
                        expect(planLayoutForTest.plannedConstraints.last?.firstAnchor).to(equal(view.heightAnchor))
                        expect(planLayoutForTest.plannedConstraints.last?.secondAnchor).to(equal(parentView.heightAnchor))
                    }
                    let multiplierDifference = abs(multiplier - planLayoutForTest.plannedConstraints.last!.multiplier)
                    expect(multiplierDifference).to(beLessThan(0.0001))
                    expect(planLayoutForTest.plannedConstraints.last?.constant).to(equal(constant))
                    expect(planLayoutForTest.plannedConstraints.last?.priority).to(equal(priority))
                    comparator(relation)
                }
                for relation in layoutRelations {
                    let multiplier: CGFloat = .random(in: 1..<5)
                    let constant: CGFloat = .random(in: 0..<20)
                    let priority: UILayoutPriority = .init(.random(in: 0..<1000))
                    planLayoutForTest.width(relation, multiplyBy: multiplier, constant: constant, priority: priority)
                    expect(planLayoutForTest.plannedConstraints.last?.firstItem as? UIView).to(equal(view))
                    expect(planLayoutForTest.plannedConstraints.last?.secondItem as? UIView).to(equal(parentView))
                    if #available(iOS 10.0, *) {
                        expect(planLayoutForTest.plannedConstraints.last?.firstAnchor).to(equal(view.widthAnchor))
                        expect(planLayoutForTest.plannedConstraints.last?.secondAnchor).to(equal(parentView.widthAnchor))
                    }
                    let multiplierDifference = abs(multiplier - planLayoutForTest.plannedConstraints.last!.multiplier)
                    expect(multiplierDifference).to(beLessThan(0.0001))
                    expect(planLayoutForTest.plannedConstraints.last?.constant).to(equal(constant))
                    expect(planLayoutForTest.plannedConstraints.last?.priority).to(equal(priority))
                    comparator(relation)
                }
            }
            it("should add dimension constraints to constant") {
                let layoutRelations: [InterRelation<CGFloat>] = [
                    .equalTo(.random(in: 1..<200)),
                    .lessThanTo(.random(in: 1..<200)),
                    .moreThanTo(.random(in: 1..<200))
                ]
                let comparator: (InterRelation<CGFloat>) -> Void = { relation in
                    switch relation {
                    case .equalTo(let dimension):
                        expect(planLayoutForTest.plannedConstraints.last?.relation).to(equal(.equal))
                        expect(planLayoutForTest.plannedConstraints.last?.constant).to(equal(dimension))
                    case .lessThanTo(let dimension):
                        expect(planLayoutForTest.plannedConstraints.last?.relation).to(equal(.lessThanOrEqual))
                        expect(planLayoutForTest.plannedConstraints.last?.constant).to(equal(dimension))
                    case .moreThanTo(let dimension):
                        expect(planLayoutForTest.plannedConstraints.last?.relation).to(equal(.greaterThanOrEqual))
                        expect(planLayoutForTest.plannedConstraints.last?.constant).to(equal(dimension))
                    }
                }
                for relation in layoutRelations {
                    let priority: UILayoutPriority = .init(.random(in: 0..<1000))
                    planLayoutForTest.height(relation, priority: priority)
                    expect(planLayoutForTest.plannedConstraints.last?.firstItem as? UIView).to(equal(view))
                    expect(planLayoutForTest.plannedConstraints.last?.secondItem).to(beNil())
                    if #available(iOS 10.0, *) {
                        expect(planLayoutForTest.plannedConstraints.last?.firstAnchor).to(equal(view.heightAnchor))
                    }
                    expect(planLayoutForTest.plannedConstraints.last?.priority).to(equal(priority))
                    comparator(relation)
                }
                for relation in layoutRelations {
                    let priority: UILayoutPriority = .init(.random(in: 0..<1000))
                    planLayoutForTest.width(relation, priority: priority)
                    expect(planLayoutForTest.plannedConstraints.last?.firstItem as? UIView).to(equal(view))
                    expect(planLayoutForTest.plannedConstraints.last?.secondItem).to(beNil())
                    if #available(iOS 10.0, *) {
                        expect(planLayoutForTest.plannedConstraints.last?.firstAnchor).to(equal(view.widthAnchor))
                    }
                    expect(planLayoutForTest.plannedConstraints.last?.priority).to(equal(priority))
                    comparator(relation)
                }
            }
        }
    }
}
