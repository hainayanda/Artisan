//
//  CellViewMediatorSpec.swift
//  Artisan_Tests
//
//  Created by Nayanda Haberty (ID) on 02/09/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import Quick
import Nimble
@testable import Artisan

class CellMediatorSpec: QuickSpec {
    override func spec() {
        describe("table view model") {
            var testableTMediator: TableViewCellMediator<UITableViewCell>!
            beforeEach {
                testableTMediator = .init()
            }
            it("should have cell reuse identifier base on class name") {
                expect(TableViewCellMediator<UITableViewCell>.cellReuseIdentifier).to(equal("artisan_managed_cell_ui_table_view_cell"))
            }
            it("should generate cell identifier") {
                expect(testableTMediator.cellIdentifier as? String).toNot(beNil())
            }
            it("should check same model") {
                expect(testableTMediator.isSameMediator(with: testableTMediator)).to(beTrue())
                let otherTMediator: TableViewCellMediator<UITableViewCell> = .init()
                otherTMediator.cellIdentifier = testableTMediator.cellIdentifier
                expect(testableTMediator.isSameMediator(with: otherTMediator)).to(beTrue())
                expect(testableTMediator.isNotSameMediator(with: otherTMediator)).to(beFalse())
            }
            it("should know different model") {
                let otherTMediator: TableViewCellMediator<UITableViewCell> = .init()
                while otherTMediator.cellIdentifier == testableTMediator.cellIdentifier {
                    otherTMediator.cellIdentifier = String.randomString()
                }
                expect(testableTMediator.isSameMediator(with: otherTMediator)).to(beFalse())
                expect(testableTMediator.isNotSameMediator(with: otherTMediator)).to(beTrue())
            }
            it("should know different model class") {
                let otherCMediator: CollectionViewCellMediator<UICollectionViewCell> = .init()
                expect(testableTMediator.isSameMediator(with: otherCMediator)).to(beFalse())
                expect(testableTMediator.isNotSameMediator(with: otherCMediator)).to(beTrue())
            }
        }
        describe("collection view model") {
            var testableCMediator: CollectionViewCellMediator<UICollectionViewCell>!
            beforeEach {
                testableCMediator = .init()
            }
            it("should have cell reuse identifier base on class name") {
                expect(CollectionViewCellMediator<UICollectionViewCell>.cellReuseIdentifier).to(equal("artisan_managed_cell_ui_collection_view_cell"))
            }
            it("should generate cell identifier") {
                expect(testableCMediator.cellIdentifier as? String).toNot(beNil())
            }
            it("should check same model") {
                expect(testableCMediator.isSameMediator(with: testableCMediator)).to(beTrue())
                let otherCMediator: CollectionViewCellMediator<UICollectionViewCell> = .init()
                otherCMediator.cellIdentifier = testableCMediator.cellIdentifier
                expect(testableCMediator.isSameMediator(with: otherCMediator)).to(beTrue())
                expect(testableCMediator.isNotSameMediator(with: otherCMediator)).to(beFalse())
            }
            it("should know different model") {
                let otherCMediator: CollectionViewCellMediator<UICollectionViewCell> = .init()
                while otherCMediator.cellIdentifier == testableCMediator.cellIdentifier {
                    otherCMediator.cellIdentifier = String.randomString()
                }
                expect(testableCMediator.isSameMediator(with: otherCMediator)).to(beFalse())
                expect(testableCMediator.isNotSameMediator(with: otherCMediator)).to(beTrue())
            }
            it("should know different model class") {
                let otherTMediator: TableViewCellMediator<UITableViewCell> = .init()
                expect(testableCMediator.isSameMediator(with: otherTMediator)).to(beFalse())
                expect(testableCMediator.isNotSameMediator(with: otherTMediator)).to(beTrue())
            }
        }
    }
}
