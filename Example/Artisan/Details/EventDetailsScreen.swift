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
import Draftsman

class EventDetailsScreen: UIViewController, Planned {
    lazy var tableView: UITableView = builder {
        $0.animationSet =  .init(insertAnimation: .right, reloadAnimation: .fade, deleteAnimation: .right)
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.allowsSelection = false
        $0.delegate = self
        if #available(iOS 11.0, *) {
            $0.contentInset = view.safeAreaInsets
        } else {
            $0.contentInset = view.layoutMargins
        }
    }
    
    @LayoutPlan
    var viewPlan: ViewPlan {
        tableView.plan.edges(.equal, to: .safeArea)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        navigationController?.navigationBar.tintColor = .main
        applyPlan()
    }
}

extension EventDetailsScreen: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .background
        let header = view as? UITableViewHeaderFooterView
        header?.textLabel?.textColor = .secondary
    }
}
