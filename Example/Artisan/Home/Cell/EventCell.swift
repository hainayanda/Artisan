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
    lazy var bannerBackground: UIView = build {
        $0.layer.cornerRadius = .x8
        $0.backgroundColor = .white
        $0.layer.shadowColor = UIColor.inactive.cgColor
        $0.layer.shadowOpacity = 1
        $0.layer.shadowOffset = .init(width: 0, height: 2)
        $0.layer.shadowRadius = 4
    }
    lazy var banner: UIImageView = build {
        $0.layer.cornerRadius = .x8
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
    }
    lazy var title = build(UILabel.self)
        .font(.boldSystemFont(ofSize: .x16))
        .numberOfLines(1)
        .textAlignment(.left)
        .textColor(.secondary)
        .build()
    lazy var subTitle = build(UILabel.self)
        .font(.systemFont(ofSize: .x12))
        .numberOfLines(1)
        .textAlignment(.left)
        .textColor(.main)
        .build()
    lazy var date = build(UILabel.self)
        .font(.systemFont(ofSize: .x12))
        .numberOfLines(1)
        .textAlignment(.left)
        .textColor(.text)
        .build()
    
    // MARK: Dimensions
    var bannerWidthToHeightMultiplier: CGFloat = .x2
    var margin: UIEdgeInsets = .init(insets: .x16)
    var spacing: CGFloat = .x6
    var titleFont: UIFont = .boldSystemFont(ofSize: .x16)
    var subTitleFont: UIFont = .systemFont(ofSize: .x12)
    var dateFont: UIFont = .systemFont(ofSize: .x12)
    
    override func fragmentWillPlanContent() {
        contentView.backgroundColor = .background
        contentView.layer.borderWidth = 0.5
        contentView.layer.borderColor = UIColor.inactive.withAlphaComponent(.semiOpaque).cgColor
    }
    
    override func planContent(_ plan: InsertablePlan) {
        plan.fit(bannerBackground)
            .at(.fullTop, .equalTo(margin), to: .parent)
            .width(.equalTo(.myself), .height, multiplyBy: bannerWidthToHeightMultiplier)
        plan.fit(banner)
            .at(.fullTop, .equalTo(margin), to: .parent)
            .width(.equalTo(.myself), .height, multiplyBy: bannerWidthToHeightMultiplier)
        plan.fit(title)
            .at(.bottomOf(banner), .equalTo(spacing))
            .horizontal(.equalTo(margin), to: .parent)
        plan.fit(subTitle)
            .at(.bottomOf(title), .equalTo(spacing))
            .horizontal(.equalTo(margin), to: .parent)
        plan.fit(date)
            .at(.bottomOf(subTitle), .equalTo(spacing))
            .at(.fullBottom, .equalTo(margin), to: .parent)
    }
}

class EventCellMediator<Cell: EventCell>: TableViewCellMediator<Cell> {
    @ObservableState var event: Event?
    @ViewState var bannerImage: UIImage?
    @ViewState var eventName: String?
    @ViewState var eventDetails: String?
    @ViewState var eventDate: String?
    
    override func didInit() {
        $event.observe(observer: self)
            .didSet(thenCall: EventCellMediator.set(eventChanges:))
    }
    
    override func bonding(with view: Cell) {
        super.bonding(with: view)
        $bannerImage.bonding(with: view.banner, \.image)
        $eventName.bonding(with: view.title, \.text)
        $eventDetails.bonding(with: view.subTitle, \.text)
        $eventDate.bonding(with: view.date, \.text)
    }
    
    func set(eventChanges: Changes<Event?>) {
        let event = eventChanges.new
        cellIdentifier = event?.name
        bannerImage = event?.image
        eventName = event?.name
        eventDetails = event?.details
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        guard let date = event?.date else {
            eventDate = nil
            return
        }
        eventDate = dateFormatter.string(from: date)
    }
}
