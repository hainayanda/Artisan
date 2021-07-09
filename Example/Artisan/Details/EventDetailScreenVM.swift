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
import Pharos

class EventDetailScreenVM: ViewMediator<EventDetailsScreen> {
    var router: Router = ExampleRouter()
    
    @Observable var event: Event?
    
    override func bonding(with view: EventDetailsScreen) {
        $event.whenDidSet(invoke: self, method: EventDetailScreenVM.change(event:))
    }
}

extension EventDetailScreenVM {
    
    func didTapSimilar(event: Event) {
        guard let view = self.bondedView else { return }
        router.routeToDetails(of: event, from: view)
    }
    
    func change(event: Changes<Event?>) {
        bondedView?.title = event.new?.name
        bondedView?.tableView.reloadWith{
            TableSection(identifier: "header") {
                EventCellVM<EventHeaderCell>(event: event.new)
                    .with(identifier: "header")
            }
            TableTitledSection(title: "Similar Event", identifier: "similar") {
                SimilarEventCellVM(event: event.new)
                    .with(identifier: "similar")
                    .whenDidTapped { [weak self] _, event in
                        self?.didTapSimilar(event: event)
                    }
            }
        }
    }
}
