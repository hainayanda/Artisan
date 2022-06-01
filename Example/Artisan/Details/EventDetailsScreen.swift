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
import Builder
import Pharos

protocol EventDetailsScreenDataBinding {
    var eventObservable: Observable<Event?> { get }
}

protocol EventDetailsScreenSubscriber {
    func apply(_ headerCell: EventHeaderCell, with event: Event)
    func apply(_ similarCell: SimilarEventCell, with event: Event)
}

typealias EventDetailsScreenViewModel = ViewModel & EventDetailsScreenDataBinding & EventDetailsScreenSubscriber

class EventDetailsScreen: UIPlannedController, ViewBinding {
    typealias DataBinding = EventDetailsScreenDataBinding
    typealias Subscriber = EventDetailsScreenSubscriber
    
    @Subject var event: Event?
    
    lazy var tableView: UITableView = builder(UITableView.self)
        .backgroundColor(.clear)
        .separatorStyle(.none)
        .allowsSelection(false)
        .delegate(self)
        .build()
    
    @LayoutPlan
    var viewPlan: ViewPlan {
        tableView.drf
            .edges.equal(with: .parent)
            .sectioned(using: $event.compactMapped { $0 }) { [weak self] event in
                Section(items: [event]) { _, _ in
                    Cell(from: EventHeaderCell.self) { cell, _ in
                        self?.subscriber?.apply(cell, with: event)
                    }
                }
                TitledSection(title: "Similar Event", items: [event]) { _, _ in
                    Cell(from: SimilarEventCell.self) { cell, _ in
                        self?.subscriber?.apply(cell, with: event)
                    }
                }
            }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        navigationController?.navigationBar.tintColor = .main
        applyPlan()
    }
    
    func bindData(from dataBinding: DataBinding) {
        dataBinding.eventObservable
            .relayChanges(to: $event)
            .observe(on: .main)
            .retained(by: self)
            .fire()
    }
}

extension EventDetailsScreen: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .background
        let header = view as? UITableViewHeaderFooterView
        header?.textLabel?.textColor = .secondary
    }
}
