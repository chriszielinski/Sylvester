//
//  SKInheritedType.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 12/5/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

public struct SKInheritedType {

    // MARK: - Internal Declarations

    enum CodingKeys: String, CodingKey {
        case name = "key.name"
    }

    // MARK: - Public Stored Properties

    /// The name of the inherited type.
    public let name: String

    // MARK: - Public Initializers

    public init(name: String) {
        self.name = name
    }

}

// MARK: - Codable Protocol

extension SKInheritedType: Codable {}

// MARK: - Equatable Protocol

extension SKInheritedType: Equatable {

    public static func == (lhs: SKInheritedType, rhs: SKInheritedType) -> Bool {
        return lhs.name == rhs.name
    }

}

// MARK: - JSON Debug String Convertible Protocol

extension SKInheritedType: JSONDebugStringConvertible {}
