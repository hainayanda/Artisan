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

class EventCell: TableFragmentCell {
    lazy var bannerBackground: UIView = builder {
        $0.layer.cornerRadius = .x4
        $0.backgroundColor = .white
        $0.layer.shadowColor = UIColor.inactive.cgColor
        $0.layer.shadowOpacity = 1
        $0.layer.shadowOffset = .init(width: 0, height: 2)
        $0.layer.shadowRadius = 4
    }
    lazy var banner: UIImageView = builder {
        $0.layer.cornerRadius = .x4
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
    }
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
    
    // MARK: Dimensions
    var bannerWidthToHeightMultiplier: CGFloat = 2
    var margin: UIEdgeInsets = .init(insets: .x8)
    var spacing: CGFloat = .x3
    var titleFont: UIFont = .title
    var subTitleFont: UIFont = .content
    var dateFont: UIFont = .content
    
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

class EventCellVM<Cell: EventCell>: TableCellMediator<Cell> {
    @Observable var event: Event?
    @Observable var bannerImage: UIImage?
    @Observable var eventName: String?
    @Observable var eventDetails: String?
    @Observable var eventDate: String?
    
    override func bonding(with view: Cell) {
        $event.whenDidSet(invoke: self, method: EventCellVM.set(eventChanges:))
        $bannerImage.bonding(with: .relay(of: view.banner, \.image))
        $eventName.bonding(with: .relay(of: view.title, \.text))
        $eventDetails.bonding(with: .relay(of: view.subTitle, \.text))
        $eventDate.bonding(with: .relay(of: view.date, \.text))
    }
    
    func set(eventChanges: Changes<Event?>) {
        let event = eventChanges.new
        distinctIdentifier = event?.name
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
