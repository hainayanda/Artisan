//
//  ViewBindableSpec.swift
//  Artisan_Example
//
//  Created by Nayanda Haberty on 06/06/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import Artisan

class ViewBindableSpec: QuickSpec {
    
    override func spec() {
        it("should bind with model") {
            let model1: String = "one"
            let model2: String = "two"
            var currentModel = model1
            let view = View { newModel, oldModel in
                if oldModel == nil {
                    expect(newModel).to(equal(model1))
                } else {
                    expect(newModel).to(equal(model2))
                    expect(oldModel).to(equal(model1))
                }
            } needBind: { model in
                expect(model).to(equal(currentModel))
            } didBind: { newModel, oldModel in
                if oldModel == nil {
                    expect(newModel).to(equal(model1))
                } else {
                    expect(newModel).to(equal(model2))
                    expect(oldModel).to(equal(model1))
                }
            }
            view.bind(with: currentModel)
            expect(view.model).to(equal(currentModel))
            currentModel = model2
            view.bind(with: currentModel)
            expect(view.model).to(equal(currentModel))
        }
        it("should release object when rebinding") {
            let view = View()
            view.bind(with: "some")
            var retained: Retained? = Retained()
            weak var weakRetained: Retained? = retained
            view.bindingRetainer.retain(retained!)
            retained = nil
            expect(weakRetained).toNot(beNil())
            view.bind(with: "some new")
            expect(weakRetained).to(beNil())
        }
    }
}

fileprivate class Retained { }

class View: ViewBindable {
    
    typealias Model = String
    
    init(willBind: @escaping (String, String?) -> Void = { _, _ in }, needBind: @escaping (String) -> Void = { _ in }, didBind: @escaping (String, String?) -> Void = { _, _ in }) {
        self.willBind = willBind
        self.needBind = needBind
        self.didBind = didBind
    }
    
    var willBind: (String, String?) -> Void
    func viewWillBind(with newModel: String, oldModel: String?) {
        willBind(newModel, oldModel)
    }
    
    var needBind: (String) -> Void
    func viewNeedBind(with model: String) {
        needBind(model)
    }
    
    var didBind: (String, String?) -> Void
    func viewDidBind(with newModel: String, oldModel: String?) {
        didBind(newModel, oldModel)
    }
}
