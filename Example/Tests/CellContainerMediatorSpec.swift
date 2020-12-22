//
//  CellContainerMediatorSpec.swift
//  NamadaLayout_Tests
//
//  Created by Nayanda Haberty (ID) on 02/09/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import Quick
import Nimble
@testable import Artisan

class CellContainerMediatorSpec: QuickSpec {
    override func spec() {
        describe("collection view mediator behaviour") {
            var collectionMediator: UICollectionView.Mediator!
            var collectionView: UICollectionView!
            beforeEach {
                collectionMediator = .init()
                collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
            }
            it("should assign itself as dataSource for UICollectionView") {
                expect(collectionView.dataSource).to(beNil())
                collectionMediator.apply(to: collectionView)
                expect(collectionView.dataSource).toNot(beNil())
                expect(collectionView.dataSource as? UICollectionView.Mediator).to(equal(collectionMediator))
            }
            it("should verify linearity when old section is bigger than new") {
                var oldSections: [UICollectionView.Section] = []
                var newSections: [UICollectionView.Section] = []
                for index in 0 ..< Int.random(in: 5..<10) {
                    oldSections.append(.init(identifier: index))
                }
                for index in 0 ..< Int.random(in: 1..<oldSections.count) {
                    newSections.append(.init(identifier: index))
                }
                var count: Int = 0
                collectionMediator.verifyLinearity(
                    for: collectionView,
                    with: newSections,
                    oldSections: oldSections) { old, new, index in
                        expect(old).to(equal(new))
                        expect(index).to(beGreaterThanOrEqualTo(0))
                        expect(index).to(beLessThan(newSections.count))
                        count += 1
                }
                expect(count).to(equal(newSections.count))
            }
            it("sshould verify linearity when new section is bigger than old") {
                var oldSections: [UICollectionView.Section] = []
                var newSections: [UICollectionView.Section] = []
                for index in 0 ..< Int.random(in: 5..<10) {
                    oldSections.append(.init(identifier: index))
                }
                for index in 0 ..< Int.random(in: oldSections.count..<20) {
                    newSections.append(.init(identifier: index))
                }
                var count: Int = 0
                collectionMediator.verifyLinearity(
                    for: collectionView,
                    with: newSections,
                    oldSections: oldSections) { old, new, index in
                        expect(old).to(equal(new))
                        expect(index).to(beGreaterThanOrEqualTo(0))
                        expect(index).to(beLessThan(oldSections.count))
                        count += 1
                }
                expect(count).to(equal(oldSections.count))
            }
            it("should provide clean datasource") {
                var sections: [UICollectionView.Section] = []
                for index in 0 ..< Int.random(in: 5..<10) {
                    let section = UICollectionView.Section(identifier: index)
                    for cellIndex in 0 ..< Int.random(in: 5..<10) {
                        section.add(cell: DummyCollectionCellMediator(id: cellIndex))
                    }
                    sections.append(section)
                }
                collectionMediator.applicableSections = sections
                let sectionCount = collectionMediator.numberOfSections(in: collectionView)
                expect(sectionCount).to(equal(sections.count))
                for (index, section) in sections.enumerated() {
                    let count = collectionMediator.collectionView(collectionView, numberOfItemsInSection: index)
                    expect(count).to(equal(section.cellCount))
                }
            }
            it("should return index titles if have any") {
                var sections: [UICollectionView.Section] = []
                var expectedResult: [String] = []
                for index in 0 ..< Int.random(in: 10..<20) {
                    let titled = Bool.random()
                    if titled {
                        let title: String = .randomString()
                        expectedResult.append(title)
                        sections.append(UICollectionView.IndexedSection(indexTitle: title, identifier: index))
                    } else {
                        expectedResult.append("")
                        sections.append(UICollectionView.Section(identifier: index))
                    }
                }
                collectionMediator.applicableSections = sections
                expect(collectionMediator.indexTitles(for: collectionView)).to(equal(expectedResult))
            }
            it("should return nil for titles if do not have any") {
                var sections: [UICollectionView.Section] = []
                for index in 0 ..< Int.random(in: 10..<20) {
                    sections.append(UICollectionView.Section(identifier: index))
                }
                collectionMediator.applicableSections = sections
                expect(collectionMediator.indexTitles(for: collectionView)).to(beNil())
            }
        }
        describe("table view mediator behaviour") {
            var tableMediator: UITableView.Mediator!
            var tableView: UITableView!
            beforeEach {
                tableMediator = .init()
                tableView = .init()
            }
            it("should assign itself as dataSource for UICollectionView") {
                expect(tableView.dataSource).to(beNil())
                tableMediator.apply(to: tableView)
                expect(tableView.dataSource).toNot(beNil())
                expect(tableView.dataSource as? UITableView.Mediator).to(equal(tableMediator))
            }
            it("should verify linearity when old section is bigger than new") {
                var oldSections: [UITableView.Section] = []
                var newSections: [UITableView.Section] = []
                for index in 0 ..< Int.random(in: 5..<10) {
                    oldSections.append(.init(identifier: index))
                }
                for index in 0 ..< Int.random(in: 1..<oldSections.count) {
                    newSections.append(.init(identifier: index))
                }
                var count: Int = 0
                tableMediator.verifyLinearity(
                    for: tableView,
                    with: newSections,
                    oldSections: oldSections) { old, new, index in
                        expect(old).to(equal(new))
                        expect(index).to(beGreaterThanOrEqualTo(0))
                        expect(index).to(beLessThan(newSections.count))
                        count += 1
                }
                expect(count).to(equal(newSections.count))
            }
            it("should verify linearity when new section is bigger than old") {
                var oldSections: [UITableView.Section] = []
                var newSections: [UITableView.Section] = []
                for index in 0 ..< Int.random(in: 5..<10) {
                    oldSections.append(.init(identifier: index))
                }
                for index in 0 ..< Int.random(in: oldSections.count..<20) {
                    newSections.append(.init(identifier: index))
                }
                var count: Int = 0
                tableMediator.verifyLinearity(
                    for: tableView,
                    with: newSections,
                    oldSections: oldSections) { old, new, index in
                        expect(old).to(equal(new))
                        expect(index).to(beGreaterThanOrEqualTo(0))
                        expect(index).to(beLessThan(oldSections.count))
                        count += 1
                }
                expect(count).to(equal(oldSections.count))
            }
            it("should generate differences") {
                let start = Int.random(in: 0..<5)
                let end = Int.random(in: 5..<10)
                let section = Int.random(in: 0..<5)
                let differences = tableMediator.getIndexPath(from: start, to: end, section: section)
                expect(differences.count).to(equal(end - start))
                for difference in differences {
                    expect(difference.section).to(equal(section))
                    expect(difference.row).to(beLessThan(end + 1))
                    expect(difference.row).to(beGreaterThan(start - 1))
                }
            }
            it("should provide clean datasource") {
                var sections: [UITableView.Section] = []
                for index in 0 ..< Int.random(in: 5..<10) {
                    let section = UITableView.Section(identifier: index)
                    for cellIndex in 0 ..< Int.random(in: 5..<10) {
                        section.add(cell: DummyTableCell(id: cellIndex))
                    }
                    sections.append(section)
                }
                tableMediator.applicableSections = sections
                let sectionCount = tableMediator.numberOfSections(in: tableView)
                expect(sectionCount).to(equal(sections.count))
                for (index, section) in sections.enumerated() {
                    let count = tableMediator.tableView(tableView, numberOfRowsInSection: index)
                    expect(count).to(equal(section.cellCount))
                }
            }
            it("should return index titles if have any") {
                var sections: [UITableView.Section] = []
                var expectedResult: [String] = []
                for index in 0 ..< Int.random(in: 10..<20) {
                    let titled = Bool.random()
                    if titled {
                        let title: String = .randomString()
                        expectedResult.append(String(title.first!))
                        sections.append(UITableView.TitledSection(title: title, identifier: index))
                    } else {
                        expectedResult.append("")
                        sections.append(UITableView.Section(identifier: index))
                    }
                }
                tableMediator.applicableSections = sections
                expect(tableMediator.sectionIndexTitles(for: tableView)).to(equal(expectedResult))
            }
            it("should return nil for titles if do not have any") {
                var sections: [UITableView.Section] = []
                for index in 0 ..< Int.random(in: 10..<20) {
                    sections.append(UITableView.Section(identifier: index))
                }
                tableMediator.applicableSections = sections
                expect(tableMediator.sectionIndexTitles(for: tableView)).to(beNil())
            }
        }
    }
}

class DummyCollectionCellMediator: CollectionCellMediator {
    var id: String = .randomString()
    static var cellViewClass: AnyClass = UICollectionReusableView.self
    static var cellReuseIdentifier: String = .randomString()
    
    required init() { }
    
    public init(id: Int) {
        self.id = "\(id)"
    }
    
    func apply(cell: UICollectionReusableView) { }
    
    func isSameMediator(with other: CellMediator) -> Bool {
        id == (other as? DummyCollectionCellMediator)?.id
    }
}

class DummyTableCell: TableCellMediator {
    var id: String = .randomString()
    static var cellViewClass: AnyClass = UITableViewCell.self
    static var cellReuseIdentifier: String = .randomString()
    
    required init() { }
    
    public init(id: Int) {
        self.id = "\(id)"
    }
    
    func apply(cell: UITableViewCell) { }
    
    func isSameMediator(with other: CellMediator) -> Bool {
        id == (other as? DummyCollectionCellMediator)?.id
    }
}
