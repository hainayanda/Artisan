//
//  PlanerSpec.swift
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
import Pharos
@testable import Draftsman
@testable import Artisan

class PlanerSpec: QuickSpec {
    override func spec() {
        describe("view applicator") {
            var plan: LayoutPlaner<UIView>!
            var view: UIView!
            beforeEach {
                view = .init()
                plan = .init(view: view, context: .init(currentView: view))
            }
            it("should apply view with builder") {
                var applied: Bool = false
                plan.apply {
                    expect($0).to(equal(view))
                    applied = true
                }
                expect(applied).to(beTrue())
            }
        }
    }
}
#endif
