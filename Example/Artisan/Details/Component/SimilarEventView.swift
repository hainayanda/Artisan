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

// MARK: ViewModel Protocol

protocol SimilarEventViewDataBinding {
    var eventsObservable: Observable<[SimilarEvent]> { get }
}

protocol SimilarEventViewSubscriber {
    func didTap(_ event: SimilarEvent, at indexPath: IndexPath)
}

typealias SimilarEventViewModel = ViewModel & SimilarEventViewDataBinding & SimilarEventViewSubscriber

// MARK: Intermediate Model

struct SimilarEvent: IntermediateModel {
    var distinctifier: AnyHashable
    var viewModel: EventCollectionCellViewModel
}

// MARK: View

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
    
    @BindBuilder
    func autoFireBinding(with model: Model) -> BindRetainables {
        model.eventsObservable
            .relayChanges(to: $events)
    }
}

extension SimilarEventView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard indexPath.item < events.count else { return }
        model?.didTap(events[indexPath.item], at: indexPath)
    }
}
