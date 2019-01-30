//
//  SKGenericParameter.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 1/28/19.
//  Copyright © 2019 Big Z Labs. All rights reserved.
//

public struct SKGenericParameter {

    // MARK: - Internal Declarations

    enum CodingKeys: String, CodingKey {
        case name = "key.name"
    }

    // MARK: - Public Stored Properties

    /// The name of the generic parameter.
    public let name: String

}

// MARK: - Codable Protocol

extension SKGenericParameter: Codable {}

// MARK: - Equatable Protocol

extension SKGenericParameter: Equatable {}

// MARK: - JSON Debug String Convertible Protocol

extension SKGenericParameter: JSONDebugStringConvertible {}
