//
//  CellViewMediatorSpec.swift
//  Artisan_Tests
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

class CellMediatorSpec: QuickSpec {
    override func spec() {
        describe("table view model") {
            var testableTMediator: TableCellMediator<UITableViewCell>!
            beforeEach {
                testableTMediator = .init()
            }
            it("should have cell reuse identifier base on class name") {
                expect(TableCellMediator<UITableViewCell>.cellReuseIdentifier).to(equal("artisan_managed_cell_ui_table_view_cell"))
            }
            it("should generate cell identifier") {
                expect(testableTMediator.distinctIdentifier as? String).toNot(beNil())
            }
            it("should check same model") {
                expect(testableTMediator.isSame(with: testableTMediator)).to(beTrue())
                let otherTMediator: TableCellMediator<UITableViewCell> = .init()
                otherTMediator.distinctIdentifier = testableTMediator.distinctIdentifier
                expect(testableTMediator.isSame(with: otherTMediator)).to(beTrue())
                expect(testableTMediator.isNotSame(with: otherTMediator)).to(beFalse())
            }
            it("should know different model") {
                let otherTMediator: TableCellMediator<UITableViewCell> = .init()
                while otherTMediator.distinctIdentifier == testableTMediator.distinctIdentifier {
                    otherTMediator.distinctIdentifier = String.randomString()
                }
                expect(testableTMediator.isSame(with: otherTMediator)).to(beFalse())
                expect(testableTMediator.isNotSame(with: otherTMediator)).to(beTrue())
            }
            it("should know different model class") {
                let otherCMediator: CollectionCellMediator<UICollectionViewCell> = .init()
                expect(testableTMediator.isSame(with: otherCMediator)).to(beFalse())
                expect(testableTMediator.isNotSame(with: otherCMediator)).to(beTrue())
            }
        }
        describe("collection view model") {
            var testableCMediator: CollectionCellMediator<UICollectionViewCell>!
            beforeEach {
                testableCMediator = .init()
            }
            it("should have cell reuse identifier base on class name") {
                expect(CollectionCellMediator<UICollectionViewCell>.cellReuseIdentifier).to(equal("artisan_managed_cell_ui_collection_view_cell"))
            }
            it("should generate cell identifier") {
                expect(testableCMediator.distinctIdentifier as? String).toNot(beNil())
            }
            it("should check same model") {
                expect(testableCMediator.isSame(with: testableCMediator)).to(beTrue())
                let otherCMediator: CollectionCellMediator<UICollectionViewCell> = .init()
                otherCMediator.distinctIdentifier = testableCMediator.distinctIdentifier
                expect(testableCMediator.isSame(with: otherCMediator)).to(beTrue())
                expect(testableCMediator.isNotSame(with: otherCMediator)).to(beFalse())
            }
            it("should know different model") {
                let otherCMediator: CollectionCellMediator<UICollectionViewCell> = .init()
                while otherCMediator.distinctIdentifier == testableCMediator.distinctIdentifier {
                    otherCMediator.distinctIdentifier = String.randomString()
                }
                expect(testableCMediator.isSame(with: otherCMediator)).to(beFalse())
                expect(testableCMediator.isNotSame(with: otherCMediator)).to(beTrue())
            }
            it("should know different model class") {
                let otherTMediator: TableCellMediator<UITableViewCell> = .init()
                expect(testableCMediator.isSame(with: otherTMediator)).to(beFalse())
                expect(testableCMediator.isNotSame(with: otherTMediator)).to(beTrue())
            }
        }
    }
}
#endif
