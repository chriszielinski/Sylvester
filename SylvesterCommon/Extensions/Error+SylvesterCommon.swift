//
//  Error.swift
//  SylvesterCommon 😼
//
//  Created by Chris Zielinski on 12/15/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

public extension Error {

    /// The receiver is expected to already be a `SKXPCError` or a `SKError`.
    /// If the receiver is neither, it is wrapped in a `SKXPCError.unknown` error.
    ///
    /// - Returns: The error as a `SKXPCError`.
    func toSKXPCError() -> SKXPCError {
        if let xpcError = self as? SKXPCError {
            return xpcError
        } else if let skError = self as? SKError {
            return SKXPCError(error: skError)
        }

        return SKXPCError.unknown(self)
    }

    /// The receiver is expected to already be a `SKError` or a `SKXPCError`.
    /// If the receiver is neither, it is wrapped in a `SKError.unknown` error.
    ///
    /// - Returns: The error as a `SKXPCError`.
    func toSKError() -> SKError {
        if let skError = self as? SKError {
            return skError
        } else if let xpcError = self as? SKXPCError {
            return xpcError.bridge
        }

        return SKError.unknown(error: self)
    }

}
