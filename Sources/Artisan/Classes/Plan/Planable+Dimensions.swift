//
//  Planable+Dimensions.swift
//  Artisan
//
//  Created by Nayanda Haberty (ID) on 27/08/20.
//

import Foundation

#if canImport(UIKit)
public extension Planer {
    
    // MARK: Height Anchor
    
    @discardableResult
    func height(_ relation: InterRelation<NSLayoutDimension>, multiplyBy multipier: CGFloat, constant: CGFloat, priority: UILayoutPriority) -> Self {
        let constraint: NSLayoutConstraint
        switch relation {
        case .moreThanTo(let dimension):
            constraint = view.heightAnchor.constraint(greaterThanOrEqualTo: dimension, multiplier: multipier, constant: constant)
        case .lessThanTo(let dimension):
            constraint = view.heightAnchor.constraint(lessThanOrEqualTo: dimension, multiplier: multipier, constant: constant)
        case .equalTo(let dimension):
            constraint = view.heightAnchor.constraint(equalTo: dimension, multiplier: multipier, constant: constant)
        }
        constraint.priority = priority
        constraint.identifier = "artisan_\(view.uniqueKey)_height_to_\(identifier(ofSecondItemIn: constraint))"
        plannedConstraints.removeAll { $0.identifier == constraint.identifier }
        plannedConstraints.append(constraint)
        return self
    }
    
    @discardableResult
    func height(_ relation: InterRelation<NSLayoutDimension>, multiplyBy multipier: CGFloat = 1, constant: CGFloat = 0, priority: UILayoutPriority? = nil) -> Self {
        let priority = priority ?? context.mutatingPriority
        return height(relation, multiplyBy: multipier, constant: constant, priority: priority)
    }
    
    @discardableResult
    func height(_ relation: InterRelation<RelatedAnchor<NSLayoutDimension>>, multiplyBy multipier: CGFloat = 1, constant: CGFloat = 0, priority: UILayoutPriority? = nil) -> Self {
        guard let offsetedAnchor = relation.related.getOffsettedAnchor(from: context) else {
            context.delegate.planer(
                view,
                errorWhenPlanning: .whenCreateConstraints(
                    of: Self.self,
                    failureReason: "Failed to get anchor of anonymous relation"
                )
            )
            return self
        }
        return height(relation.mapped { _ in offsetedAnchor.anchor }, multiplyBy: multipier, constant: offsetedAnchor.offset + constant, priority: priority)
    }
    
    @discardableResult
    func height(_ relation: InterRelation<AnonymousRelation>, _ dimension: LayoutDimension, multiplyBy multipier: CGFloat, constant: CGFloat, priority: UILayoutPriority) -> Self {
        guard let relatedView = getView(from: relation.related) else {
            context.delegate.planer(
                view,
                errorWhenPlanning: .whenCreateConstraints(
                    of: Self.self,
                    failureReason: "Failed to get related relation"
                )
            )
            return self
        }
        switch relation {
        case .moreThanTo(let related):
            if related.isView {
                height(.moreThanTo(relatedView.anchor(of: dimension)), multiplyBy: multipier, constant: constant, priority: priority)
            } else if #available(iOS 11.0, *) {
                height(.moreThanTo(relatedView.safeAreaLayoutGuide.anchor(of: dimension)), multiplyBy: multipier, constant: constant, priority: priority)
            } else {
                let layoutMargins = relatedView.layoutMargins
                let totalMargin = dimension == .height ? layoutMargins.top + layoutMargins.bottom : layoutMargins.left + layoutMargins.right
                height(.moreThanTo(relatedView.anchor(of: dimension)), multiplyBy: multipier, constant: constant - totalMargin, priority: priority)
            }
        case .lessThanTo(let related):
            if related.isView {
                height(.lessThanTo(relatedView.anchor(of: dimension)), multiplyBy: multipier, constant: constant, priority: priority)
            } else if #available(iOS 11.0, *) {
                height(.lessThanTo(relatedView.safeAreaLayoutGuide.anchor(of: dimension)), multiplyBy: multipier, constant: constant, priority: priority)
            } else {
                let layoutMargins = relatedView.layoutMargins
                let totalMargin = dimension == .height ? layoutMargins.top + layoutMargins.bottom : layoutMargins.left + layoutMargins.right
                height(.lessThanTo(relatedView.anchor(of: dimension)), multiplyBy: multipier, constant: constant - totalMargin, priority: priority)
            }
        case .equalTo(let related):
            if related.isView {
                height(.equalTo(relatedView.anchor(of: dimension)), multiplyBy: multipier, constant: constant, priority: priority)
            } else if #available(iOS 11.0, *) {
                height(.equalTo(relatedView.safeAreaLayoutGuide.anchor(of: dimension)), multiplyBy: multipier, constant: constant, priority: priority)
            } else {
                let layoutMargins = relatedView.layoutMargins
                let totalMargin = dimension == .height ? layoutMargins.top + layoutMargins.bottom : layoutMargins.left + layoutMargins.right
                height(.equalTo(relatedView.anchor(of: dimension)), multiplyBy: multipier, constant: constant - totalMargin, priority: priority)
            }
        }
        return self
    }
    
    @discardableResult
    func height(_ relation: InterRelation<AnonymousRelation>, _ dimension: LayoutDimension, multiplyBy multipier: CGFloat = 1, constant: CGFloat = 0, priority: UILayoutPriority? = nil) -> Self {
        let priority = priority ?? context.mutatingPriority
        return width(relation, dimension, multiplyBy: multipier, constant: constant, priority: priority)
    }
    
    @discardableResult
    func height(_ relation: InterRelation<AnonymousRelation>, multiplyBy multipier: CGFloat, constant: CGFloat, priority: UILayoutPriority) -> Self {
        return height(relation, .height, multiplyBy: multipier, constant: constant, priority: priority)
    }
    
    @discardableResult
    func height(_ relation: InterRelation<AnonymousRelation>, multiplyBy multipier: CGFloat = 1, constant: CGFloat = 0, priority: UILayoutPriority? = nil) -> Self {
        let priority = priority ?? context.mutatingPriority
        return height(relation, multiplyBy: multipier, constant: constant, priority: priority)
    }
    
    @discardableResult
    func height(_ relation: InterRelation<CGFloat>, priority: UILayoutPriority) -> Self {
        let constraint: NSLayoutConstraint
        let identifier: String
        switch relation {
        case .moreThanTo(let dimension):
            identifier = "more_than_dimension"
            constraint = view.heightAnchor.constraint(greaterThanOrEqualToConstant: dimension)
        case .lessThanTo(let dimension):
            identifier = "less_than_dimension"
            constraint = view.heightAnchor.constraint(lessThanOrEqualToConstant: dimension)
        case .equalTo(let dimension):
            identifier = "equal_with_dimension"
            constraint = view.heightAnchor.constraint(equalToConstant: dimension)
        }
        constraint.priority = priority
        constraint.identifier = "artisan_\(view.uniqueKey)_height_\(identifier)"
        plannedConstraints.removeAll { $0.identifier == constraint.identifier }
        plannedConstraints.append(constraint)
        return self
    }
    
    @discardableResult
    func height(_ relation: InterRelation<CGFloat>) -> Self {
        return height(relation, priority: context.mutatingPriority)
    }
    
    // MARK: Width Anchor
    
    @discardableResult
    func width(_ relation: InterRelation<NSLayoutDimension>, multiplyBy multipier: CGFloat, constant: CGFloat, priority: UILayoutPriority) -> Self {
        let constraint: NSLayoutConstraint
        switch relation {
        case .moreThanTo(let dimension):
            constraint = view.widthAnchor.constraint(greaterThanOrEqualTo: dimension, multiplier: multipier, constant: constant)
        case .lessThanTo(let dimension):
            constraint = view.widthAnchor.constraint(lessThanOrEqualTo: dimension, multiplier: multipier, constant: constant)
        case .equalTo(let dimension):
            constraint = view.widthAnchor.constraint(equalTo: dimension, multiplier: multipier, constant: constant)
        }
        constraint.priority = priority
        constraint.identifier = "artisan_\(view.uniqueKey)_width_to_\(identifier(ofSecondItemIn: constraint))"
        plannedConstraints.removeAll { $0.identifier == constraint.identifier }
        plannedConstraints.append(constraint)
        return self
    }
    
    @discardableResult
    func width(_ relation: InterRelation<NSLayoutDimension>, multiplyBy multipier: CGFloat = 1, constant: CGFloat = 0, priority: UILayoutPriority? = nil) -> Self {
        return width(relation, multiplyBy: multipier, constant: constant, priority: priority ?? context.mutatingPriority)
    }
    
    @discardableResult
    func width(_ relation: InterRelation<RelatedAnchor<NSLayoutDimension>>, multiplyBy multipier: CGFloat = 1, constant: CGFloat = 0, priority: UILayoutPriority? = nil) -> Self {
        guard let offsetedAnchor = relation.related.getOffsettedAnchor(from: context) else {
            context.delegate.planer(
                view,
                errorWhenPlanning: .whenCreateConstraints(
                    of: Self.self,
                    failureReason: "Failed to get anchor of anonymous relation"
                )
            )
            return self
        }
        return width(relation.mapped { _ in offsetedAnchor.anchor }, multiplyBy: multipier, constant: offsetedAnchor.offset + constant, priority: priority)
    }
    
    @discardableResult
    func width(_ relation: InterRelation<AnonymousRelation>, _ dimension: LayoutDimension, multiplyBy multipier: CGFloat, constant: CGFloat, priority: UILayoutPriority) -> Self {
        guard let relatedView = getView(from: relation.related) else {
            context.delegate.planer(
                view,
                errorWhenPlanning: .whenCreateConstraints(
                    of: Self.self,
                    failureReason: "Failed to get related relation"
                )
            )
            return self
        }
        switch relation {
        case .moreThanTo(let related):
            if related.isView {
                width(.moreThanTo(relatedView.anchor(of: dimension)), multiplyBy: multipier, constant: constant, priority: priority)
            } else if #available(iOS 11.0, *) {
                width(.moreThanTo(relatedView.safeAreaLayoutGuide.anchor(of: dimension)), multiplyBy: multipier, constant: constant, priority: priority)
            } else {
                let layoutMargins = relatedView.layoutMargins
                let totalMargin = dimension == .height ? layoutMargins.top + layoutMargins.bottom : layoutMargins.left + layoutMargins.right
                width(.moreThanTo(relatedView.anchor(of: dimension)), multiplyBy: multipier, constant: constant - totalMargin, priority: priority)
            }
        case .lessThanTo(let related):
            if related.isView {
                width(.lessThanTo(relatedView.anchor(of: dimension)), multiplyBy: multipier, constant: constant, priority: priority)
            } else if #available(iOS 11.0, *) {
                width(.lessThanTo(relatedView.safeAreaLayoutGuide.anchor(of: dimension)), multiplyBy: multipier, constant: constant, priority: priority)
            } else {
                let layoutMargins = relatedView.layoutMargins
                let totalMargin = dimension == .height ? layoutMargins.top + layoutMargins.bottom : layoutMargins.left + layoutMargins.right
                width(.lessThanTo(relatedView.anchor(of: dimension)), multiplyBy: multipier, constant: constant - totalMargin, priority: priority)
            }
        case .equalTo(let related):
            if related.isView {
                width(.equalTo(relatedView.anchor(of: dimension)), multiplyBy: multipier, constant: constant, priority: priority)
            } else if #available(iOS 11.0, *) {
                width(.equalTo(relatedView.safeAreaLayoutGuide.anchor(of: dimension)), multiplyBy: multipier, constant: constant, priority: priority)
            } else {
                let layoutMargins = relatedView.layoutMargins
                let totalMargin = dimension == .height ? layoutMargins.top + layoutMargins.bottom : layoutMargins.left + layoutMargins.right
                width(.equalTo(relatedView.anchor(of: dimension)), multiplyBy: multipier, constant: constant - totalMargin, priority: priority)
            }
        }
        return self
    }
    
    @discardableResult
    func width(_ relation: InterRelation<AnonymousRelation>, _ dimension: LayoutDimension, multiplyBy multipier: CGFloat = 1, constant: CGFloat = 0, priority: UILayoutPriority? = nil) -> Self {
        let priority = priority ?? context.mutatingPriority
        return width(relation, dimension, multiplyBy: multipier, constant: constant, priority: priority)
    }
    
    @discardableResult
    func width(_ relation: InterRelation<AnonymousRelation>, multiplyBy multipier: CGFloat, constant: CGFloat, priority: UILayoutPriority) -> Self {
        return width(relation, .width, multiplyBy: multipier, constant: constant, priority: priority)
    }
    
    @discardableResult
    func width(_ relation: InterRelation<AnonymousRelation>, multiplyBy multipier: CGFloat = 1, constant: CGFloat = 0, priority: UILayoutPriority? = nil) -> Self {
        let priority = priority ?? context.mutatingPriority
        return width(relation, multiplyBy: multipier, constant: constant, priority: priority)
    }
    
    @discardableResult
    func width(_ relation: InterRelation<CGFloat>, priority: UILayoutPriority) -> Self {
        let constraint: NSLayoutConstraint
        let identifier: String
        switch relation {
        case .moreThanTo(let dimension):
            identifier = "more_than_dimension"
            constraint = view.widthAnchor.constraint(greaterThanOrEqualToConstant: dimension)
        case .lessThanTo(let dimension):
            identifier = "less_than_dimension"
            constraint = view.widthAnchor.constraint(lessThanOrEqualToConstant: dimension)
        case .equalTo(let dimension):
            identifier = "equal_with_dimension"
            constraint = view.widthAnchor.constraint(equalToConstant: dimension)
        }
        constraint.priority = priority
        constraint.identifier = "artisan_\(view.uniqueKey)_width_\(identifier)"
        plannedConstraints.removeAll { $0.identifier == constraint.identifier }
        plannedConstraints.append(constraint)
        return self
    }
    
    @discardableResult
    func width(_ relation: InterRelation<CGFloat>) -> Self {
        return width(relation, priority: context.mutatingPriority)
    }
}
#endif