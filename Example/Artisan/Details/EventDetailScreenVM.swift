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
import Impose

class EventDetailScreenVM: EventDetailsScreenViewModel {
    
    @Subject var event: Event?
    var eventObservable: Observable<EventDetailModel?> {
        $event.mapped {
            guard let event = $0 else { return nil }
            return EventDetailModel(
                distinctifier: event,
                headerViewModel: EventHeaderVM(event: $0),
                similarViewModel: SimilarEventVM(event: $0).whenDidTapped { [weak self] _, event in
                    self?.router.routeToDetails(of: event)
                }
            )
        }
    }
    
    var router: EventRouting
    
    init(event: Event, router: EventRouting) {
        self.event = event
        self.router = router
    }
}
