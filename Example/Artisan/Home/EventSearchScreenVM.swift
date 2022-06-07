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
import Impose

// MARK: ViewModel

class EventSearchScreenVM: EventSearchScreenViewModel, ObjectRetainer {
    
    @Injected var service: EventService
    
    var router: EventRouting
    
    @Subject var searchPhrase: String?
    @Subject var results: [Event] = []
    @Subject var history: [String] = []
    
    var searchPhraseBindable: BindableObservable<String?> {
        $searchPhrase
    }
    
    var eventResultsObservable: Observable<EventResults> {
        $history.combine(with: $results).mapped { (histories, events) in
            EventResults(
                histories: histories?.compactMap {
                    let vm = KeywordCellVM(keyword: $0, delegate: self)
                    return HistoryResult(distinctifier: $0, viewModel: vm)
                } ?? [],
                results: events?.compactMap {
                    let vm = EventCellVM(event: $0)
                    return EventResult(distinctifier: $0, viewModel: vm)
                } ?? []
            )
        }
    }
    
    init(router: EventRouting) {
        self.router = router
        $searchPhrase
            .whenDidSet(thenDo: method(of: self, EventSearchScreenVM.search(for:)))
            .multipleSetDelayed(by: 1)
            .retained(by: self)
            .fire()
        
    }
}

// MARK: Subscriber

extension EventSearchScreenVM {
    func didTap(_ history: HistoryResult, at indexPath: IndexPath) {
        searchPhrase = history.distinctifier as? String
    }
    
    func didTap(_ event: EventResult, at indexPath: IndexPath) {
        guard let tappedEvent = event.distinctifier as? Event else { return }
        router.routeToDetails(of: tappedEvent)
    }
}

// MARK: Extensions

extension EventSearchScreenVM {
    
    func search(for changes: Changes<String?>) {
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
}

// MARK: KeywordCellVMDelegate

extension EventSearchScreenVM: KeywordCellVMDelegate {
    func keywordCellDidTapClear(_ viewModel: KeywordCellVM) {
        var currentHistory = history
        currentHistory.removeAll { $0 == viewModel.keyword }
        history = currentHistory
    }
}
