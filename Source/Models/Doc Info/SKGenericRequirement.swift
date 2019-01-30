//
//  SKGenericRequirement.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 1/28/19.
//  Copyright © 2019 Big Z Labs. All rights reserved.
//

public struct SKGenericRequirement {

    // MARK: - Internal Declarations

    enum CodingKeys: String, CodingKey {
        case description = "key.description"
    }

    // MARK: - Public Stored Properties

    /// The generic requirement.
    public let description: String

}

// MARK: - Codable Protocol

extension SKGenericRequirement: Codable {}

// MARK: - Equatable Protocol

extension SKGenericRequirement: Equatable {}

// MARK: - JSON Debug String Convertible Protocol

extension SKGenericRequirement: JSONDebugStringConvertible {}
