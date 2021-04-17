//
//  CellMediator.swift
//  Artisan
//
//  Created by Nayanda Haberty (ID) on 11/08/20.
//

import Foundation
#if canImport(UIKit)
import UIKit

public protocol CellMediator: AnyMediator, Distinctable {
    static var cellViewClass: AnyClass { get }
    static var cellReuseIdentifier: String { get }
    func isSame(with other: CellMediator) -> Bool
    func isNotSame(with other: CellMediator) -> Bool
    func isCompatible<CellType: UIView>(with cell: CellType) -> Bool
}

public extension CellMediator {
    var cellClass: AnyClass { Self.cellViewClass }
    var reuseIdentifier: String { Self.cellReuseIdentifier }
    func isNotSame(with other: CellMediator) -> Bool {
        !isSame(with: other)
    }
}
#endif
