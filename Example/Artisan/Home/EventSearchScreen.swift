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
    func didTap(_ event: EventResult, at indexPath: IndexPath)
    func didTap(_ history: HistoryResult, at indexPath: IndexPath)
}

struct HistoryResult: IntermediateModel {
    let distinctifier: AnyHashable
    let viewModel: KeywordCellViewModel
}

struct EventResult: IntermediateModel {
    let distinctifier: AnyHashable
    let viewModel: EventCellViewModel
}

struct EventResults: Hashable {
    var histories: [HistoryResult]
    var results: [EventResult]
}

typealias EventSearchScreenViewModel = ViewModel & EventSearchScreenSubscriber & EventSearchScreenDataBinding

class EventSearchScreen: UIPlannedController, ViewBindable {
    
    typealias Model = EventSearchScreenViewModel
    
    @Subject var allResults: EventResults = .init(histories: [], results: [])
    
    // MARK: View
    lazy var searchBar: UISearchBar = builder(UISearchBar.self)
        .placeholder("Search event here!")
        .sizeToFit()
        .tintColor(.text)
        .barTintColor(.background)
        .delegate(self)
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
            .edges.equal(with: .parent)
            .sectioned(using: $allResults) { allResult in
                TitledSection(title: "Search History", items: allResult.histories) { _, model in
                    Cell(from: KeywordCell.self, bindWith: model.viewModel)
                }
                TitledSection(title: "Search Results", items: allResult.results) { _, model in
                    Cell(from: EventCell.self, bindWith: model.viewModel)
                }
            }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        tableView.keyboardDismissMode = .onDrag
        applyPlan()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigation()
    }
    
    func viewNeedBind(with model: Model) {
        model.searchPhraseBindable
            .bind(with: searchBar.bindables.text)
            .observe(on: .main)
            .retained(by: self)
        model.eventResultsObservable
            .relayChanges(to: $allResults)
            .observe(on: .main)
            .retained(by: self)
            .fire()
    }
    
}

extension EventSearchScreen: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
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
            model?.didTap(allResults.histories[indexPath.item], at: indexPath)
        case 1:
            guard indexPath.item < allResults.results.count else { return }
            model?.didTap(allResults.results[indexPath.item], at: indexPath)
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
