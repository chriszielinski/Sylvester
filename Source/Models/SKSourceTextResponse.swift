//
//  SKSourceTextResponse.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 2/26/19.
//  Copyright © 2019 Big Z Labs. All rights reserved.
//

/// Represents a _SourceKit_ source text response.
open class SKSourceTextResponse: Codable {

    // MARK: - Internal Declarations

    enum CodingKeys: String, CodingKey {
        case sourceText = "key.sourcetext"
    }

    // MARK: - Public Stored Properties

    /// The source text of the response.
    public let sourceText: String

    // MARK: - Public Initializers

    /// Creates a new `SKSourceTextResponse` object.
    ///
    /// - Parameter sourceText: The source text of the response.
    public init(sourceText: String) {
        self.sourceText = sourceText
    }

}

// MARK: - Equatable Protocol

extension SKSourceTextResponse: Equatable {

    public static func == (lhs: SKSourceTextResponse, rhs: SKSourceTextResponse) -> Bool {
        return lhs.sourceText == rhs.sourceText
    }

}

// MARK: - JSON Debug String Convertible Protocol

extension SKSourceTextResponse: JSONDebugStringConvertible {}
