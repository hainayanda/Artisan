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

class EventCell: TableFragmentCell {
    var bannerBackground: UIView = build {
        $0.layer.cornerRadius = .x8
        $0.backgroundColor = .white
        $0.layer.shadowColor = UIColor.inactive.cgColor
        $0.layer.shadowOpacity = 1
        $0.layer.shadowOffset = .init(width: 0, height: 2)
        $0.layer.shadowRadius = 2
    }
    var banner: UIImageView = build {
        $0.layer.cornerRadius = .x8
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
    }
    var title = build(UILabel.self)
        .font(.boldSystemFont(ofSize: .x16))
        .numberOfLines(1)
        .textAlignment(.left)
        .textColor(.secondary)
        .build()
    var subTitle = build(UILabel.self)
        .font(.systemFont(ofSize: .x12))
        .numberOfLines(1)
        .textAlignment(.left)
        .textColor(.main)
        .build()
    var date = build(UILabel.self)
        .font(.systemFont(ofSize: .x12))
        .numberOfLines(1)
        .textAlignment(.left)
        .textColor(.text)
        .build()
    
    override func fragmentWillPlanContent() {
        contentView.backgroundColor = .background
        contentView.layer.borderWidth = .x1
        contentView.layer.borderColor = UIColor.inactive.withAlphaComponent(.semiOpaque).cgColor
    }
    
    override func planContent(_ plan: InsertablePlan) {
        plan.fit(bannerBackground)
            .at(.fullTop, .equalTo(CGFloat.x16), to: .safeArea)
            .width(.equalTo(bannerBackground.heightAnchor), multiplyBy: .x2)
        plan.fit(banner)
            .at(.fullTop, .equalTo(CGFloat.x16), to: .safeArea)
            .width(.equalTo(banner.heightAnchor), multiplyBy: .x2)
        plan.fit(title)
            .at(.bottomOf(banner), .equalTo(CGFloat.x6))
            .horizontal(.equalTo(CGFloat.x16), to: .safeArea)
        plan.fit(subTitle)
            .at(.bottomOf(title), .equalTo(CGFloat.x6))
            .horizontal(.equalTo(CGFloat.x16), to: .safeArea)
        plan.fit(date)
            .at(.bottomOf(subTitle), .equalTo(CGFloat.x6))
            .at(.fullBottom, .equalTo(CGFloat.x16), to: .safeArea)
    }
}

class EventCellMediator: TableViewCellMediator<EventCell> {
    @ViewState var bannerImage: UIImage?
    @ViewState var eventName: String?
    @ViewState var eventDetails: String?
    @ViewState var eventDate: String?
    
    override func bonding(with view: EventCell) {
        super.bonding(with: view)
        $bannerImage.bonding(with: view.banner, \.image)
        $eventName.bonding(with: view.title, \.text)
        $eventDetails.bonding(with: view.subTitle, \.text)
        $eventDate.bonding(with: view.date, \.text)
    }
}
