//
//  EventDetailsScreen.swift
//  Artisan_Example
//
//  Created by Nayanda Haberty on 24/12/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import Artisan

class EventDetailsScreen: UIViewController, ObservableView {
    typealias Observer = ObservingMediator
    
    lazy var tableView: UITableView = build {
        $0.animationSet =  .init(insertAnimation: .right, reloadAnimation: .fade, deleteAnimation: .right)
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.allowsSelection = false
        if #available(iOS 11.0, *) {
            $0.contentInset = view.safeAreaInsets
        } else {
            $0.contentInset = view.layoutMargins
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        navigationController?.navigationBar.tintColor = .main
        planViewContent()
        observer?.viewDidLayouted(self)
    }
}

extension EventDetailsScreen {
    
    private func planViewContent() {
        planContent { plan in
            plan.fit(tableView)
                .edges(.equal, to: .safeArea)
        }
    }
}
