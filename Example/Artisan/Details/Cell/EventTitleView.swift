//
//  EventTitleView.swift
//  Artisan_Example
//
//  Created by Nayanda Haberty on 05/06/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import Draftsman
import Builder

class EventTitleView: UIPlannedView {
    lazy var titleLabel: UILabel = builder(UILabel.self)
        .numberOfLines(1)
        .textAlignment(.left)
        .lineBreakMode(.byTruncatingTail)
        .textColor(.black)
        .font(.title)
        .build()
    
    @LayoutPlan
    var viewPlan: ViewPlan {
        titleLabel.drf
            .left.vertical.equal(with: .parent).offset(by: .x8)
            .right.moreThan(with: .parent).offset(by: .x8)
    }
    
    var title: String? {
        get {
            titleLabel.text
        }
        set {
            titleLabel.text = newValue
        }
    }
    
    init(title: String) {
        super.init(frame: .zero)
        self.titleLabel.text = title
        applyPlan()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
