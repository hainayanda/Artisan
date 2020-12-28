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

class EventHeaderCell: EventCell {
    
    override func fragmentWillPlanContent() {
        super.fragmentWillPlanContent()
        title.numberOfLines = 0
        subTitle.numberOfLines = 0
        subTitle.textColor = .secondary
    }
}
