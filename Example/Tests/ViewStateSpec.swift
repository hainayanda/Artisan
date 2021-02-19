//
//  ViewStateSpec.swift
//  Artisan_Tests
//
//  Created by Nayanda Haberty (ID) on 04/09/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
#if canImport(UIKit)
import UIKit
import Quick
import Nimble
@testable import Artisan

class ViewStateSpec: QuickSpec {
    override func spec() {
        describe("view state property wrapper") {
            context("common") {
                var state: ViewState<UIColor?>!
                var view: UIView!
                var randomColor: UIColor!
                beforeEach {
                    randomColor = .init(
                        red: .random(in: 0..<1),
                        green: .random(in: 0..<1),
                        blue: .random(in: 0..<1),
                        alpha: .random(in: 0..<1)
                    )
                    state = .init(wrappedValue: nil)
                    view = .init()
                }
                it("should bind state with view") {
                    var triggeredByView: Bool = false
                    var triggeredByState: Bool = false
                    var currentChanges: Changes<UIColor?> = .init(new: nil, old: nil, trigger: .invoked)
                    state.bonding(with: view, \.backgroundColor)
                        .viewDidSet { view, changes in
                        currentChanges = changes
                        triggeredByView = true
                        expect(view).to(equal(view))
                    }.stateDidSet { view, changes in
                    currentChanges = changes
                        expect(view).to(equal(view))
                        triggeredByState = true
                    }
                    view.backgroundColor = randomColor
                    expect(triggeredByView).to(beTrue())
                    expect(triggeredByState).to(beFalse())
                    expect(currentChanges.old).to(beNil())
                    expect(currentChanges.new).to(equal(randomColor))
                    triggeredByView = false
                    triggeredByState = false
                    state.wrappedValue = nil
                    expect(triggeredByView).to(beFalse())
                    expect(triggeredByState).to(beTrue())
                    expect(currentChanges.old).to(equal(randomColor))
                    expect(currentChanges.new).to(beNil())
                    expect(view.backgroundColor).to(beNil())
                }
                it("should apply state to view") {
                    state.wrappedValue = randomColor
                    state.apply(into: view, \.backgroundColor)
                    expect(view.backgroundColor).to(equal(randomColor))
                }
                it("should map view to state") {
                    view.backgroundColor = randomColor
                    state.map(from: view, \.backgroundColor)
                    expect(state.wrappedValue).to(equal(randomColor))
                }
            }
            context("text field") {
                var state: ViewState<String?>!
                var textField: UITextField!
                var randomString: String!
                beforeEach {
                    randomString = .randomString()
                    state = .init(wrappedValue: nil)
                    textField = .init()
                }
                it("should bind state with view") {
                    var triggeredByView: Bool = false
                    var triggeredByState: Bool = false
                    var currentChanges: Changes<String?> = .init(new: nil, old: nil, trigger: .invoked)
                    state.bonding(with: textField, \.text)
                        .viewDidSet { view, changes in
                        currentChanges = changes
                        triggeredByView = true
                        expect(view).to(equal(textField))
                    }.stateDidSet { view, changes in
                    currentChanges = changes
                        expect(view).to(equal(textField))
                        triggeredByState = true
                    }
                    NotificationCenter.default.post(name: UITextField.textDidChangeNotification, object: textField)
                    expect(triggeredByView).to(beTrue())
                    expect(triggeredByState).to(beFalse())
                    expect(currentChanges.old).to(beNil())
                    expect(currentChanges.new).to(equal(""))
                    triggeredByView = false
                    triggeredByState = false
                    state.wrappedValue = randomString
                    expect(triggeredByView).to(beFalse())
                    expect(triggeredByState).to(beTrue())
                    expect(currentChanges.old).to(equal(""))
                    expect(currentChanges.new).to(equal(randomString))
                    expect(textField.text).to(equal(randomString))
                    
                }
                it("should apply state to view") {
                    state.wrappedValue = randomString
                    state.apply(into: textField, \.text)
                    expect(textField.text).to(equal(randomString))
                }
                it("should map view to state") {
                    textField.text = randomString
                    state.map(from: textField, \.text)
                    expect(state.wrappedValue).to(equal(randomString))
                }
            }
            context("text view") {
                var state: ViewState<String?>!
                var textView: UITextView!
                var randomString: String!
                beforeEach {
                    randomString = .randomString()
                    state = .init(wrappedValue: nil)
                    textView = .init()
                }
                it("should bind state with view") {
                    var triggeredByView: Bool = false
                    var triggeredByState: Bool = false
                    var currentChanges: Changes<String?> = .init(new: nil, old: nil, trigger: .invoked)
                    state.bonding(with: textView, \.text)
                        .viewDidSet { view, changes in
                        currentChanges = changes
                        triggeredByView = true
                        expect(view).to(equal(textView))
                    }.stateDidSet { view, changes in
                    currentChanges = changes
                        expect(view).to(equal(textView))
                        triggeredByState = true
                    }
                    NotificationCenter.default.post(name: UITextView.textDidChangeNotification, object: textView)
                    expect(triggeredByView).to(beTrue())
                    expect(triggeredByState).to(beFalse())
                    expect(currentChanges.old).to(beNil())
                    expect(currentChanges.new).to(equal(""))
                    triggeredByView = false
                    triggeredByState = false
                    state.wrappedValue = randomString
                    expect(triggeredByView).to(beFalse())
                    expect(triggeredByState).to(beTrue())
                    expect(currentChanges.old).to(equal(""))
                    expect(currentChanges.new).to(equal(randomString))
                    expect(textView.text).to(equal(randomString))
                }
                it("should apply state to view") {
                    state.wrappedValue = randomString
                    state.apply(into: textView, \.text)
                    expect(textView.text).to(equal(randomString))
                }
                it("should map view to state") {
                    textView.text = randomString
                    state.map(from: textView, \.text)
                    expect(state.wrappedValue).to(equal(randomString))
                }
            }
        }
    }
}
#endif
