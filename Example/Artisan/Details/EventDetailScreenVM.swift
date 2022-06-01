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

class EventDetailScreenVM: EventDetailsScreenViewModel {
    typealias DataBinding = EventDetailsScreenDataBinding
    typealias Subscriber = EventDetailsScreenSubscriber
    
    @Subject var event: Event?
    var eventObservable: Observable<Event?> { $event }
    
    var router: EventRouting
    var service: EventService
    
    init(event: Event, router: EventRouting, service: EventService) {
        self.event = event
        self.router = router
        self.service = service
    }
    
    func apply(_ headerCell: EventHeaderCell, with event: Event) {
        headerCell.bind(with: EventCellVM(event: event))
    }
    
    func apply(_ similarCell: SimilarEventCell, with event: Event) {
        let vm = SimilarEventCellVM(event: event, service: service)
        similarCell.bind(with: vm)
        vm.whenDidTapped { [weak self] _, event in
            self?.router.routeToDetails(of: event)
        }
    }
}
