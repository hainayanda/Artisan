//
//  KeywordCellVM.swift
//  Artisan_Example
//
//  Created by Nayanda Haberty on 06/06/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import Pharos
import UIKit

// MARK: Delegate Protocol

protocol KeywordCellVMDelegate: AnyObject {
    func keywordCellDidTapClear(_ viewModel: KeywordCellVM)
}

// MARK: View

struct KeywordCellVM: KeywordCellViewModel {
    
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
