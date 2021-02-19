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

class SimilarEventCell: TableFragmentCell {
    lazy var collectionLayout: UICollectionViewFlowLayout = .init()
    lazy var collectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: collectionLayout)
    
    override func fragmentWillPlanContent() {
        collectionView.allowsSelection = true
        collectionView.backgroundColor = .clear
        collectionView.allowsSelection = true
        collectionLayout.scrollDirection = .horizontal
        collectionLayout.itemSize = .init(width: .x64, height: .x48)
        collectionLayout.minimumInteritemSpacing = .zero
        collectionLayout.minimumLineSpacing = .zero
    }
    
    override func planContent(_ plan: InsertablePlan) {
        plan.fit(collectionView)
            .edges(.equal, to: .parent)
            .height(.equalTo(.x48))
    }
    
    override func calculatedCellHeight(for cellWidth: CGFloat) -> CGFloat {
        .x48
    }
}

class SimilarEventCellVM: TableCellMediator<SimilarEventCell> {
    typealias TapAction = (SimilarEventCellVM, Event) -> Void
    var service: EventService = MockEventService()
    
    @ObservableState var event: Event?
    @ObservableState var events: [Event] = []
    
    private var tapObserver: TapAction?
    
    override func didInit() {
        $event.observe(observer: self)
            .didSet(thenCall: SimilarEventCellVM.set(eventChanges:))
        $events.observe(observer: self, on: .main)
            .didSet(thenCall: SimilarEventCellVM.set(eventsChanges:))
    }
    
    override func bonding(with view: SimilarEventCell) {
        super.bonding(with: view)
        view.collectionView.delegate = self
    }
    
    func whenDidTapped(thenRun action: @escaping TapAction) {
        tapObserver = action
    }
    
    func set(eventChanges: Changes<Event?>) {
        guard let event = eventChanges.new else {
            view?.collectionView.cells = []
            return
        }
        service.similarEvent(with: event) { [weak self] events in
            self?.events = events
        }
    }
    
    func set(eventsChanges: Changes<[Event]>) {
        view?.collectionView.sections = CollectionCellBuilder(sectionId: "similar")
            .next(mediatorType: EventCollectionCellVM.self, fromItems: eventsChanges.new) { cell, model in
                cell.cellIdentifier = event?.name
                cell.event = model
            }.build()
    }
}

extension SimilarEventCellVM: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let viewModel = collectionView.cellForItem(at: indexPath)?.getMediator() as? EventCollectionCellVM,
              let event = viewModel.event else {
            return
        }
        tapObserver?(self, event)
    }
}
