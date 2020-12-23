//
//  HeroHomeScreenMediator.swift
//  Artisan_Example
//
//  Created by Nayanda Haberty on 22/12/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import Artisan

class EventSearchScreenMediator: ViewMediator<EventSearchScreen> {
    
    var service: EventService = MockEventService()
    
    @ViewState var searchPhrase: String?
    @ObservableState var results: [Event] = []
    
    override func didInit() {
        $results.observe(observer: self)
            .didSet(thenCall: EventSearchScreenMediator.didGet(results:))
    }
    
    override func bonding(with view: EventSearchScreen) {
        super.bonding(with: view)
        $searchPhrase.bonding(with: view.searchBar, \.text)
        $searchPhrase.observe(observer: self)
            .delayMultipleSetTrigger(by: .fastest)
            .didSet(thenCall: EventSearchScreenMediator.search(for:))
    }
    
    func search(for changes: Changes<String?>) {
        service.searchEvent(withSearchPhrase: changes.new ?? "") { [weak self] events in
            self?.results = events
        }
    }
    
    func didGet(results: Changes<[Event]>) {
        view?.tableView.cells = results.new.compactMap { event -> TableCellMediator? in
            let mediator = EventCellMediator()
            mediator.cellIdentifier = event.name
            mediator.bannerImage = event.image
            mediator.eventName = event.name
            mediator.eventDetails = event.details
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy"
            mediator.eventDate = dateFormatter.string(from: event.date)
            return mediator
        }
    }
}

struct Event {
    var image: UIImage
    var name: String
    var details: String
    var date: Date
}
