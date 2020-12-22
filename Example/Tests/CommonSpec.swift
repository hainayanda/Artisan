//
//  CommonSpec.swift
//  Artisan_Tests
//
//  Created by Nayanda Haberty (ID) on 03/09/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import Quick
import Nimble
@testable import Artisan

class CommonSpec: QuickSpec {
    override func spec() {
        describe("string") {
            it("should convert camel case to snake case") {
                let camelCase = "thisIsCamelCase"
                expect(camelCase.camelCaseToSnakeCase()).to(equal("this_is_camel_case"))
            }
        }
    }
}
