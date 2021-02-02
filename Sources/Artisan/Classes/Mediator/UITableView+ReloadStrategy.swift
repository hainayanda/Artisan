//
//  UITableView+ReloadStrategy.swift
//  Artisan
//
//  Created by Nayanda Haberty (ID) on 15/09/20.
//

import Foundation
#if canImport(UIKit)
import UIKit

extension UITableView.Mediator {
    
    func reload(
        _ tableView: UITableView,
        with sections: [UITableView.Section],
        oldSections: [UITableView.Section],
        completion: ((Bool) -> Void)?) {
        guard dataIsValid(tableView, oldData: oldSections) else {
            reloadAll(tableView: tableView, completion)
            return
        }
        switch self.reloadStrategy {
        case .reloadAll:
            reloadAll(tableView: tableView, completion)
            return
        case .reloadArrangementDifference, .reloadArrangementDifferenceAndRefresh:
            reloadBatch(tableView, with: sections, oldSections: oldSections, completion: completion)
        }
    }
    
    func reloadAll(tableView: UITableView, _ completion: ((Bool) -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            completion?(true)
        }
        tableView.reloadData()
        CATransaction.commit()
    }
    
    func reloadBatch(
        _ tableView: UITableView,
        with sections: [UITableView.Section],
        oldSections: [UITableView.Section],
        completion: ((Bool) -> Void)?) {
        var canceled: Bool = false
        tableView.beginUpdates()
        defer {
            tableView.endUpdates()
            if canceled {
                tableView.reloadData()
            }
            completion?(true)
        }
        let sectionReloader = TableMediatorSectionReloader(
            table: tableView,
            forceRefresh: reloadStrategy.shouldRefresh,
            animationSet: animationSet
        )
        let diffReloader = DiffReloader(worker: sectionReloader)
        diffReloader.reloadDifference(oldIdentities: oldSections, newIdentities: sections)
        canceled = sectionReloader.canceled
    }
    
    func dataIsValid(_ tableView: UITableView, oldData: [UITableView.Section]) -> Bool {
        guard tableView.numberOfSections == oldData.count else { return false }
        for (section, cells) in oldData.enumerated() {
            guard tableView.numberOfRows(inSection: section) == cells.cellCount else { return false }
        }
        return true
    }
}

public class TableMediatorSectionReloader: DiffReloaderWorker {
    let table: UITableView
    let animationSet: UITableView.AnimationSet
    let forceRefresh: Bool
    var canceled: Bool = false
    
    init(table: UITableView, forceRefresh: Bool, animationSet: UITableView.AnimationSet) {
        self.table = table
        self.animationSet = animationSet
        self.forceRefresh = forceRefresh
    }
    
    public func diffReloader(_ diffReloader: DiffReloader, shouldRemove identifiables: [Int : Identifiable]) {
        table.deleteSections(.init(identifiables.keys), with: animationSet.deleteSectionAnimation)
    }
    
    public func diffReloader(_ diffReloader: DiffReloader, shouldInsert identifiable: Identifiable, at index: Int) {
        table.insertSections(.init(integer: index), with: animationSet.insertSectionAnimation)
    }
    
    public func diffReloader(_ diffReloader: DiffReloader, shouldReload identifiables: [Int : (old: Identifiable, new: Identifiable)]) {
        for (index, pair) in identifiables {
            guard let oldSection = pair.old as? UITableView.Section,
                  let newSection = pair.new as? UITableView.Section else {
                continue
            }
            let cellReloader = TableMediatorCellReloader(section: index, table: table, forceRefresh: forceRefresh, animationSet: animationSet)
            let diffReloader = DiffReloader(worker: cellReloader)
            diffReloader.reloadDifference(oldIdentities: oldSection.cells, newIdentities: newSection.cells)
            if cellReloader.canceled {
                table.reloadSections(IndexSet([index]), with: .fade)
            }
        }
    }
    
    public func diffReloader(_ diffReloader: DiffReloader, shouldMove identifiable: Identifiable, from index: Int, to destIndex: Int) {
        table.moveSection(index, toSection: destIndex)
    }
    
    public func diffReloader(_ diffReloader: DiffReloader, failWith error: ArtisanError) {
        if let errorDescription = error.errorDescription {
            debugPrint(errorDescription)
            if let failureReason = error.failureReason {
                debugPrint(failureReason)
            }
        }
        canceled = true
    }
}

public class TableMediatorCellReloader: DiffReloaderWorker {
    let table: UITableView
    let animationSet: UITableView.AnimationSet
    let section: Int
    let forceRefresh: Bool
    var canceled: Bool = false
    
    init(section: Int, table: UITableView, forceRefresh: Bool, animationSet: UITableView.AnimationSet) {
        self.section = section
        self.table = table
        self.animationSet = animationSet
        self.forceRefresh = forceRefresh
    }
    
    public func diffReloader(_ diffReloader: DiffReloader, shouldRemove identifiables: [Int : Identifiable]) {
        let indexPaths: [IndexPath] = identifiables.keys.compactMap { IndexPath(row: $0, section: section) }
        table.deleteRows(at: indexPaths, with: animationSet.deleteRowAnimation)
    }
    
    public func diffReloader(_ diffReloader: DiffReloader, shouldInsert identifiable: Identifiable, at index: Int) {
        table.insertRows(at: [.init(row: index, section: section)], with: animationSet.insertRowAnimation)
    }
    
    public func diffReloader(_ diffReloader: DiffReloader, shouldReload identifiables: [Int : (old: Identifiable, new: Identifiable)]) {
        guard forceRefresh else { return }
        let indexPaths: [IndexPath] = identifiables.keys.compactMap { IndexPath(row: $0, section: section) }
        table.reloadRows(at: indexPaths, with: animationSet.reloadRowAnimation)
    }
    
    public func diffReloader(_ diffReloader: DiffReloader, shouldMove identifiable: Identifiable, from index: Int, to destIndex: Int) {
        table.moveRow(at: .init(row: index, section: section), to: .init(row: destIndex, section: section))
    }
    
    public func diffReloader(_ diffReloader: DiffReloader, failWith error: ArtisanError) {
        if let errorDescription = error.errorDescription {
            debugPrint(errorDescription)
            if let failureReason = error.failureReason {
                debugPrint(failureReason)
            }
        }
        canceled = true
    }
}
#endif
