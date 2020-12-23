//
//  KeywordCell.swift
//  Artisan_Example
//
//  Created by Nayanda Haberty on 23/12/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import Artisan
import UIKit

class KeywordCell: TableFragmentCell {
    var keywordLabel = build(UILabel.self)
        .font(.systemFont(ofSize: .x12, weight: .medium))
        .numberOfLines(1)
        .textAlignment(.left)
        .textColor(.text)
        .build()
    
    override func fragmentWillPlanContent() {
        contentView.backgroundColor = .background
    }
    
    override func planContent(_ plan: InsertablePlan) {
        plan.fit(keywordLabel)
            .edges(.equalTo(CGFloat.x16), to: .safeArea)
    }
}

class KeywordCellMediator: TableViewCellMediator<KeywordCell> {
    @ViewState var keyword: String?
    override func bonding(with view: KeywordCell) {
        super.bonding(with: view)
        $keyword.bonding(with: view.keywordLabel, \.text)
    }
}
