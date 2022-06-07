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

// MARK: ViewModel Protocol

protocol EventDetailsScreenDataBinding {
    var eventObservable: Observable<EventDetailModel?> { get }
}

typealias EventDetailsScreenViewModel = ViewModel & EventDetailsScreenDataBinding

// MARK: Intermediate Model

struct EventDetailModel: IntermediateModel {
    var distinctifier: AnyHashable
    var headerViewModel: EventHeaderViewModel
    var similarViewModel: SimilarEventViewModel
}

// MARK: Screen

class EventDetailsScreen: UIPlannedController, ViewBindable {
    typealias Model = EventDetailsScreenViewModel
    
    @Subject var event: EventDetailModel?
    
    lazy var scrolledStack: ScrollableStackView = builder(ScrollableStackView(axis: .vertical, alignment: .fill))
        .backgroundColor(.clear)
        .build()
    
    @LayoutPlan
    var viewPlan: ViewPlan {
        scrolledStack.drf
            .edges.equal(with: .safeArea)
            .insertStacked {
                if let event = event {
                    EventHeaderView().binding(with: event.headerViewModel)
                    EventTitleView(title: "Similar Event")
                    SimilarEventView().binding(with: event.similarViewModel)
                }
            }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        navigationController?.navigationBar.tintColor = .main
        applyPlan()
    }
    
    func viewWillBind(with newModel: Model, oldModel: Model?) {
        $event
            .whenDidSet { [unowned self] changes in
                self.applyPlan()
            }.observe(on: .main)
            .asynchronously()
            .retained(by: self)
    }
    
    func viewNeedBind(with model: Model) {
        model.eventObservable
            .relayChanges(to: $event)
            .observe(on: .main)
            .retained(by: self)
            .fire()
    }
}
