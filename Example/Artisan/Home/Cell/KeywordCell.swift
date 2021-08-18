//
//  KeywordCell.swift
//  Artisan_Example
//
//  Created by Nayanda Haberty on 23/12/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import Artisan
import Pharos
import Draftsman
import Builder

class KeywordCell: TableFragmentCell {
    lazy var keywordLabel = builder(UILabel.self)
        .font(.mediumContent)
        .numberOfLines(1)
        .textAlignment(.left)
        .textColor(.text)
        .build()
    lazy var clearButton: UIButton = builder {
        $0.setImage(#imageLiteral(resourceName: "delete"), for: .normal)
        $0.alpha = .semiOpaque
    }
    
    @LayoutPlan
    override var viewPlan: ViewPlan {
        keywordLabel.plan
            .at(.fullLeft, .equalTo(CGFloat.x8), to: .safeArea)
            .right(.moreThanTo(.x4), to: clearButton.leftAnchor)
        clearButton.plan
            .right(.equalTo(CGFloat.x8), to: .safeArea)
            .centerY(.equal, to: .parent)
            .size(.equalTo(.init(width: .x8, height: .x8)))
    }
    
    override func fragmentWillPlanContent() {
        contentView.backgroundColor = .background
    }
}

class KeywordCellVM: TableCellMediator<KeywordCell> {
    @Observable var keyword: String?
    
    var delegate: KeywordCellMediatorDelegate?
    
    init(keyword: String?, delegate: KeywordCellMediatorDelegate?) {
        self.keyword = keyword
        self.delegate = delegate
        super.init()
        self.distinctIdentifier = keyword
    }
    
    required init() {
        super.init()
    }
    
    override func bonding(with view: KeywordCell) {
        $keyword.relayValue(to: view.keywordLabel.bearerRelays.text)
        view.clearButton.whenDidTapped { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.keywordCellDidTapClear(self)
        }
    }
}

protocol KeywordCellMediatorDelegate: AnyObject {
    func keywordCellDidTapClear(_ mediator: KeywordCellVM)
}
