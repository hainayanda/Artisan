//
//  StackBuilder.swift
//  Artisan
//
//  Created by Nayanda Haberty on 28/05/22.
//

import Foundation
#if canImport(UIKit)
import UIKit
import Draftsman
import Pharos
import DifferenceKit

public protocol ArrangedStackDraft: StackDraft {
    func arranged<Item>(from items: [Item], @LayoutPlan _ layouter: (Int, Item) -> ViewPlan) -> Self
}

extension LayoutDraft: ArrangedStackDraft where View: StackCompatible {
    
    public func arranged<Item>(from items: [Item], @LayoutPlan _ layouter: (Int, Item) -> ViewPlan) -> Self {
        insertStacked {
            for item in items.enumerated() {
                layouter(item.offset, item.element)
            }
        }
    }
}

extension ConstraintBuilderRootRecoverable where Root: ArrangedStackDraft {
    public func arranged<Item>(from items: [Item], @LayoutPlan _ layouter: (Int, Item) -> ViewPlan) -> Root {
        backToRoot {
            $0.arranged(from: items, layouter)
        }
    }
}
#endif
