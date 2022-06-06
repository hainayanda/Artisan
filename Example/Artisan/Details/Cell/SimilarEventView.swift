//
//  SimilarEventView.swift
//  Artisan_Example
//
//  Created by Nayanda Haberty on 24/12/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import Artisan
import Draftsman
import Pharos
import Builder
import Impose

protocol SimilarEventViewDataBinding {
    var eventsObservable: Observable<[SimilarEvent]> { get }
}

protocol SimilarEventViewSubscriber {
    func didTap(_ event: SimilarEvent, at indexPath: IndexPath)
}

struct SimilarEvent: IntermediateModel {
    var distinctifier: AnyHashable
    var viewModel: EventCollectionCellViewModel
}

typealias SimilarEventViewModel = ViewModel & SimilarEventViewDataBinding & SimilarEventViewSubscriber

class SimilarEventView: UIPlannedView, ViewBindable {
    typealias Model = SimilarEventViewModel
    
    @Subject var events: [SimilarEvent] = []
    
    lazy var collectionLayout: UICollectionViewFlowLayout = builder(UICollectionViewFlowLayout())
        .scrollDirection(.horizontal)
        .itemSize(CGSize(width: .x64, height: .x48))
        .minimumLineSpacing(.zero)
        .minimumInteritemSpacing(.zero)
        .build()
    
    lazy var collectionView: UICollectionView = builder(UICollectionView(frame: .zero, collectionViewLayout: collectionLayout))
        .allowsSelection(true)
        .backgroundColor(.clear)
        .delegate(self)
        .build()
    
    @LayoutPlan
    var viewPlan: ViewPlan {
        collectionView.drf
            .edges.equal(with: .parent)
            .height.equal(to: .x48)
            .cells(from: $events) { _, event in
                Cell(from: EventCollectionCell.self, bindWith: event.viewModel)
            }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        didInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        didInit()
    }
    
    func didInit() {
        backgroundColor = .background
        applyPlan()
    }
    
    func viewNeedBind(with model: Model) {
        model.eventsObservable
            .relayChanges(to: $events)
            .observe(on: .main)
            .retained(by: self)
            .fire()
    }
}

extension SimilarEventView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard indexPath.item < events.count else { return }
        model?.didTap(events[indexPath.item], at: indexPath)
    }
}

class SimilarEventVM: SimilarEventViewModel, ObjectRetainer {
    typealias TapAction = (SimilarEventVM, Event) -> Void
    
    @Injected var service: EventService
    
    @Subject var event: Event?
    @Subject var events: [Event] = []
    var eventsObservable: Observable<[SimilarEvent]> {
        $events.mapped { events in
            events.compactMap {
                SimilarEvent(
                    distinctifier: $0,
                    viewModel: EventCollectionCellVM(event: $0)
                )
            }
        }
        
    }
    
    private var tapObserver: TapAction?
    
    init(event: Event?) {
        self.event = event
        $event.whenDidSet { [unowned self] changes in
            guard let new = changes.new else { return }
            service.similarEvent(with: new) { [weak self] similars in
                self?.events = similars
            }
        }.retained(by: self)
            .fire()
    }
    
    @discardableResult
    func whenDidTapped(thenRun action: @escaping TapAction) -> Self {
        tapObserver = action
        return self
    }
    
    func didTap(_ event: SimilarEvent, at indexPath: IndexPath) {
        guard let tappedEvent = event.distinctifier as? Event else { return }
        tapObserver?(self, tappedEvent)
    }
}
