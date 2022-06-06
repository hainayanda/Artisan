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
    var eventObservable: Observable<EventDetailModel?> { get }
}

typealias EventDetailsScreenViewModel = ViewModel & EventDetailsScreenDataBinding

struct EventDetailModel: IntermediateModel {
    var distinctifier: AnyHashable
    var headerViewModel: EventHeaderViewModel
    var similarViewModel: SimilarEventViewModel
}

class EventDetailsScreen: UIPlannedController, ViewBindable {
    typealias Model = EventDetailsScreenViewModel
    
    @Subject var event: EventDetailModel?
    
    lazy var scrolledStack: ScrollableStack = builder(ScrollableStack(axis: .vertical, alignment: .fill))
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
    
    init() {
        super.init(nibName: nil, bundle: nil)
        didInit()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        didInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        didInit()
    }
    
    func didInit() {
        $event.whenDidSet { [unowned self] changes in
            self.applyPlan()
        }.observe(on: .main)
            .asynchronously()
            .retained(by: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        navigationController?.navigationBar.tintColor = .main
        applyPlan()
    }
    
    func viewNeedBind(with model: Model) {
        model.eventObservable
            .relayChanges(to: $event)
            .observe(on: .main)
            .retained(by: self)
            .fire()
    }
}
