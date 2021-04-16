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

class EventCollectionCell: CollectionFragmentCell {
    lazy var banner: UIImageView = build {
        $0.layer.cornerRadius = .x4
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
    }
    lazy var title = build(UILabel.self)
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
    
    override func planContent(_ plan: InsertablePlan) {
        plan.fit(banner)
            .at(.fullTop, .equalTo(margin), to: .parent)
        plan.fit(title)
            .at(.bottomOf(banner), .equalTo(spacing))
            .at(.fullBottom, .equalTo(margin), to: .parent)
    }
}

class EventCollectionCellVM: CollectionCellMediator<EventCollectionCell> {
    @Observable var event: Event?
    @Observable var bannerImage: UIImage?
    @Observable var eventName: String?
    
    override func bonding(with view: EventCollectionCell) {
        $event.whenDidSet(invoke: self, method: EventCollectionCellVM.set(eventChanges:))
        $bannerImage.bonding(with: .relay(of: view.banner, \.image))
        $eventName.bonding(with: .relay(of: view.title, \.text))
    }
    
    func set(eventChanges: Changes<Event?>) {
        let event = eventChanges.new
        distinctIdentifier = event?.name
        bannerImage = event?.image
        eventName = event?.name
    }
}
