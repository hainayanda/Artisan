//
//  ObservableStateSpec.swift
//  Artisan_Tests
//
//  Created by Nayanda Haberty (ID) on 04/09/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import Quick
import Nimble
@testable import Artisan

class ObservableStateSpec: QuickSpec {
    override func spec() {
        describe("observable state property wrapper") {
            context("strong observables") {
                var initialValue: String!
                var observables: ObservableState<String>!
                var observer: NSObject!
                beforeEach {
                    initialValue = .randomString(length: 9)
                    observables = .init(wrappedValue: initialValue)
                    observer = .init()
                }
                it("should notify all observers on set") {
                    let newValue: String = .randomString()
                    var willSetNotified: Bool = false
                    var didSetNotified: Bool = false
                    observables.observe(observer: observer)
                        .willSet { notifiedObserver, changes in
                            expect(notifiedObserver).to(equal(observer))
                            expect(changes.old).to(equal(initialValue))
                            expect(changes.new).to(equal(newValue))
                            willSetNotified = true
                    }.didSet { notifiedObserver, changes in
                        expect(notifiedObserver).to(equal(observer))
                        expect(changes.old).to(equal(initialValue))
                        expect(changes.new).to(equal(newValue))
                        didSetNotified = true
                    }
                    observables.wrappedValue = newValue
                    expect(willSetNotified).toEventually(beTrue())
                    expect(didSetNotified).toEventually(beTrue())
                }
                it("should only notify when state changing") {
                    let newValue: String = .randomString(length: 10)
                    var willSetNotified: Bool = false
                    var didSetNotified: Bool = false
                    observables.observe(observer: observer)
                        .willUniqueSet { notifiedObserver, changes in
                            expect(notifiedObserver).to(equal(observer))
                            expect(changes.old).to(equal(initialValue))
                            expect(changes.new).to(equal(newValue))
                            expect(changes.new).toNot(equal(changes.old))
                            willSetNotified = true
                    }.didUniqueSet { notifiedObserver, changes in
                        expect(notifiedObserver).to(equal(observer))
                        expect(changes.old).to(equal(initialValue))
                        expect(changes.new).to(equal(newValue))
                        expect(changes.new).toNot(equal(changes.old))
                        didSetNotified = true
                    }
                    observables.wrappedValue = initialValue
                    expect(willSetNotified).toEventually(beFalse())
                    expect(didSetNotified).toEventually(beFalse())
                    observables.wrappedValue = newValue
                    expect(willSetNotified).toEventually(beTrue())
                    expect(didSetNotified).toEventually(beTrue())
                }
                it("should notify all observers on get") {
                    var willGetNotified: Bool = false
                    var didGetNotified: Bool = false
                    observables.observe(observer: observer)
                        .willGet { notifiedObserver, value in
                            expect(notifiedObserver).to(equal(observer))
                            expect(value).to(equal(initialValue))
                            willGetNotified = true
                    }.didGet { notifiedObserver, value in
                        expect(notifiedObserver).to(equal(observer))
                        expect(value).to(equal(initialValue))
                        didGetNotified = true
                    }
                    let _ = observables.wrappedValue
                    expect(willGetNotified).toEventually(beTrue())
                    expect(didGetNotified).toEventually(beTrue())
                }
                it("should delayed") {
                    let newValue1: String = .randomString()
                    let newValue2: String = .randomString()
                    var willSetCount: Int = 0
                    var didSetCount: Int = 0
                    observables.observe(observer: observer)
                        .willSet { notifiedObserver, changes in
                            expect(notifiedObserver).to(equal(observer))
                            willSetCount += 1
                    }.didSet { notifiedObserver, changes in
                        expect(notifiedObserver).to(equal(observer))
                        didSetCount += 1
                    }.delayMultipleSetTrigger(by: 0.5)
                    observables.wrappedValue = newValue1
                    expect(willSetCount).to(equal(1))
                    expect(didSetCount).to(beLessThan(1))
                    expect(didSetCount).toEventually(equal(1))
                    observables.wrappedValue = newValue2
                    expect(willSetCount).to(equal(2))
                    expect(didSetCount).to(beLessThan(2))
                    expect(didSetCount).toEventually(equal(2), pollInterval: .milliseconds(50))
                }
            }
            context("weak observables") {
                var observables: WeakObservableState<DummyWeakObject>!
                beforeEach {
                    observables = .init(wrappedValue: nil)
                }
                it("should release unretained object") {
                    observables.wrappedValue = .init(text: .randomString())
                    expect(observables.wrappedValue).to(beNil())
                }
            }
        }
    }
}

class DummyWeakObject: Equatable {
    static func == (lhs: DummyWeakObject, rhs: DummyWeakObject) -> Bool {
        lhs.text == rhs.text
    }
    
    var text: String
    
    init(text: String) {
        self.text = text
    }
}
