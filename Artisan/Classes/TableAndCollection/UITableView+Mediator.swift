//
//  UITableView+Mediator.swift
//  Artisan
//
//  Created by Nayanda Haberty on 16/04/21.
//

import Foundation
#if canImport(UIKit)
import UIKit
import Draftsman
import Pharos

public typealias TableSection = UITableView.Section
public typealias TableTitledSection = UITableView.TitledSection

extension UITableView {
    
    public var mediator: UITableView.Mediator {
        if let mediator = getMediator() as? UITableView.Mediator {
            return mediator
        }
        let mediator = Mediator()
        mediator.bond(with: self)
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
            mediator.cells
        }
        set {
            mediator.cells = newValue
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
        let contentSize = sizeOfContent
        let currentCell = cellForRow(at: indexPath)
        let currentHeight = currentCell?.bounds.height ?? .zero
        let calculatedHeight = currentCell?.sizeThatFits(contentSize).height ?? .zero
        let heightFromActualCell = currentHeight > .zero ? currentHeight : calculatedHeight
        guard let cell = sections[safe: indexPath.section]?.cells[safe: indexPath.item] else { return heightFromActualCell }
        let customCellHeight = cell.customCellHeight(for: contentSize.width)
        return customCellHeight.isCalculated ? customCellHeight : heightFromActualCell
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
        buildWithCells(withFirstSection: Section(distinctIdentifier: firstSection), builder)
    }
    
    public func buildWithCells(withFirstSection firstSection: UITableView.Section? = nil, _ builder: (TableCellBuilder) -> Void) {
        let collectionBuilder = TableCellBuilder(section: firstSection ?? Section(distinctIdentifier: "first_section"))
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
}

extension UITableView {
    
    public class Mediator: ViewMediator<UITableView> {
        var tapGestureRecognizer: UITapGestureRecognizer = builder(UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))) {
            $0.numberOfTouchesRequired = 1
            $0.isEnabled = true
            $0.cancelsTouchesInView = false
        }
        var applicableSections: [Section] = []
        @Observable public var sections: [Section] = []
        @Observable public var cells: [AnyTableCellMediator] = []
        public var animationSet: UITableView.AnimationSet = .init()
        public var reloadStrategy: CellReloadStrategy = .reloadArrangementDifference
        var didReloadAction: ((Bool) -> Void)?
        
        public override func willBonded(with view: UITableView) {
            view.dataSource = self
            view.addGestureRecognizer(tapGestureRecognizer)
        }
        
        public override func bonding(with view: UITableView) {
            $sections.observe(on: .main)
                .syncWhenInSameThread()
                .whenDidSet { [weak self, weak view] changes in
                guard let self = self, let view = view else { return }
                let newSection = changes.new
                view.registerNewCell(from: newSection)
                let oldSection = self.applicableSections
                self.applicableSections = newSection
                self.reload(view, with: newSection, oldSections: oldSection, completion: self.didReloadAction)
            }
            _cells.mutator { [weak self] in
                self?.sections.first?.cells ?? []
            } set: { newValue in
                self.sections = [Section(distinctIdentifier: "single_section", cells: newValue)]
            }
        }
        
        public override func bondDidRemoved() {
            tapGestureRecognizer.view?.removeGestureRecognizer(tapGestureRecognizer)
        }
        
        public func whenDidReloadCells(then: ((Bool) -> Void)?) {
            didReloadAction = then
        }
        
        @objc public func didTap(_ gesture: UITapGestureRecognizer) {
            guard let table = gesture.view as? UITableView else { return }
            let location = gesture.location(in: table)
            guard let indexPath = table.indexPathForRow(at: location),
                  let cell = table.cellForRow(at: indexPath),
                  let mediator = cell.getMediator() as? AnyTableCellMediator else {
                return
            }
            mediator.didTap(cell: cell)
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
#endif
