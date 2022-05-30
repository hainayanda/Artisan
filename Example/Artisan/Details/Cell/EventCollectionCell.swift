//
//  EventCollectionCell.swift
//  Artisan_Example
//
//  Created by Nayanda Haberty on 29/12/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import Artisan
import Draftsman
import Pharos
import Builder

protocol EventCollectionCellDataBinding {
    var bannerImageObservable: Observable<UIImage?> { get }
    var eventNameObservable: Observable<String?> { get }
}

typealias EventCollectionCellViewModel = ViewModel & EventCollectionCellDataBinding

class EventCollectionCell: UICollectionPlannedCell, ViewBinding {
    typealias DataBinding = EventCollectionCellDataBinding
    typealias Subscriber = Void
    
    lazy var banner: UIImageView = builder(UIImageView.self)
        .layer.cornerRadius(.x4)
        .clipsToBounds(true)
        .contentMode(.scaleAspectFill)
        .build()
    
    lazy var title = builder(UILabel.self)
        .font(titleFont)
        .numberOfLines(1)
        .textAlignment(.center)
        .lineBreakMode(.byTruncatingTail)
        .textColor(.secondary)
        .build()
    
    // MARK: Dimensions
    var margin: UIEdgeInsets = .init(insets: .x4)
    var spacing: CGFloat = .x3
    var titleFont: UIFont = .mediumContent
    
    @LayoutPlan
    var contentViewPlan: ViewPlan {
        banner.drf
            .top.horizontal.equal(with: .parent).offsetted(using: margin)
        title.drf
            .top.equal(to: banner.drf.bottom).offset(by: spacing)
            .bottom.horizontal.equal(with: .parent).offsetted(using: margin)
    }
    
    func bindData(from dataBinding: DataBinding) {
        dataBinding.bannerImageObservable
            .relayChanges(to: banner.bindables.image)
            .retained(by: self)
        dataBinding.eventNameObservable
            .relayChanges(to: title.bindables.text)
            .retained(by: self)
    }
}

class EventCollectionCellVM: EventCollectionCellViewModel {
    typealias DataBinding = EventCollectionCellDataBinding
    typealias Subscriber = Void
    
    @Subject var event: Event?
    var bannerImageObservable: Observable<UIImage?> {
        $event.mapped { $0?.image }
    }
    var eventNameObservable: Observable<String?> {
        $event.mapped { $0?.name }
    }
    
    init(event: Event?) {
        self.event = event
    }
}
