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

// MARK: ViewModel Protocol

protocol EventCollectionCellDataBinding {
    var bannerImageObservable: Observable<UIImage?> { get }
    var eventNameObservable: Observable<String?> { get }
}

typealias EventCollectionCellViewModel = ViewModel & EventCollectionCellDataBinding

// MARK: View

class EventCollectionCell: UICollectionPlannedCell, ViewBindable {
    
    typealias Model = EventCollectionCellViewModel
    
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
        contentView.backgroundColor = .background
        applyPlan()
    }
    
    @BindBuilder
    func autoFireBinding(with model: Model) -> BindRetainables {
        model.bannerImageObservable
            .relayChanges(to: banner.bindables.image)
        model.eventNameObservable
            .relayChanges(to: title.bindables.text)
    }
}
