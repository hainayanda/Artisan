//
//  ArrayBuilderSpec.swift
//  Artisan_Example
//
//  Created by Nayanda Haberty on 06/06/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Artisan

class ArrayBuilderSpec: QuickSpec {
    
    override func spec() {
        it("should build simple array") {
            @ArrayBuilder<String> var arrays: [String] {
                "one"
                "two"
                "three"
                nil
            }
            expect(arrays).to(equal(["one", "two", "three"]))
        }
        it("should build array from loop") {
            let source = ["one", "two", "three"]
            @ArrayBuilder<String> var arrays: [String] {
                for element in source {
                    element
                }
            }
            expect(arrays).to(equal(["one", "two", "three"]))
        }
        it("should build array using if condition") {
            var pickThis: Bool = true
            @ArrayBuilder<String> var arrays: [String] {
                if pickThis {
                    "one"
                    "two"
                    "three"
                    
                }
            }
            expect(arrays).to(equal(["one", "two", "three"]))
            pickThis = false
            expect(arrays).to(equal([]))
        }
        it("should build array using if else condition") {
            var pickThis: Bool = true
            @ArrayBuilder<String> var arrays: [String] {
                if pickThis {
                    "one"
                    "two"
                    "three"
                } else {
                    "four"
                    "five"
                    "six"
                }
            }
            expect(arrays).to(equal(["one", "two", "three"]))
            pickThis = false
            expect(arrays).to(equal(["four", "five", "six"]))
        }
    }
}
