//
//  SKCodeCompletionSessionResponse.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 12/17/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

public struct SKCodeCompletionSessionResponse {

    // MARK: - Public Declarations

    /// Represents a response type.
    public enum Kind {
        /// A response to an open request.
        case open
        /// A response to an update request.
        case update
        /// A response to a close request.
        case close
    }

    // MARK: - Public Stored Properties

    /// The type of the code completion session request.
    public let kind: Kind
    /// The code completion session options used for the request.
    ///
    /// - Note: The value is only `nil` for `Kind.close` requests.
    public let options: SKCodeCompletionSession.Options?
    /// The code completion response of the request.
    ///
    /// - Note: When a `Response` is passed to the completion handler, this value is only `nil` for
    ///         `Kind.close` requests. Otherwise, when passed to the error handler, always `nil`.
    public let codeCompletion: SKCodeCompletion?

}

// MARK: - Equatable Protocol

extension SKCodeCompletionSessionResponse: Equatable {}
