//
//  Router.swift
//  Artisan_Example
//
//  Created by Nayanda Haberty on 29/12/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

protocol Router {
    func routeToDetails(of event: Event?, from origin: UIViewController)
}

class ExampleRouter: Router {
    func routeToDetails(of event: Event?, from origin: UIViewController) {
        let detailsScreen = EventDetailsScreen()
        let detailScreenMediator = EventDetailScreenVM()
        detailScreenMediator.event = event
        detailScreenMediator.apply(to: detailsScreen)
        guard let navigation = origin.navigationController ?? origin as? UINavigationController else {
            origin.present(detailsScreen, animated: true, completion: nil)
            return
        }
        navigation.pushViewController(detailsScreen, animated: true)
    }
}
