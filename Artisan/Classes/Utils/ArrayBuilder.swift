//
//  ArrayBuilder.swift
//  Artisan
//
//  Created by Nayanda Haberty on 28/05/22.
//

import Foundation

@resultBuilder
public struct ArrayBuilder<Element> {
    public typealias Expression = Element?
    public typealias Component = [Element]
    public typealias Result = [Element]
    
    public static func buildExpression(_ expression: Expression) -> Component {
        guard let expression = expression else {
            return []
        }
        return [expression]
    }
    
    public static func buildOptional(_ component: Component?) -> Component {
        component ?? []
    }
    
    public static func buildEither(first component: Component) -> Component {
        component
    }
    
    public static func buildEither(second component: Component) -> Component {
        component
    }
    
    public static func buildArray(_ components: [Component]) -> Component {
        components.reduce([]) { partialResult, component in
            var result = partialResult
            result.append(contentsOf: component)
            return result
        }
    }
    
    public static func buildBlock(_ components: Component...) -> Component {
        buildArray(components)
    }
    
    public static func buildFinalResult(_ component: Component) -> Result {
        return component
    }
}
