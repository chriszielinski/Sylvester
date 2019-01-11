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

    public let usr: String

    // MARK: - Public Initializers

    public init(usr: String) {
        self.usr = usr
    }

}

// MARK: - Codable Protocol

extension SKOverride: Codable {}

// MARK: - Custom Debug String Convertible Protocol

extension SKOverride: CustomDebugStringConvertible {

    public var debugDescription: String {
        return "Override(usr: \"\(usr)\")"
    }

}

// MARK: - Equatable Protocol

extension SKOverride: Equatable {

    public static func == (lhs: SKOverride, rhs: SKOverride) -> Bool {
        return lhs.usr == rhs.usr
    }

}
