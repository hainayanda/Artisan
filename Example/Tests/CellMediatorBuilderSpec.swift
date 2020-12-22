//
//  CellMediatorBuilderSpec.swift
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

class CellMediatorBuilderSpec: QuickSpec {
    override func spec() {
        describe("cell mediator builder") {
            var builder: CollectionCellBuilder!
            var firstSection: UICollectionView.Section!
            beforeEach {
                firstSection = .init(identifier: String.randomString())
                builder = .init(section: firstSection)
            }
            it("should add cell to current section") {
                var dummyItems: [String] = []
                for _ in 0 ..< Int.random(in: 50..<100) {
                    dummyItems.append(.randomString())
                }
                let result = builder
                    .next(type: DummyCollectionMediator.self, from: dummyItems) { mediator, item in
                        mediator.id = item
                }.build()
                expect(result.count).to(equal(1))
                guard let cells = result.first?.cells else {
                    fail("section did not have cells")
                    return
                }
                cells.forEach { cell in
                    guard let id = (cell as? DummyCollectionMediator)?.id else {
                        fail("cell did not have id")
                        return
                    }
                    expect(dummyItems.contains(id)).to(beTrue())
                }
            }
            it("should append new section") {
                let newSection = UICollectionView.Section(identifier: String.randomString())
                let result = builder.nextSection(newSection).build()
                expect(result.count).to(equal(2))
                expect(result.first?.sectionIdentifier).to(equal(firstSection.sectionIdentifier))
                expect(result.last?.sectionIdentifier).to(equal(newSection.sectionIdentifier))
            }
        }
        describe("table mediator builder") {
            var builder: TableCellBuilder!
            var firstSection: UITableView.Section!
            beforeEach {
                firstSection = .init(identifier: String.randomString())
                builder = .init(section: firstSection)
            }
            it("should add cell to current section") {
                var dummyItems: [String] = []
                for _ in 0 ..< Int.random(in: 50..<100) {
                    dummyItems.append(.randomString())
                }
                let result = builder
                    .next(type: DummyTableMediator.self, from: dummyItems) { mediator, item in
                        mediator.id = item
                }.build()
                expect(result.count).to(equal(1))
                guard let cells = result.first?.cells else {
                    fail("section did not have cells")
                    return
                }
                cells.forEach { cell in
                    guard let id = (cell as? DummyTableMediator)?.id else {
                        fail("cell did not have id")
                        return
                    }
                    expect(dummyItems.contains(id)).to(beTrue())
                }
            }
            it("should append new section") {
                let newSection = UITableView.Section(identifier: String.randomString())
                let result = builder.nextSection(newSection).build()
                expect(result.count).to(equal(2))
                expect(result.first?.sectionIdentifier).to(equal(firstSection.sectionIdentifier))
                expect(result.last?.sectionIdentifier).to(equal(newSection.sectionIdentifier))
            }
        }
    }
}

class DummyCollectionMediator: CollectionViewCellMediator<UICollectionViewCell> {
    var id: String?
}

class DummyTableMediator: TableViewCellMediator<UITableViewCell> {
    var id: String?
}