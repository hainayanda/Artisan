//
//  MovieSearchScreen.swift
//  Artisan
//
//  Created by Nayanda Haberty on 12/20/2020.
//  Copyright (c) 2020 24823437. All rights reserved.
//

import UIKit
import Artisan

protocol EventSearchScreenObserver: ObservingMediator {
    func didTap(_ tableView: UITableView, cell: UITableViewCell, at indexPath: IndexPath)
}

class EventSearchScreen: UIViewController, ObservableView {
    typealias Observer = EventSearchScreenObserver
    
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
        $0.allowsSelection = true
        if #available(iOS 11.0, *) {
            $0.contentInset = view.safeAreaInsets
        } else {
            $0.contentInset = view.layoutMargins
        }
        $0.delegate = self
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
        navigationController?.navigationBar.tintColor = .main
        navigationItem.titleView = searchBar
    }
    
    private func planViewContent() {
        planContent { plan in
            plan.fit(tableView).edges(.equal, to: .safeArea)
        }
    }
}

extension EventSearchScreen: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) else {
            return
        }
        observer?.didTap(tableView, cell: cell, at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .background
        let header = view as? UITableViewHeaderFooterView
        header?.textLabel?.textColor = .secondary
    }
}
