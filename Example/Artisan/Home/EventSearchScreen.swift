//
//  MovieSearchScreen.swift
//  Artisan
//
//  Created by Nayanda Haberty on 12/20/2020.
//  Copyright (c) 2020 24823437. All rights reserved.
//

import UIKit
import Artisan

class EventSearchScreen: UIViewController, ObservableView {
    typealias Observer = ObservingMediator
    
    // MARK: View
    lazy var searchBar: UISearchBar = build {
        $0.placeholder = "Search event here!"
        $0.sizeToFit()
        $0.tintColor = .text
        $0.barTintColor = .background
    }
    lazy var tableView: UITableView = build {
        $0.mediator.animationSet =  .init(insertAnimation: .top, reloadAnimation: .fade, deleteAnimation: .top)
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
        planViewContent()
        observer?.viewDidLayouted(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigation()
    }

}

extension EventSearchScreen {
    
    private func setupNavigation() {
        navigationItem.titleView = searchBar
    }
    
    private func planViewContent() {
        planContent { plan in
            plan.fit(tableView).edges(.equal, to: .safeArea)
        }
    }
}
