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

class EventSearchScreenVM: EventSearchScreenViewModel {
    typealias Subscriber = EventSearchScreenSubscriber
    typealias DataBinding = EventSearchScreenDataBinding
    
    var searchPhraseBindable: BindableObservable<String?> {
        $searchPhrase
    }
    
    var eventResultsObservable: Observable<EventResults> {
        $history.combine(with: $results).mapped { (histories, events) in
            EventResults(
                histories: histories ?? [],
                results: events ?? []
            )
        }
    }
    
    var service: EventService
    var router: EventRouting
    
    @Subject var searchPhrase: String?
    @Subject var results: [Event] = []
    @Subject var history: [String] = []
    
    init(router: EventRouting, service: EventService) {
        self.service = service
        self.router = router
        $searchPhrase
            .whenDidSet(thenDo: method(of: self, EventSearchScreenVM.search(for:)))
            .multipleSetDelayed(by: 1)
            .retained(by: self)
            .fire()
        
    }
}

extension EventSearchScreenVM {
    func didTap(_ keyword: String, at indexPath: IndexPath) {
        searchPhrase = keyword
    }
    
    func didTap(_ event: Event, at indexPath: IndexPath) {
        router.routeToDetails(of: event)
    }
    
    func apply(_ keywordCell: KeywordCell, with keyword: String) {
        keywordCell.bind(with: KeywordCellVM(keyword: keyword, delegate: self))
    }
    
    func apply(_ eventCell: EventCell, with event: Event) {
        eventCell.bind(with: EventCellVM(event: event))
    }
}

extension EventSearchScreenVM: KeywordCellVMDelegate {
    func keywordCellDidTapClear(_ viewModel: KeywordCellVM) {
        var currentHistory = history
        currentHistory.removeAll { $0 == viewModel.keyword }
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
}

struct Event: Hashable {
    var image: UIImage
    var name: String
    var details: String
    var date: Date
}
