//
//  ObservableView.swift
//  Artisan
//
//  Created by Nayanda Haberty (ID) on 03/09/20.
//

import Foundation

extension ObservableView where Self: NSObject {
    public var observer: Observer? {
        getMediator() as? Observer
    }
}

extension ViewMediator: ObservingMediator {
    public func viewDidLayouted(_ view: Any) {
        guard let view = view as? View else { return }
        apply(to: view)
    }
}
