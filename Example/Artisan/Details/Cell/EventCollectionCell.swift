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
    @ObservableState var event: Event?
    @ViewState var bannerImage: UIImage?
    @ViewState var eventName: String?
    
    override func didInit() {
        $event.observe(observer: self)
            .didSet(thenCall: EventCollectionCellVM.set(eventChanges:))
    }
    
    override func bonding(with view: EventCollectionCell) {
        super.bonding(with: view)
        $bannerImage.bonding(with: view.banner, \.image)
        $eventName.bonding(with: view.title, \.text)
    }
    
    func set(eventChanges: Changes<Event?>) {
        let event = eventChanges.new
        cellIdentifier = event?.name
        bannerImage = event?.image
        eventName = event?.name
    }
}
