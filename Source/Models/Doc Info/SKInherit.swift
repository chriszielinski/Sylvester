//
//  SKInherit.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 1/28/19.
//  Copyright © 2019 Big Z Labs. All rights reserved.
//

public struct SKInherit {

    // MARK: - Internal Declarations

    enum CodingKeys: String, CodingKey {
        case name = "key.name"
        case kind = "key.kind"
        case usr = "key.usr"
        case moduleName = "key.modulename"
    }

    // MARK: - Public Type Aliases

    public typealias Kind = SKSourceKind

    // MARK: - Public Stored Properties

    /// The displayed name for the entity.
    public let name: String?
    /// The UID for the declaration or reference kind (function, class, etc.).
    public let kind: Kind
    /// The Unified Symbol Resolution (USR) string for the entity.
    public let usr: String
    /// The module that contains the entity.
    public let moduleName: String?

}

// MARK: - Codable Protocol

extension SKInherit: Codable {}

// MARK: - Equatable Protocol

extension SKInherit: Equatable {}

// MARK: - JSON Debug String Convertible Protocol

extension SKInherit: JSONDebugStringConvertible {}
