//
//  Observable+Binding.swift
//  Artisan
//
//  Created by Nayanda Haberty on 03/07/22.
//

import Foundation
import Pharos
import Draftsman
#if canImport(UIKit)

extension Observable {
    public func bindToPlan<View: Planned>(of view: View) -> Observed<State> {
        whenDidSet { [weak view] _ in
            guard let view = view else { return }
            view.applyPlan()
        }.observe(on: .main)
    }
}
#endif
