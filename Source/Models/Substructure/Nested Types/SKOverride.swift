//
//  SKOverride.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 12/5/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

public struct SKOverride {

    // MARK: - Internal Declarations

    enum CodingKeys: String, CodingKey {
        case usr = "key.usr"
    }

    // MARK: - Public Stored Properties

    /// The Unified Symbol Resolution (USR) of the overridden entity.
    public let usr: String

    // MARK: - Public Initializers

    public init(usr: String) {
        self.usr = usr
    }

}

// MARK: - Codable Protocol

extension SKOverride: Codable {}

// MARK: - Equatable Protocol

extension SKOverride: Equatable {

    public static func == (lhs: SKOverride, rhs: SKOverride) -> Bool {
        return lhs.usr == rhs.usr
    }

}

// MARK: - JSON Debug String Convertible Protocol

extension SKOverride: JSONDebugStringConvertible {}
