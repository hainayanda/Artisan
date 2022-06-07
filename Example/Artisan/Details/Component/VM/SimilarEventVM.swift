//
//  SimilarEventVM.swift
//  Artisan_Example
//
//  Created by Nayanda Haberty on 06/06/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import Pharos
import Impose

class SimilarEventVM: SimilarEventViewModel, ObjectRetainer {
    typealias TapAction = (SimilarEventVM, Event) -> Void
    
    @Injected var service: EventService
    
    @Subject var event: Event?
    @Subject var events: [Event] = []
    
    var eventsObservable: Observable<[SimilarEvent]> {
        $events.mapped { events in
            events.compactMap {
                SimilarEvent(
                    distinctifier: $0,
                    viewModel: EventCollectionCellVM(event: $0)
                )
            }
        }
        
    }
    
    private var tapObserver: TapAction?
    
    init(event: Event?) {
        self.event = event
        $event.whenDidSet { [unowned self] changes in
            guard let new = changes.new else { return }
            service.similarEvent(with: new) { [weak self] similars in
                self?.events = similars
            }
        }.retained(by: self)
            .fire()
    }
    
    @discardableResult
    func whenDidTapped(thenRun action: @escaping TapAction) -> Self {
        tapObserver = action
        return self
    }
    
    func didTap(_ event: SimilarEvent, at indexPath: IndexPath) {
        guard let tappedEvent = event.distinctifier as? Event else { return }
        tapObserver?(self, tappedEvent)
    }
}
