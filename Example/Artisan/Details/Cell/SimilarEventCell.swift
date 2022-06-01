//
//  SimilarEventCell.swift
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

protocol SimilarEventCellDataBinding {
    var eventsObservable: Observable<[Event]> { get }
}

protocol SimilarEventCellSubscriber {
    func didTap(_ event: Event, at indexPath: IndexPath)
    func apply(_ eventCell: EventCollectionCell, with event: Event)
}

typealias SimilarEventCellViewModel = ViewModel & SimilarEventCellDataBinding & SimilarEventCellSubscriber

class SimilarEventCell: UITablePlannedCell, ViewBinding {
    typealias DataBinding = SimilarEventCellDataBinding
    typealias Subscriber = SimilarEventCellSubscriber
    
    @Subject var events: [Event] = []
    
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
    var contentViewPlan: ViewPlan {
        collectionView.drf
            .edges.equal(with: .parent)
            .height.equal(to: .x48)
            .cells(from: $events) { [weak self] _, event in
                Cell(from: EventCollectionCell.self) { cell, _ in
                    self?.subscriber?.apply(cell, with: event)
                }
            }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        didInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        didInit()
    }
    
    func didInit() {
        backgroundColor = .background
        contentView.backgroundColor = .background
        applyPlan()
    }
    
    func bindData(from dataBinding: DataBinding) {
        dataBinding.eventsObservable
            .relayChanges(to: $events)
            .observe(on: .main)
            .retained(by: self)
            .fire()
    }
}

extension SimilarEventCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard indexPath.item < events.count else { return }
        subscriber?.didTap(events[indexPath.item], at: indexPath)
    }
}

class SimilarEventCellVM: SimilarEventCellViewModel {
    typealias DataBinding = SimilarEventCellDataBinding
    typealias Subscriber = SimilarEventCellSubscriber
    typealias TapAction = (SimilarEventCellVM, Event) -> Void
    
    var service: EventService
    
    @Subject var event: Event?
    @Subject var events: [Event] = []
    var eventsObservable: Observable<[Event]> { $events }
    
    private var tapObserver: TapAction?
    
    init(event: Event?, service: EventService) {
        self.event = event
        self.service = service
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
    
    func didTap(_ event: Event, at indexPath: IndexPath) {
        tapObserver?(self, event)
    }
    
    func apply(_ eventCell: EventCollectionCell, with event: Event) {
        eventCell.bind(with: EventCollectionCellVM(event: event))
    }
}
