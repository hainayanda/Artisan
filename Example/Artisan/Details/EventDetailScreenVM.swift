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
    var router: Router = ExampleRouter()
    
    @ObservableState var event: Event?
    
    override func didInit() {
        $event.observe(observer: self)
            .didSet(thenCall: EventDetailScreenVM.change(event:))
    }
}

extension EventDetailScreenVM {
    
    func didTapSimilar(event: Event) {
        guard let view = self.view else { return }
        router.routeToDetails(of: event, from: view)
    }
    
    func change(event: Changes<Event?>) {
        view?.title = event.new?.name
        view?.tableView.sections = buildCells(from: event.new)
    }
    
    func buildCells(from event: Event?) -> [UITableView.Section] {
        return TableCellBuilder(sectionId: "header")
            .next(mediatorType: EventCellVM<EventHeaderCell>.self, fromItem: event) { mediator, event in
                mediator.cellIdentifier = "header"
                mediator.event = event
            }.nextSection(UITableView.TitledSection(title: "Similar Event", identifier: "similar"))
            .next(mediatorType: SimilarEventCellVM.self, fromItem: event) { mediator, event in
                mediator.cellIdentifier = "similar"
                mediator.event = event
                mediator.whenDidTapped { [weak self] _, event in
                    self?.didTapSimilar(event: event)
                }
            }.build()
    }
}
