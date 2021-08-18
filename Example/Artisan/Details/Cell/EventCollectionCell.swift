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

class EventCollectionCell: CollectionFragmentCell {
    lazy var banner: UIImageView = builder {
        $0.layer.cornerRadius = .x4
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
    }
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
    override var viewPlan: ViewPlan {
        banner.plan
            .at(.fullTop, .equalTo(margin), to: .parent)
        title.plan
            .at(.bottomOf(banner), .equalTo(spacing))
            .at(.fullBottom, .equalTo(margin), to: .parent)
    }
}

class EventCollectionCellVM: CollectionCellMediator<EventCollectionCell> {
    @Observable var event: Event?
    @Observable var bannerImage: UIImage?
    @Observable var eventName: String?
    
    init(event: Event?) {
        self.event = event
        super.init()
    }
    
    required init() {
        super.init()
    }
    
    override func bonding(with view: EventCollectionCell) {
        $event.whenDidSet(invoke: self, method: EventCollectionCellVM.set(eventChanges:))
        $bannerImage.relayValue(to: view.banner.bearerRelays.image)
        $eventName.relayValue(to: view.title.bearerRelays.text)
    }
    
    func set(eventChanges: Changes<Event?>) {
        let event = eventChanges.new
        distinctIdentifier = event?.name
        bannerImage = event?.image
        eventName = event?.name
    }
}
