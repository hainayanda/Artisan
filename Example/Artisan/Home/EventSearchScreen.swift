//
//  MovieSearchScreen.swift
//  Artisan
//
//  Created by Nayanda Haberty on 12/20/2020.
//  Copyright (c) 2020 24823437. All rights reserved.
//

import UIKit
import Artisan
import Draftsman
import Builder
import Pharos

protocol EventSearchScreenDataBinding {
    var searchPhraseBindable: BindableObservable<String?> { get }
    var eventResultsObservable: Observable<EventResults> { get }
}

protocol EventSearchScreenSubscriber {
    func apply(_ keywordCell: KeywordCell, with keyword: String)
    func apply(_ eventCell: EventCell, with event: Event)
    func didTap(_ keyword: String, at indexPath: IndexPath)
    func didTap(_ event: Event, at indexPath: IndexPath)
}

struct EventResults: Hashable {
    var histories: [String]
    var results: [Event]
}

typealias EventSearchScreenViewModel = ViewModel & EventSearchScreenSubscriber & EventSearchScreenDataBinding

class EventSearchScreen: UIPlannedController, ViewBinding {
    typealias Subscriber = EventSearchScreenSubscriber
    typealias DataBinding = EventSearchScreenDataBinding
    
    @Subject var allResults: EventResults = .init(histories: [], results: [])
    
    // MARK: View
    lazy var searchBar: UISearchBar = builder(UISearchBar.self)
        .placeholder("Search event here!")
        .sizeToFit()
        .tintColor(.text)
        .barTintColor(.background)
        .build()
    
    lazy var tableView: UITableView = builder(UITableView.self)
        .backgroundColor(.clear)
        .separatorStyle(.none)
        .allowsSelection(true)
        .delegate(self)
        .build()
    
    @LayoutPlan
    var viewPlan: ViewPlan {
        tableView.drf
            .edges.equal(with: .safeArea)
            .sectioned(using: $allResults) { [weak self] allResult in
                TitledSection(title: "Search History", items: allResult.histories) { _, keyword in
                    Cell(from: KeywordCell.self) { cell, _ in
                        self?.subscriber?.apply(cell, with: keyword)
                    }
                }
                TitledSection(title: "Search Results", items: allResult.results) { _, event in
                    Cell(from: EventCell.self) { cell, _ in
                        self?.subscriber?.apply(cell, with: event)
                    }
                }
            }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        if #available(iOS 11.0, *) {
            tableView.contentInset = view.safeAreaInsets
        } else {
            tableView.contentInset = view.layoutMargins
        }
        applyPlan()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigation()
    }
    
}

extension EventSearchScreen {
    func bindData(from dataBinding: DataBinding) {
        dataBinding.searchPhraseBindable
            .bind(with: searchBar.bindables.text)
            .retained(by: self)
        dataBinding.eventResultsObservable.whenDidSet { [unowned self] results in
            self.allResults = results.new
        }
//            .relayChanges(to: $allResults)
            .retained(by: self)
            .notifyWithCurrentValue()
    }
}

extension EventSearchScreen {
    
    private func setupNavigation() {
        navigationController?.navigationBar.tintColor = .main
        navigationItem.titleView = searchBar
    }
}

extension EventSearchScreen: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            guard indexPath.item < allResults.histories.count else { return }
            subscriber?.didTap(allResults.histories[indexPath.item], at: indexPath)
        case 1:
            guard indexPath.item < allResults.results.count else { return }
            subscriber?.didTap(allResults.results[indexPath.item], at: indexPath)
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .background
        let header = view as? UITableViewHeaderFooterView
        header?.textLabel?.textColor = .secondary
    }
}
