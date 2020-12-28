//
//  EventDetailScreenVM.swift
//  Artisan_Example
//
//  Created by Nayanda Haberty on 24/12/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import Artisan

class EventDetailScreenVM: ViewMediator<EventDetailsScreen> {
    @ObservableState var event: Event?
    
    override func didInit() {
        $event.observe(observer: self)
            .didSet(thenCall: EventDetailScreenVM.change(event:))
    }
    
    override func bonding(with view: EventDetailsScreen) {
        super.bonding(with: view)
    }
}

extension EventDetailScreenVM {
    func change(event: Changes<Event?>) {
        let events: [Event]
        if let new = event.new {
            events = [new]
        } else {
            events = []
        }
        view?.title = event.new?.name
        view?.tableView.sections = TableCellBuilder(section: UITableView.Section(identifier: "header"))
            .next(mediatorType: EventCellVM<EventHeaderCell>.self, fromItems: events) { mediator, event in
            mediator.event = event
        }.build()
    }
}
