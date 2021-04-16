//
//  ObservableView.swift
//  Artisan
//
//  Created by Nayanda Haberty (ID) on 03/09/20.
//

import Foundation
#if canImport(UIKit)

public protocol ObservableView {
    associatedtype Observer
    var observer: Observer? { get }
}

extension ObservableView where Self: NSObject {
    public var observer: Observer? {
        getMediator() as? Observer
    }
}
#endif
