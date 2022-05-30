//
//  EvenCell.swift
//  Artisan_Example
//
//  Created by Nayanda Haberty on 22/12/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import Artisan
import UIKit
import Draftsman
import Pharos
import Builder

protocol EventCellDataBinding {
    var bannerImageObservable: Observable<UIImage?> { get }
    var eventNameObservable: Observable<String?> { get }
    var eventDetailsObservable: Observable<String?> { get }
    var eventDateObservable: Observable<String?> { get }
}

typealias EventCellViewModel = ViewModel & EventCellDataBinding

class EventCell: UITablePlannedCell, ViewBinding {
    typealias DataBinding = EventCellDataBinding
    typealias Subscriber = Void
    
    lazy var bannerBackground: UIView = builder(UIView.self)
        .layer.cornerRadius(.x4)
        .backgroundColor(.white)
        .layer.shadowColor(UIColor.inactive.cgColor)
        .layer.shadowOpacity(1)
        .layer.shadowOffset(.init(width: 0, height: 2))
        .layer.shadowRadius(4)
        .build()
    
    lazy var banner: UIImageView = builder(UIImageView.self)
        .layer.cornerRadius(.x4)
        .clipsToBounds(true)
        .contentMode(.scaleAspectFill)
        .build()
    
    lazy var title = builder(UILabel.self)
        .font(titleFont)
        .numberOfLines(1)
        .textAlignment(.left)
        .textColor(.secondary)
        .build()

    lazy var subTitle = builder(UILabel.self)
        .font(subTitleFont)
        .numberOfLines(1)
        .textAlignment(.left)
        .textColor(.main)
        .build()

    lazy var date = builder(UILabel.self)
        .font(dateFont)
        .numberOfLines(1)
        .textAlignment(.left)
        .textColor(.text)
        .build()
    
    @LayoutPlan
    var contentViewPlan: ViewPlan {
        bannerBackground.drf
            .top.horizontal.equal(with: .parent).offsetted(using: margin)
            .width.equal(with: .height(of: .mySelf)).multiplied(by: bannerWidthToHeightMultiplier)
        banner.drf
            .top.horizontal.equal(with: .parent).offsetted(using: margin)
            .width.equal(with: .height(of: .mySelf)).multiplied(by: bannerWidthToHeightMultiplier)
        title.drf
            .top.equal(to: banner).offset(by: spacing)
            .horizontal.equal(with: .parent).offsetted(using: margin.horizontal)
        subTitle.drf
            .top.equal(to: title).offset(by: spacing)
            .horizontal.equal(with: .parent).offsetted(using: margin.horizontal)
        date.drf
            .top.equal(to: subTitle).offset(by: spacing)
            .bottom.horizontal.equal(with: .parent).offsetted(using: margin)
    }
    
    // MARK: Dimensions
    var bannerWidthToHeightMultiplier: CGFloat = 2
    var margin: UIEdgeInsets = .init(insets: .x8)
    var spacing: CGFloat = .x3
    var titleFont: UIFont = .title
    var subTitleFont: UIFont = .content
    var dateFont: UIFont = .content
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        didInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        didInit()
    }
    
    func didInit() {
        contentView.backgroundColor = .background
        contentView.layer.borderWidth = 0.5
        contentView.layer.borderColor = UIColor.inactive.withAlphaComponent(.semiOpaque).cgColor
    }
    
    func bindData(from dataBinding: DataBinding) {
        dataBinding.bannerImageObservable
            .relayChanges(to: banner.bindables.image)
            .retained(by: self)
            .notifyWithCurrentValue()
        dataBinding.eventNameObservable
            .relayChanges(to: title.bindables.text)
            .retained(by: self)
            .notifyWithCurrentValue()
        dataBinding.eventDetailsObservable
            .relayChanges(to: subTitle.bindables.text)
            .retained(by: self)
            .notifyWithCurrentValue()
        dataBinding.eventDateObservable
            .relayChanges(to: date.bindables.text)
            .retained(by: self)
            .notifyWithCurrentValue()
    }
}

class EventCellVM: EventCellViewModel {
    typealias Subscriber = Void
    typealias DataBinding = EventCellDataBinding
    
    
    @Subject var event: Event?
    var bannerImageObservable: Observable<UIImage?> {
        $event.mapped { $0?.image }
    }
    var eventNameObservable: Observable<String?> {
        $event.mapped { $0?.name }
    }
    var eventDetailsObservable: Observable<String?> {
        $event.mapped { $0?.details }
    }
    var eventDateObservable: Observable<String?> {
        $event.mapped { event in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy"
            guard let date = event?.date else {
                return nil
            }
            return dateFormatter.string(from: date)
        }
    }
    
    init(event: Event?) {
        self.event = event
    }
    
}
