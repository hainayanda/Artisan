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
                expect(testableTMediator.cellIdentifier as? String).toNot(beNil())
            }
            it("should check same model") {
                expect(testableTMediator.isSameMediator(with: testableTMediator)).to(beTrue())
                let otherTMediator: TableCellMediator<UITableViewCell> = .init()
                otherTMediator.cellIdentifier = testableTMediator.cellIdentifier
                expect(testableTMediator.isSameMediator(with: otherTMediator)).to(beTrue())
                expect(testableTMediator.isNotSameMediator(with: otherTMediator)).to(beFalse())
            }
            it("should know different model") {
                let otherTMediator: TableCellMediator<UITableViewCell> = .init()
                while otherTMediator.cellIdentifier == testableTMediator.cellIdentifier {
                    otherTMediator.cellIdentifier = String.randomString()
                }
                expect(testableTMediator.isSameMediator(with: otherTMediator)).to(beFalse())
                expect(testableTMediator.isNotSameMediator(with: otherTMediator)).to(beTrue())
            }
            it("should know different model class") {
                let otherCMediator: CollectionCellMediator<UICollectionViewCell> = .init()
                expect(testableTMediator.isSameMediator(with: otherCMediator)).to(beFalse())
                expect(testableTMediator.isNotSameMediator(with: otherCMediator)).to(beTrue())
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
                expect(testableCMediator.cellIdentifier as? String).toNot(beNil())
            }
            it("should check same model") {
                expect(testableCMediator.isSameMediator(with: testableCMediator)).to(beTrue())
                let otherCMediator: CollectionCellMediator<UICollectionViewCell> = .init()
                otherCMediator.cellIdentifier = testableCMediator.cellIdentifier
                expect(testableCMediator.isSameMediator(with: otherCMediator)).to(beTrue())
                expect(testableCMediator.isNotSameMediator(with: otherCMediator)).to(beFalse())
            }
            it("should know different model") {
                let otherCMediator: CollectionCellMediator<UICollectionViewCell> = .init()
                while otherCMediator.cellIdentifier == testableCMediator.cellIdentifier {
                    otherCMediator.cellIdentifier = String.randomString()
                }
                expect(testableCMediator.isSameMediator(with: otherCMediator)).to(beFalse())
                expect(testableCMediator.isNotSameMediator(with: otherCMediator)).to(beTrue())
            }
            it("should know different model class") {
                let otherTMediator: TableCellMediator<UITableViewCell> = .init()
                expect(testableCMediator.isSameMediator(with: otherTMediator)).to(beFalse())
                expect(testableCMediator.isNotSameMediator(with: otherTMediator)).to(beTrue())
            }
        }
    }
}
#endif
