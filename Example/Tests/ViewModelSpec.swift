//
//  ViewModelSpec.swift
//  Artisan_Example
//
//  Created by Nayanda Haberty on 06/06/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Artisan

enum VMState {
    case willBind
    case didBind
    case willUnbind
    case didUnbind
}

class ViewModelSpec: QuickSpec {
    
    override func spec() {
        it("should run lifecycle") {
            var state: [VMState] = []
            let vm = MockVM {
                state.append(.willBind)
            } did: {
                state.append(.didBind)
            } willUn: {
                state.append(.willUnbind)
            } didUn: {
                state.append(.didUnbind)
            }
            let view = MockView()
            view.bind(with: vm)
            expect(state).to(equal([.willBind, .didBind]))
            view.bind(with: MockVM())
            expect(state).to(equal([.willBind, .didBind, .willUnbind, .didUnbind]))
        }
    }
}
