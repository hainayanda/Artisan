//
//  UITableView+Mediator.swift
//  Artisan
//
//  Created by Nayanda Haberty (ID) on 12/08/20.
//

import Foundation
import UIKit

public typealias TableSection = UITableView.Section
public typealias TableTitledSection = UITableView.TitledSection

extension UITableView {
    
    public var mediator: UITableView.Mediator {
        if let mediator = getMediator() as? UITableView.Mediator {
            return mediator
        }
        let mediator = Mediator()
        mediator.apply(to: self)
        return mediator
    }
    
    public var sections: [Section] {
        get {
            mediator.sections
        }
        set {
            mediator.sections = newValue
        }
    }
    
    public var cells: [AnyTableCellMediator] {
        get {
            mediator.sections.first?.cells ?? []
        }
        set {
            let section = Section(identifier: "single_section", cells: newValue)
            mediator.sections = [section]
        }
    }
    
    public var animationSet: AnimationSet {
        get {
            mediator.animationSet
        }
        set {
            mediator.animationSet = newValue
        }
    }
    
    public var reloadStrategy: CellReloadStrategy {
        get {
            mediator.reloadStrategy
        }
        set {
            mediator.reloadStrategy = newValue
        }
    }
    
    public func cellHeightFromMediator(at indexPath: IndexPath) -> CGFloat {
        let width: CGFloat = contentSize.width - contentInset.horizontal.both
        guard let cell = sections[safe: indexPath.section]?.cells[safe: indexPath.item] else { return .automatic }
        let customCellHeight = cell.customCellHeight(for: width)
        let defaultHeight = cell.defaultCellHeight(for: width)
        return customCellHeight.isCalculated ? customCellHeight : defaultHeight
    }
    
    public func appendWithCell(_ builder: (TableCellBuilder) -> Void) {
        guard !sections.isEmpty else {
            buildWithCells(builder)
            return
        }
        let collectionBuilder = TableCellBuilder(sections: sections)
        builder(collectionBuilder)
        sections = collectionBuilder.build()
    }
    
    public func buildWithCells(withFirstSectionId firstSection: String, _ builder: (TableCellBuilder) -> Void) {
        buildWithCells(withFirstSection: Section(identifier: firstSection), builder)
    }
    
    public func buildWithCells(withFirstSection firstSection: UITableView.Section? = nil, _ builder: (TableCellBuilder) -> Void) {
        let collectionBuilder = TableCellBuilder(section: firstSection ?? Section(identifier: "first_section"))
        builder(collectionBuilder)
        sections = collectionBuilder.build()
    }
    
    public func whenDidReloadCells(then: ((Bool) -> Void)?) {
        mediator.whenDidReloadCells(then: then)
    }
    
    public struct AnimationSet {
        public let insertRowAnimation: UITableView.RowAnimation
        public let reloadRowAnimation: UITableView.RowAnimation
        public let deleteRowAnimation: UITableView.RowAnimation
        public let insertSectionAnimation: UITableView.RowAnimation
        public let deleteSectionAnimation: UITableView.RowAnimation
        
        public init(insertRowAnimation: UITableView.RowAnimation = .left,
                    reloadRowAnimation: UITableView.RowAnimation = .fade,
                    deleteRowAnimation: UITableView.RowAnimation = .left,
                    insertSectionAnimation: UITableView.RowAnimation = .top,
                    deleteSectionAnimation: UITableView.RowAnimation = .top) {
            self.insertRowAnimation = insertRowAnimation
            self.reloadRowAnimation = reloadRowAnimation
            self.deleteRowAnimation = deleteRowAnimation
            self.insertSectionAnimation = insertSectionAnimation
            self.deleteSectionAnimation = deleteSectionAnimation
        }
        
        public init(insertAnimation: UITableView.RowAnimation,
                    reloadAnimation: UITableView.RowAnimation,
                    deleteAnimation: UITableView.RowAnimation) {
            self.insertRowAnimation = insertAnimation
            self.reloadRowAnimation = reloadAnimation
            self.deleteRowAnimation = deleteAnimation
            self.insertSectionAnimation = insertAnimation
            self.deleteSectionAnimation = deleteAnimation
        }
    }
    
    public class Mediator: ViewMediator<UITableView> {
        var tapGestureRecognizer: UITapGestureRecognizer = build(UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))) {
            $0.numberOfTouchesRequired = 1
            $0.isEnabled = true
            $0.cancelsTouchesInView = false
        }
        var applicableSections: [Section] = []
        @ObservableState public var sections: [Section] = []
        public var animationSet: UITableView.AnimationSet = .init()
        public var reloadStrategy: CellReloadStrategy = .reloadArrangementDifference
        var didReloadAction: ((Bool) -> Void)?
        
        public override func bonding(with view: UITableView) {
            super.bonding(with: view)
            $sections.observe(observer: self, on: .main, syncIfPossible: false).didSet { mediator, changes  in
                guard let table = mediator.view else { return }
                let newSection = changes.new
                table.registerNewCell(from: newSection)
                let oldSection = mediator.applicableSections
                mediator.applicableSections = newSection
                mediator.reload(table, with: newSection, oldSections: oldSection, completion: mediator.didReloadAction)
            }
        }
        
        public func whenDidReloadCells(then: ((Bool) -> Void)?) {
            didReloadAction = then
        }
        
        public override func didApplying(_ view: UITableView) {
            view.dataSource = self
            view.addGestureRecognizer(tapGestureRecognizer)
        }
        
        @objc public func didTap(_ gesture: UITapGestureRecognizer) {
            guard let table = view else { return }
            let location = gesture.location(in: table)
            guard let indexPath = table.indexPathForRow(at: location),
                  let cell = table.cellForRow(at: indexPath),
                  let mediator = cell.getMediator() as? AnyTableCellMediator else {
                return
            }
            mediator.didTap(cell: cell)
        }
    }
    
    open class Section: Identifiable, Equatable {
        public var index: String?
        public var cells: [AnyTableCellMediator]
        public var cellCount: Int { cells.count }
        public var identifier: AnyHashable
        
        public init(identifier: AnyHashable = String.randomString(), index: String? = nil, cells: [AnyTableCellMediator] = []) {
            self.identifier = identifier
            self.cells = cells
            self.index = index
        }
        
        public func add(cell: AnyTableCellMediator) {
            cells.append(cell)
        }
        
        public func add(cells: [AnyTableCellMediator]) {
            self.cells.append(contentsOf: cells)
        }
        
        func isSameSection(with other: Section) -> Bool {
            if other === self { return true }
            return other.identifier == identifier
        }
        
        public func clear() {
            cells.removeAll()
        }
        
        public func copy() -> Section {
            return Section(identifier: identifier, cells: cells)
        }
        
        public static func == (lhs: UITableView.Section, rhs: UITableView.Section) -> Bool {
            let left = lhs.copy()
            let right = rhs.copy()
            guard left.identifier == right.identifier,
                  left.cells.count == right.cells.count else { return false }
            for (index, cell) in left.cells.enumerated() where !right.cells[index].isSameMediator(with: cell) {
                return false
            }
            return true
        }
    }
    
    public class TitledSection: Section {
        
        public var title: String
        
        public init(title: String, identifier: AnyHashable = String.randomString(), index: String? = nil, cells: [AnyTableCellMediator] = []) {
            self.title = title
            super.init(identifier: identifier, index: index, cells: cells)
        }
        
        public override func copy() -> Section {
            return TitledSection(title: title, identifier: identifier, cells: cells)
        }
        
        public static func == (lhs: UITableView.TitledSection, rhs: UITableView.TitledSection) -> Bool {
            guard let left = lhs.copy() as? UITableView.TitledSection,
                  let right = rhs.copy() as? UITableView.TitledSection else {
                return false
            }
            guard left.identifier == right.identifier,
                  left.title == right.title,
                  left.cells.count == right.cells.count else { return false }
            for (index, cell) in left.cells.enumerated() where !right.cells[index].isSameMediator(with: cell) {
                return false
            }
            return true
        }
    }
}

extension UITableView {
    
    func registerNewCell(from sections: [UITableView.Section]) {
        var registeredCells: [String] = []
        for section in sections {
            for cell in section.cells where !registeredCells.contains(cell.reuseIdentifier) {
                self.register(cell.cellClass, forCellReuseIdentifier: cell.reuseIdentifier)
                registeredCells.append(cell.reuseIdentifier)
            }
        }
    }
}

extension UITableView.Mediator: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.applicableSections[safe: section]?.cellCount ?? 0
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        self.applicableSections.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = self.applicableSections[safe: indexPath.section],
              let cellMediator = section.cells[safe: indexPath.item]
        else { return .init() }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellMediator.reuseIdentifier, for: indexPath)
        cellMediator.apply(cell: cell)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = applicableSections[safe: section] as? UITableView.TitledSection else {
            return nil
        }
        return section.title
    }
    
    public func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        var titles: [String] = []
        var titleCount: Int = 0
        self.applicableSections.forEach {
            if let index = $0.index {
                titleCount += 1
                titles.append(String(index))
            } else {
                titles.append("")
            }
        }
        guard titleCount > 0 else { return nil }
        return titles
    }
}

