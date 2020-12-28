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
    lazy var keywordLabel = build(UILabel.self)
        .font(.systemFont(ofSize: .x12, weight: .medium))
        .numberOfLines(1)
        .textAlignment(.left)
        .textColor(.text)
        .build()
    lazy var clearButton: UIButton = build {
        $0.setImage(#imageLiteral(resourceName: "delete"), for: .normal)
        $0.alpha = .semiOpaque
    }
    
    override func fragmentWillPlanContent() {
        contentView.backgroundColor = .background
    }
    
    override func planContent(_ plan: InsertablePlan) {
        plan.fit(keywordLabel)
            .at(.fullLeft, .equalTo(CGFloat.x16), to: .safeArea)
            .right(.moreThanTo(.x8), to: clearButton.leftAnchor)
        plan.fit(clearButton)
            .right(.equalTo(CGFloat.x16), to: .safeArea)
            .centerY(.equal, to: .parent)
            .size(.equalTo(.init(width: .x16, height: .x16)))
    }
}

class KeywordCellMediator: TableViewCellMediator<KeywordCell> {
    @ViewState var keyword: String?
    var delegate: KeywordCellMediatorDelegate?
    override func bonding(with view: KeywordCell) {
        super.bonding(with: view)
        $keyword.bonding(with: view.keywordLabel, \.text)
        view.clearButton.didTapped(observing: self, thenCall: KeywordCellMediator.didTapClear(on:))
    }
    
    func didTapClear(on button: UIButton) {
        delegate?.keywordCellDidTapClear(self)
    }
}

protocol KeywordCellMediatorDelegate: class {
    func keywordCellDidTapClear(_ mediator: KeywordCellMediator)
}
