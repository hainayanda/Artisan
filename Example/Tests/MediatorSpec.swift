//
//  MediatorSpec.swift
//  NamadaLayout_Tests
//
//  Created by Nayanda Haberty (ID) on 03/09/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import Quick
import Nimble
@testable import Artisan

class MediatorSpec: QuickSpec {
    override func spec() {
        describe("view mediator behaviour") {
            var mediatorForTest: ExtendedTestableVM!
            var view: UIView!
            beforeEach {
                mediatorForTest = .init()
                view = .init()
            }
            it("should get all bindable states") {
                let viewStates = mediatorForTest.bondingStates
                expect(viewStates.count).to(equal(3))
                expect(viewStates.contains {
                    ($0 as? ViewState<UIColor?>) != nil
                }).to(beTrue())
                expect(viewStates.contains {
                    ($0 as? ViewState<CGRect>) != nil
                }).to(beTrue())
                expect(viewStates.contains {
                    ($0 as? ViewState<CGFloat?>) != nil
                }).to(beTrue())
            }
            it("should get all observables") {
                let observables = mediatorForTest.observables
                expect(observables.count).to(equal(5))
                expect(observables.contains {
                    ($0 as? ViewState<UIColor?>) != nil
                }).to(beTrue())
                expect(observables.contains {
                    ($0 as? ViewState<CGRect>) != nil
                }).to(beTrue())
                expect(observables.contains {
                    ($0 as? ViewState<CGFloat?>) != nil
                }).to(beTrue())
                expect(observables.contains {
                    ($0 as? ObservableState<String?>) != nil
                }).to(beTrue())
                expect(observables.contains {
                    ($0 as? ObservableState<NSAttributedString?>) != nil
                }).to(beTrue())
            }
            it("should binded with view") {
                expect(view.getMediator()).to(beNil())
                mediatorForTest.bonding(with: view)
                expect(view.getMediator() as? TestableVM).to(equal(mediatorForTest))
            }
            it("should unbinded with view") {
                expect(view.getMediator()).to(beNil())
                mediatorForTest.bonding(with: view)
                expect(view.getMediator() as? TestableVM).to(equal(mediatorForTest))
                mediatorForTest.removeBond()
                expect(view.getMediator()).to(beNil())
            }
            it("should run all apply lifecycle") {
                var willApplyRun: Bool = false
                mediatorForTest.willApplyingClosure = { appliedView in
                    expect(view).to(equal(view))
                    willApplyRun = true
                }
                var didApplyRun: Bool = false
                mediatorForTest.didApplyingClosure = { appliedView in
                    expect(view).to(equal(view))
                    didApplyRun = true
                }
                mediatorForTest.apply(to: view)
                expect(willApplyRun).to(beTrue())
                expect(didApplyRun).to(beTrue())
            }
            it("should run all map lifecycle") {
                var willMapped: Bool = false
                mediatorForTest.mediatorWillMappedClosure = { appliedView in
                    expect(view).to(equal(view))
                    willMapped = true
                }
                var didMapped: Bool = false
                mediatorForTest.mediatorDidMappedClosure = { appliedView in
                    expect(view).to(equal(view))
                    didMapped = true
                }
                mediatorForTest.map(from: view)
                expect(willMapped).to(beTrue())
                expect(didMapped).to(beTrue())
            }
        }
    }
}

class TestableVM: ViewMediator<UIView> {
    @ViewState var color: UIColor?
    @ViewState var frame: CGRect = .zero
    @ObservableState var text: String?
    
    var willApplyingClosure: ((UIView) -> Void)?
    override func willApplying(_ view: UIView) {
        willApplyingClosure?(view)
    }
    
    var didApplyingClosure: ((UIView) -> Void)?
    override func didApplying(_ view: UIView) {
        didApplyingClosure?(view)
    }
    
    var mediatorWillMappedClosure: ((UIView) -> Void)?
    override func mediatorWillMapped(from view: UIView) {
        mediatorWillMappedClosure?(view)
    }
    
    var mediatorDidMappedClosure: ((UIView) -> Void)?
    override func mediatorDidMapped(from view: UIView) {
        mediatorDidMappedClosure?(view)
    }
}

class ExtendedTestableVM: TestableVM {
    @ViewState var alpha: CGFloat?
    @ObservableState var attrText: NSAttributedString?
}
