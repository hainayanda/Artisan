//
//  CellContainerMediatorSpec.swift
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

class CellContainerMediatorSpec: QuickSpec {
    override func spec() {
        describe("collection view mediator behaviour") {
            var superView: UIView!
            var collectionMediator: UICollectionView.Mediator!
            var collectionView: UICollectionView!
            beforeEach {
                superView = .init()
                collectionMediator = .init()
                collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
                superView.addSubview(collectionView)
            }
            it("should assign itself as dataSource for UICollectionView") {
                expect(collectionView.dataSource).to(beNil())
                collectionMediator.apply(to: collectionView)
                expect(collectionView.dataSource).toNot(beNil())
                expect(collectionView.dataSource as? UICollectionView.Mediator).to(equal(collectionMediator))
            }
            it("should provide clean datasource") {
                var sections: [CollectionSection] = []
                for index in 0 ..< Int.random(in: 5..<10) {
                    let section = CollectionSection(identifier: index)
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
                var sections: [CollectionSection] = []
                var expectedResult: [String] = []
                for index in 0 ..< Int.random(in: 10..<20) {
                    let titled = Bool.random()
                    if titled {
                        let title: String = .randomString()
                        expectedResult.append(title)
                        sections.append(CollectionSection(identifier: index, index: title))
                    } else {
                        expectedResult.append("")
                        sections.append(CollectionSection(identifier: index))
                    }
                }
                collectionMediator.applicableSections = sections
                expect(collectionMediator.indexTitles(for: collectionView)).to(equal(expectedResult))
            }
            it("should return nil for titles if do not have any") {
                var sections: [CollectionSection] = []
                for index in 0 ..< Int.random(in: 10..<20) {
                    sections.append(CollectionSection(identifier: index))
                }
                collectionMediator.applicableSections = sections
                expect(collectionMediator.indexTitles(for: collectionView)).to(beNil())
            }
        }
        describe("table view mediator behaviour") {
            var superView: UIView!
            var tableMediator: UITableView.Mediator!
            var tableView: UITableView!
            beforeEach {
                superView = .init()
                tableMediator = .init()
                tableView = .init()
                superView.addSubview(tableView)
            }
            it("should assign itself as dataSource for UICollectionView") {
                expect(tableView.dataSource).to(beNil())
                tableMediator.apply(to: tableView)
                expect(tableView.dataSource).toNot(beNil())
                expect(tableView.dataSource as? UITableView.Mediator).to(equal(tableMediator))
            }
            it("should provide clean datasource") {
                var sections: [TableSection] = []
                for index in 0 ..< Int.random(in: 5..<10) {
                    let section = TableSection(identifier: index)
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
                var sections: [TableSection] = []
                var expectedResult: [String] = []
                for index in 0 ..< Int.random(in: 10..<20) {
                    let titled = Bool.random()
                    if titled {
                        let title: String = .randomString()
                        expectedResult.append(String(title.first!))
                        sections.append(TableTitledSection(title: title, identifier: index, index: String(title.first!)))
                    } else {
                        expectedResult.append("")
                        sections.append(TableSection(identifier: index))
                    }
                }
                tableMediator.applicableSections = sections
                expect(tableMediator.sectionIndexTitles(for: tableView)).to(equal(expectedResult))
            }
            it("should return nil for titles if do not have any") {
                var sections: [TableSection] = []
                for index in 0 ..< Int.random(in: 10..<20) {
                    sections.append(TableSection(identifier: index))
                }
                tableMediator.applicableSections = sections
                expect(tableMediator.sectionIndexTitles(for: tableView)).to(beNil())
            }
        }
    }
}

class DummyCollectionCellMediator: AnyCollectionCellMediator {
    var id: String = .randomString()
    var distinctIdentifier: AnyHashable {
        get {
            id
        }
        set {
            id = newValue as? String ?? "\(newValue)"
        }
    }
    var compatible: Bool = true
    static var cellViewClass: AnyClass = UICollectionReusableView.self
    static var cellReuseIdentifier: String = .randomString()
    
    required init() { }
    
    public init(id: Int) {
        self.id = "\(id)"
    }
    
    func apply(cell: UICollectionReusableView) { }
    
    func isSame(with other: CellMediator) -> Bool {
        id == (other as? DummyCollectionCellMediator)?.id
    }


    func customCellSize(for collectionContentSize: CGSize) -> CGSize {
        .automatic
    }

    func defaultCellSize(for collectionContentSize: CGSize) -> CGSize {
        .automatic
    }

    func didTap(cell: UICollectionReusableView) { }

    func isCompatible<CellType>(with cell: CellType) -> Bool where CellType : UIView {
        compatible
    }
    
    func removeBond() {
        bondDidRemoved()
    }
    
    func bondDidRemoved() { }
    
    func generateCellMediators() -> [AnyCollectionCellMediator] {
        [self]
    }
}

class DummyTableCell: AnyTableCellMediator {
    
    var id: String = .randomString()
    var index: String?
    var distinctIdentifier: AnyHashable {
        get {
            id
        }
        set {
            id = newValue as? String ?? "\(newValue)"
        }
    }
    var compatible: Bool = true
    static var cellViewClass: AnyClass = UITableViewCell.self
    static var cellReuseIdentifier: String = .randomString()
    
    required init() { }
    
    public init(id: Int) {
        self.id = "\(id)"
    }
    
    func apply(cell: UITableViewCell) { }
    
    func isSame(with other: CellMediator) -> Bool {
        id == (other as? DummyCollectionCellMediator)?.id
    }
    
    func customCellHeight(for cellWidth: CGFloat) -> CGFloat {
        .automatic
    }
    
    func defaultCellHeight(for cellWidth: CGFloat) -> CGFloat {
        .automatic
    }
    
    func didTap(cell: UITableViewCell) { }
    
    func isCompatible<CellType>(with cell: CellType) -> Bool where CellType : UIView {
        compatible
    }
    
    func removeBond() {
        bondDidRemoved()
    }
    
    func bondDidRemoved() { }
    
    func generateCellMediators() -> [AnyTableCellMediator] {
        [self]
    }
    
}
#endif
