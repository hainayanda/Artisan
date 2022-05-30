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

protocol KeywordCellDataBinding {
    var keywordObservable: Observable<String?> { get }
}

protocol KeywordCellSubscriber {
    func didTapClear(button: UIButton)
}

class KeywordCell: UITablePlannedCell, ViewBinding {
    typealias DataBinding = KeywordCellDataBinding
    typealias Subscriber = KeywordCellSubscriber
    
    lazy var keywordLabel: UILabel = builder(UILabel.self)
        .font(.mediumContent)
        .numberOfLines(1)
        .textAlignment(.left)
        .textColor(.text)
        .build()
    
    lazy var clearButton: UIButton = builder(UIButton.self)
        .setImage(#imageLiteral(resourceName: "delete"), for: .normal)
        .whenDidTapped { [weak self] button in
            self?.subscriber?.didTapClear(button: button)
        }
        .alpha(.semiOpaque)
        .build()
    
    var contentViewPlan: ViewPlan {
        keywordLabel.drf
            .left.vertical.equal(with: .safeArea).offset(by: .x8)
            .right.equal(to: clearButton.drf.left).offset(by: .x4)
        clearButton.drf
            .right.equal(with: .safeArea).offset(by: .x8)
            .centerY.equal(with: .parent)
            .size.equal(with: CGSize(width: .x8, height: .x8))
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .background
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        contentView.backgroundColor = .background
    }
    
    func bindData(from dataBinding: DataBinding) {
        dataBinding.keywordObservable
            .relayChanges(to: keywordLabel.bindables.text)
            .retained(by: self)
            .notifyWithCurrentValue()
    }
}

typealias KeywordCellViewModel = ViewModel & KeywordCellDataBinding & KeywordCellSubscriber

protocol KeywordCellVMDelegate: AnyObject {
    func keywordCellDidTapClear(_ viewModel: KeywordCellVM)
}

class KeywordCellVM: KeywordCellViewModel {
    typealias Subscriber = KeywordCellSubscriber
    typealias DataBinding = KeywordCellDataBinding
    
    @Subject var keyword: String?
    var keywordObservable: Observable<String?> { $keyword }
    
    weak var delegate: KeywordCellVMDelegate?
    
    init(keyword: String?, delegate: KeywordCellVMDelegate?) {
        self.keyword = keyword
        self.delegate = delegate
    }
    
    func didTapClear(button: UIButton) {
        delegate?.keywordCellDidTapClear(self)
    }
}
