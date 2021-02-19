//
//  CellFragmentSpec.swift
//  NamadaLayout_Tests
//
//  Created by Nayanda Haberty (ID) on 02/09/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
#if canImport(UIKit)
import UIKit
import Quick
import Nimble
@testable import Artisan

class CellContainerSpec: QuickSpec {
    override func spec() {
        describe("collection view behaviour") {
            var collectionForTest: UICollectionView!
            beforeEach {
                collectionForTest = .init(frame: .zero, collectionViewLayout: .init())
            }
            it("should generate mediator and auto bind if dont have any") {
                expect(collectionForTest.getMediator()).to(beNil())
                let mediator = collectionForTest.mediator
                let bindedMediator = collectionForTest.getMediator()
                expect(bindedMediator).toNot(beNil())
                expect(bindedMediator as? UICollectionView.Mediator).to(equal(mediator))
            }
            it("should create section if cell assigned") {
                expect(collectionForTest.sections.isEmpty).to(beTrue())
                collectionForTest.cells = []
                expect(collectionForTest.sections.count).to(equal(1))
            }
        }
        describe("table view behaviour") {
            var tableForTest: UITableView!
            beforeEach {
                tableForTest = .init()
            }
            it("should generate mediator and auto bind if dont have any") {
                expect(tableForTest.getMediator()).to(beNil())
                let mediator = tableForTest.mediator
                let bindedMediator = tableForTest.getMediator()
                expect(bindedMediator).toNot(beNil())
                expect(bindedMediator as? UITableView.Mediator).to(equal(mediator))
            }
            it("should create section if cell assigned") {
                expect(tableForTest.sections.isEmpty).to(beTrue())
                tableForTest.cells = []
                expect(tableForTest.sections.count).to(equal(1))
            }
        }
    }
}
#endif
