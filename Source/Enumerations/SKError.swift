//
//  SKError.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 12/5/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

import SourceKittenFramework

public enum SKError: LocalizedError {
    /// Thrown when a SourceKit request fails.
    ///
    /// The associated value is a representation of the SOURCEKITD_ERROR_*.
    case sourceKitRequestFailed(Request.Error)
    /// Thrown when an error occurs during the decoding of a value.
    ///
    /// The associated value is a string that describes the error.
    case jsonDecodingFailed(String)
    /// Thrown when an error occurs during the encoding of a value.
    ///
    /// The associated value is a string that describes the error.
    case jsonEncodingFailed(String)
    /// Thrown when encoding a JSON string to `Data` fails.
    case jsonDataEncodingFailed
    #if XPC
    /// Thrown when SourceKitten or the XPC service crashes.
    case sourceKittenCrashed
    #endif
    /// Thrown when an unknown error occurs.
    ///
    /// The associated value is a string that describes the error.
    case unknown(String)

    // MARK: - Convenience Initializers

    /// Creates a `SKError.jsonDecodingFailed(_)` error from a `DecodingError`.
    ///
    /// - Parameter error: The decoding error to create an `SKError` for.
    /// - Returns: A `SKError.jsonDecodingFailed(_)` error created from the `error`.
    public static func jsonDecodingFailed(error: DecodingError) -> SKError {
        return .jsonDecodingFailed((error as NSError).description)
    }

    /// Creates a `SKError.jsonEncodingFailed(_)` error from an `EncodingError`.
    ///
    /// - Parameter error: The encoding error to create an `SKError` for.
    /// - Returns: A `SKError.jsonEncodingFailed(_)` error created from the `error`.
    public static func jsonEncodingFailed(error: EncodingError) -> SKError {
        return .jsonEncodingFailed((error as NSError).description)
    }

    /// Creates a `SKError.unknown(_)` error from an `Error`.
    ///
    /// - Parameter error: The error to create an `SKError` for.
    /// - Returns: A `SKError.unknown(_)` error created from the `error`.
    public static func unknown(error: Error) -> SKError {
        return .unknown((error as NSError).description)
    }

}
