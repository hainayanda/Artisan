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

class EventSearchScreenVM: ViewMediator<EventSearchScreen> {
    
    var service: EventService = MockEventService()
    var router: Router = ExampleRouter()
    
    @ViewState var searchPhrase: String?
    @ObservableState var results: [Event] = []
    @ObservableState var history: [String] = []
    
    override func didInit() {
        $results.observe(observer: self)
            .didSet(thenCall: EventSearchScreenVM.didGet(results:))
        $history.observe(observer: self)
            .didSet(thenCall: EventSearchScreenVM.didHistory(updated:))
    }
    
    override func bonding(with view: EventSearchScreen) {
        super.bonding(with: view)
        $searchPhrase.bonding(with: view.searchBar, \.text)
            .observe(observer: self)
            .delayMultipleSetTrigger(by: .fastest)
            .didSet(thenCall: EventSearchScreenVM.search(for:))
    }
}

extension EventSearchScreenVM: EventSearchScreenObserver {
    func didTap(_ tableView: UITableView, cell: UITableViewCell, at indexPath: IndexPath) {
        guard let view = self.view, let mediator = cell.getMediator() else { return }
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
        addToHistory(changes)
        service.searchEvent(withSearchPhrase: changes.new ?? "") { [weak self] events in
            self?.results = events
        }
    }
    
    func addToHistory(_ changes: Changes<String?>) {
        guard let new = changes.new,
              !new.isEmpty,
              new.last?.isWhitespace ?? false else {
            return
        }
        let trimmed = new.trimmingCharacters(in: .whitespaces)
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
        view?.tableView.sections = constructCells(with: history, and: results.new)
    }
    
    func didHistory(updated: Changes<[String]>) {
        view?.tableView.sections = constructCells(with: updated.new, and: results)
    }
    
    func constructCells(with histories: [String], and events: [Event]) -> [UITableView.Section] {
        TableCellBuilder(section: UITableView.TitledSection(title: "Search History", identifier: "history"))
            .next(mediatorType: KeywordCellVM.self, fromItems: histories) { mediator, history in
                mediator.cellIdentifier = history
                mediator.keyword = history
                mediator.delegate = self
            }.nextSection(UITableView.TitledSection(title: "Search Results", identifier: "results"))
            .next(mediatorType: EventCellVM.self, fromItems: events) { mediator, event in
                mediator.event = event
            }.build()
    }
}

struct Event {
    var image: UIImage
    var name: String
    var details: String
    var date: Date
}
