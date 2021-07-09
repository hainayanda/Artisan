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

class SimilarEventCell: TableFragmentCell {
    lazy var collectionLayout: UICollectionViewFlowLayout = .init()
    lazy var collectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: collectionLayout)
    
    @LayoutPlan
    override var viewPlan: ViewPlan {
        collectionView.plan
            .edges(.equal, to: .parent)
            .height(.equalTo(.x48))
    }
    
    override func fragmentWillPlanContent() {
        collectionView.allowsSelection = true
        collectionView.backgroundColor = .clear
        collectionView.allowsSelection = true
        collectionLayout.scrollDirection = .horizontal
        collectionLayout.itemSize = .init(width: .x64, height: .x48)
        collectionLayout.minimumInteritemSpacing = .zero
        collectionLayout.minimumLineSpacing = .zero
    }
    
    override func calculatedCellHeight(for cellWidth: CGFloat) -> CGFloat {
        .x48
    }
}

class SimilarEventCellVM: TableCellMediator<SimilarEventCell> {
    typealias TapAction = (SimilarEventCellVM, Event) -> Void
    var service: EventService = MockEventService()
    
    @Observable var event: Event?
    @Observable var events: [Event] = []
    
    private var tapObserver: TapAction?
    
    init(event: Event?) {
        self.event = event
        super.init()
    }
    
    required init() {
        super.init()
    }
    
    override func bonding(with view: SimilarEventCell) {
        $event.whenDidSet(invoke: self, method: SimilarEventCellVM.set(eventChanges:))
        $events.observe(on: .main)
            .whenDidSet(invoke: self, method: SimilarEventCellVM.set(eventsChanges:))
        view.collectionView.delegate = self
    }
    
    @discardableResult
    func whenDidTapped(thenRun action: @escaping TapAction) -> Self {
        tapObserver = action
        return self
    }
    
    func set(eventChanges: Changes<Event?>) {
        guard let event = eventChanges.new else {
            bondedView?.collectionView.cells = []
            return
        }
        service.similarEvent(with: event) { [weak self] events in
            self?.events = events
        }
    }
    
    func set(eventsChanges: Changes<[Event]>) {
        bondedView?.collectionView.reloadWith {
            ItemToCollectionMediator(items: eventsChanges.new, to: EventCollectionCellVM.self) { cell, item in
                cell.distinctIdentifier = item.name
                cell.event = item
            }
        }
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
