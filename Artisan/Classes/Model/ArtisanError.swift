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
    
    static func whenDiffReloading(failureReason: String? = nil) -> ArtisanError {
        .init(
            errorDescription: "Artisan Error: Error when reload by difference",
            failureReason: failureReason
        )
    }
}
#endif
