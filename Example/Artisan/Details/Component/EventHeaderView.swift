//
//  EventHeaderCell.swift
//  Artisan_Example
//
//  Created by Nayanda Haberty on 24/12/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import Artisan
import UIKit
import Builder
import Pharos
import Draftsman

// MARK: ViewModel Protocol

protocol EventHeaderViewDataBinding {
    var bannerImageObservable: Observable<UIImage?> { get }
    var eventNameObservable: Observable<String?> { get }
    var eventDetailsObservable: Observable<String?> { get }
    var eventDateObservable: Observable<String?> { get }
}

typealias EventHeaderViewModel = ViewModel & EventHeaderViewDataBinding

// MARK: View

class EventHeaderView: UIPlannedView, ViewBindable {
    typealias Model = EventHeaderViewModel
    
    lazy var bannerBackground: UIView = builder(UIView.self)
        .layer.cornerRadius(.x4)
        .backgroundColor(.white)
        .build()
    
    lazy var banner: UIImageView = builder(UIImageView.self)
        .layer.cornerRadius(.x4)
        .clipsToBounds(true)
        .contentMode(.scaleAspectFill)
        .build()
    
    lazy var title = builder(UILabel.self)
        .font(titleFont)
        .numberOfLines(0)
        .textAlignment(.left)
        .textColor(.secondary)
        .build()

    lazy var subTitle = builder(UILabel.self)
        .font(subTitleFont)
        .numberOfLines(0)
        .textAlignment(.left)
        .textColor(.secondary)
        .build()

    lazy var date = builder(UILabel.self)
        .font(dateFont)
        .numberOfLines(1)
        .textAlignment(.left)
        .textColor(.text)
        .build()
    
    @LayoutPlan
    var viewPlan: ViewPlan {
        bannerBackground.drf
            .top.horizontal.equal(with: .parent).offsetted(using: margin)
            .width.equal(with: .height(of: .mySelf)).multiplied(by: bannerWidthToHeightMultiplier)
            .insert {
                banner.drf.edges.equal(with: .parent)
            }
        title.drf
            .top.equal(to: bannerBackground.drf.bottom).offset(by: spacing)
            .horizontal.equal(with: .parent).offsetted(using: margin.horizontal)
        subTitle.drf
            .top.equal(to: title.drf.bottom).offset(by: spacing)
            .horizontal.equal(with: .parent).offsetted(using: margin.horizontal)
        date.drf
            .top.equal(to: subTitle.drf.bottom).offset(by: spacing)
            .bottom.horizontal.equal(with: .parent).offsetted(using: margin)
    }
    
    // MARK: Dimensions
    
    var bannerWidthToHeightMultiplier: CGFloat = 2
    var margin: UIEdgeInsets = .init(insets: .x8)
    var spacing: CGFloat = .x3
    var titleFont: UIFont = .title
    var subTitleFont: UIFont = .content
    var dateFont: UIFont = .content
    
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
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.inactive.withAlphaComponent(.semiOpaque).cgColor
        applyPlan()
    }
    
    func viewNeedBind(with model: Model) {
        model.bannerImageObservable
            .relayChanges(to: banner.bindables.image)
            .observe(on: .main)
            .retained(by: self)
            .fire()
        model.eventNameObservable
            .relayChanges(to: title.bindables.text)
            .observe(on: .main)
            .retained(by: self)
            .fire()
        model.eventDetailsObservable
            .relayChanges(to: subTitle.bindables.text)
            .observe(on: .main)
            .retained(by: self)
            .fire()
        model.eventDateObservable
            .relayChanges(to: date.bindables.text)
            .observe(on: .main)
            .retained(by: self)
            .fire()
    }
}
