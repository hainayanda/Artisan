//
//  ArtisanError.swift
//  Artisan
//
//  Created by Nayanda Haberty (ID) on 27/08/20.
//

import Foundation

#if canImport(UIKit)
public struct ArtisanError: LocalizedError {
    
    /// Description of error
    public let errorDescription: String?
    
    /// Reason of failure
    public let failureReason: String?
    
    init(errorDescription: String, failureReason: String? = nil) {
        self.errorDescription = errorDescription
        self.failureReason = failureReason
    }
}

extension ArtisanError {
    static func whenFitting<Fitted, ToFit: PlanCompatible>(_ toFitType: ToFit.Type, into type: Fitted.Type, failureReason: String? = nil) -> ArtisanError {
        .init(
            errorDescription: "Artisan Error: Error when fitting \(String(describing: toFitType)) into \(type)",
            failureReason: failureReason
        )
    }
    
    static func whenCreateConstraints<Constrained>(of type: Constrained.Type, failureReason: String? = nil) -> ArtisanError {
        .init(
            errorDescription: "Artisan Error: Error when creating constraint of \(String(describing: type))",
            failureReason: failureReason
        )
    }
    
    static func whenDiffReloading(failureReason: String? = nil) -> ArtisanError {
        .init(
            errorDescription: "Artisan Error: Error when reload by difference",
            failureReason: failureReason
        )
    }
}
#endif
