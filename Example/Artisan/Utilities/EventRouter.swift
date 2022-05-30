//
//  EventSearchRouter.swift
//  Artisan_Example
//
//  Created by Nayanda Haberty on 30/05/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

protocol EventRouting {
    func routeToDetails(of event: Event)
}

class EventRouter: EventRouting {
    
    weak var screen: UIViewController?
    
    init(screen: UIViewController) {
        self.screen = screen
    }
    
    func routeToDetails(of event: Event) {
        guard let screen = screen else {
            return
        }
        let detailsScreen = EventDetailsScreen()
        let detailRouter = EventRouter(screen: detailsScreen)
        let service = MockEventService()
        let detailScreenVM = EventDetailScreenVM(event: event, router: detailRouter, service: service)
        defer {
            detailsScreen.bind(with: detailScreenVM)
        }
        guard let navigation = screen.navigationController else {
            screen.present(detailsScreen, animated: true, completion: nil)
            return
        }
        navigation.pushViewController(detailsScreen, animated: true)
    }
}
