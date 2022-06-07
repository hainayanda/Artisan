//
//  MockView.swift
//  Artisan_Tests
//
//  Created by Nayanda Haberty on 06/06/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import Artisan

class MockView: ViewBindable {
    
    typealias Model = MockVM
    
    init(willBind: @escaping (Model, Model?) -> Void = { _, _ in }, needBind: @escaping (Model) -> Void = { _ in }, didBind: @escaping (Model, Model?) -> Void = { _, _ in }) {
        self.willBind = willBind
        self.needBind = needBind
        self.didBind = didBind
    }
    
    var willBind: (Model, Model?) -> Void
    func viewWillBind(with newModel: Model, oldModel: Model?) {
        willBind(newModel, oldModel)
    }
    
    var needBind: (Model) -> Void
    func viewNeedBind(with model: Model) {
        needBind(model)
    }
    
    var didBind: (Model, Model?) -> Void
    func viewDidBind(with newModel: Model, oldModel: Model?) {
        didBind(newModel, oldModel)
    }
}

class MockVM: ViewModel {
    init(will: @escaping () -> Void = { }, did: @escaping () -> Void = { }, willUn: @escaping () -> Void = { }, didUn: @escaping () -> Void = { }) {
        self.will = will
        self.did = did
        self.willUn = willUn
        self.didUn = didUn
    }
    
    
    var will: () -> Void
    func willBind() {
        will()
    }
    var did: () -> Void
    func didBind() {
        did()
    }
    var willUn: () -> Void
    func willUnbind() {
        willUn()
    }
    var didUn: () -> Void
    func didUnbind() {
        didUn()
    }
}
