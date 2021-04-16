//
//  MediatorSpec.swift
//  NamadaLayout_Tests
//
//  Created by Nayanda Haberty (ID) on 03/09/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
#if canImport(UIKit)
import UIKit
import Quick
import Nimble
import Pharos
@testable import Artisan

class MediatorSpec: QuickSpec {
    override func spec() {
        describe("view mediator behaviour") {
            var mediatorForTest: ExtendedTestableVM!
            var superView: UIView!
            var view: UIView!
            beforeEach {
                mediatorForTest = .init()
                superView = .init()
                view = .init()
                superView.addSubview(view)
            }
            it("should get all observables") {
                let observables = mediatorForTest.observables
                expect(observables.count).to(equal(5))
                expect(observables.contains {
                    ($0 as? Observable<UIColor?>) != nil
                }).to(beTrue())
                expect(observables.contains {
                    ($0 as? Observable<CGRect>) != nil
                }).to(beTrue())
                expect(observables.contains {
                    ($0 as? Observable<CGFloat?>) != nil
                }).to(beTrue())
                expect(observables.contains {
                    ($0 as? Observable<String?>) != nil
                }).to(beTrue())
            }
            it("should binded with view") {
                expect(view.getMediator()).to(beNil())
                mediatorForTest.bond(with: view)
                expect(view.getMediator() as? TestableVM).to(equal(mediatorForTest))
            }
            it("should unbinded with view") {
                expect(view.getMediator()).to(beNil())
                mediatorForTest.bond(with: view)
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
        }
    }
}

class TestableVM: ViewMediator<UIView> {
    @Observable var color: UIColor?
    @Observable var frame: CGRect = .zero
    @Observable var text: String?
    
    var willApplyingClosure: ((UIView) -> Void)?
    override func willApplying(_ view: UIView) {
        willApplyingClosure?(view)
    }
    
    var didApplyingClosure: ((UIView) -> Void)?
    override func didApplying(_ view: UIView) {
        didApplyingClosure?(view)
    }
}

class ExtendedTestableVM: TestableVM {
    @Observable var alpha: CGFloat?
    @Observable var attrText: NSAttributedString?
}
#endif
