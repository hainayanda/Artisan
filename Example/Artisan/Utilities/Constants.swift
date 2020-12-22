//
//  Constants.swift
//  Artisan_Example
//
//  Created by Nayanda Haberty on 22/12/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

extension CGFloat {
    
    // MARK: Dimensions & Font
    static var x1: CGFloat { 1 }
    static var x2: CGFloat { 2 }
    static var x3: CGFloat { 3 }
    static var x4: CGFloat { 4 }
    static var x6: CGFloat { 6 }
    static var x8: CGFloat { 8 }
    static var x12: CGFloat { 12 }
    static var x16: CGFloat { 16 }
    static var x24: CGFloat { 24 }
    static var x32: CGFloat { 32 }
    static var x48: CGFloat { 48 }
    static var x64: CGFloat { 64 }
    static var x72: CGFloat { 72 }
    static var x96: CGFloat { 96 }
    static var x128: CGFloat { 128 }
    static var x160: CGFloat { 160 }
    static var x192: CGFloat { 192 }
    static var x256: CGFloat { 256 }
    static var x384: CGFloat { 384 }
    static var x512: CGFloat { 512 }
    static var x768: CGFloat { 768 }
    static var x1024: CGFloat { 1024 }
    static var x1536: CGFloat { 1536 }
    static var x2048: CGFloat { 2048 }
    static var x3072: CGFloat { 3072 }
    
    static var statusBarHeight: CGFloat { 60}
    
    // MARK: Transparency
    static var clear: CGFloat { 0 }
    static var tooClear: CGFloat { 0.1 }
    static var almostClear: CGFloat { 0.2 }
    static var semiClear: CGFloat { 0.4 }
    static var semiOpaque: CGFloat { 0.6 }
    static var almostOpaque: CGFloat { 0.8 }
    static var tooOpaque: CGFloat { 0.9 }
    static var opaque: CGFloat { 1 }
}

extension Float {
    // MARK: Transparency
    static var clear: Float { 0 }
    static var tooClear: Float { 0.1 }
    static var almostClear: Float { 0.2 }
    static var semiClear: Float { 0.4 }
    static var semiOpaque: Float { 0.6 }
    static var almostOpaque: Float { 0.8 }
    static var tooOpaque: Float { 0.9 }
    static var opaque: Float { 1 }
}

extension TimeInterval {
    
    // MARK: Animataion Duration
    static var zero: TimeInterval { 0 }
    static var instant: TimeInterval { 0.02 }
    static var almostInstant: TimeInterval { 0.06 }
    static var fastest: TimeInterval { 0.1 }
    static var faster: TimeInterval { 0.2 }
    static var fast: TimeInterval { 0.4 }
    static var fluid: TimeInterval { 0.6 }
    static var standard: TimeInterval { 0.8 }
    static var slow: TimeInterval { 1 }
    static var slower: TimeInterval { 2 }
    static var slowest: TimeInterval { 4 }
}

extension UIColor {
    static var main: UIColor = .init(red: 1, green: 0.52, blue: 0.28, alpha: 1)
    static var secondary: UIColor = .init(red: 0.16, green: 0.18, blue: 0.25, alpha: 1)
    static var text: UIColor = .init(red: 0.53, green: 0.56, blue: 0.66, alpha: 1)
    static var inactive: UIColor = .init(red: 0.82, green: 0.82, blue: 0.85, alpha: 1)
    static var background: UIColor = .init(red: 0.99, green: 0.99, blue: 1, alpha: 1)
}
