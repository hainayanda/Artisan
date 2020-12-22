//
//  PlanContext.swift
//  Artisan_Tests
//
//  Created by Nayanda Haberty (ID) on 05/09/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import Quick
import Nimble
@testable import Artisan

class PlanContextSpec: QuickSpec {
    override func spec() {
        describe("plan context") {
            var context: PlanContext!
            beforeEach {
                context = .init(currentView: UIView())
            }
            it("should mutating priority") {
                let currentPriority = context.currentPriority.rawValue
                let mutatedPriority = context.mutatingPriority.rawValue
                expect(mutatedPriority).to(equal(currentPriority - 1))
                expect(context.currentPriority.rawValue).to(equal(mutatedPriority))
            }
        }
    }
}
