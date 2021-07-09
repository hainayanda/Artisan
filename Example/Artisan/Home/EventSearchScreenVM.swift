//
//  EventSearchScreenVM.swift
//  Artisan_Example
//
//  Created by Nayanda Haberty on 22/12/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import Artisan
import Pharos

class EventSearchScreenVM: ViewMediator<EventSearchScreen> {
    
    var service: EventService = MockEventService()
    var router: Router = ExampleRouter()
    
    @Observable var searchPhrase: String?
    @Observable var results: [Event] = []
    @Observable var history: [String] = []
    
    override func bonding(with view: EventSearchScreen) {
        $searchPhrase.bonding(with: view.searchBar.bondableRelays.text)
            .whenDidSet(invoke: self, method: EventSearchScreenVM.search(for:))
            .multipleSetDelayed(by: .fast)
        $results.observe(on: .main)
            .whenDidSet(invoke: self, method: EventSearchScreenVM.didGet(results:))
        $history.observe(on: .main)
            .whenDidSet(invoke: self, method: EventSearchScreenVM.didHistory(updated:))
    }
}

extension EventSearchScreenVM: EventSearchScreenObserver {
    func didTap(_ tableView: UITableView, cell: UITableViewCell, at indexPath: IndexPath) {
        guard let view = self.bondedView, let mediator = cell.getMediator() else { return }
        if let keywordMediator = mediator as? KeywordCellVM {
            searchPhrase = keywordMediator.keyword
        } else if let eventMediator = mediator as? EventCellVM {
            router.routeToDetails(of: eventMediator.event, from: view)
        }
    }
}

extension EventSearchScreenVM: KeywordCellMediatorDelegate {
    func keywordCellDidTapClear(_ mediator: KeywordCellVM) {
        var currentHistory = history
        currentHistory.removeAll { $0 == mediator.keyword }
        history = currentHistory
    }
}

extension EventSearchScreenVM {
    
    func search(for changes: Changes<String?>) {
        print(changes.new?.isEmpty ?? true ? "--empty--" : changes.new ?? "")
        addToHistory(changes)
        service.searchEvent(withSearchPhrase: changes.new ?? "") { [weak self] events in
            self?.results = events
        }
    }
    
    func addToHistory(_ changes: Changes<String?>) {
        guard let new = changes.new,
              !new.isEmpty else {
            return
        }
        let trimmed = new.trimmingCharacters(in: .whitespaces)
            .replacingOccurrences(of: "\\S+$", with: "", options: .regularExpression, range: nil)
        guard !trimmed.isEmpty,
              !history.contains(trimmed) else {
            return
        }
        var currentHistory = history
        currentHistory.insert(trimmed, at: 0)
        while currentHistory.count > 3 {
            currentHistory.removeLast()
        }
        history = currentHistory
    }
    
    func didGet(results: Changes<[Event]>) {
        reloadTable(with: history, and: results.new)
    }
    
    func didHistory(updated: Changes<[String]>) {
        reloadTable(with: updated.new, and: results)
    }
    
    func reloadTable(with histories: [String], and events: [Event]) {
        bondedView?.tableView.reloadWith {
            TableTitledSection(title: "Search History", identifier: "history") {
                ItemToTableMediator(items: histories, to: KeywordCellVM.self) { mediator, history in
                    mediator.distinctIdentifier = history
                    mediator.keyword = history
                    mediator.delegate = self
                }
            }
            TableTitledSection(title: "Search Results", identifier: "results") {
                ItemToTableMediator(items: events, to: EventCellVM.self) { mediator, event in
                    mediator.distinctIdentifier = event.name
                    mediator.event = event
                }
            }
        }
    }
}

struct Event {
    var image: UIImage
    var name: String
    var details: String
    var date: Date
}
