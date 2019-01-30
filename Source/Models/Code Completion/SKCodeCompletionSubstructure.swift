//
//  SKCodeCompletionSubstructure.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 12/16/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

public struct SKCodeCompletionSubstructure {

    // MARK: - Internal Declarations

    enum CodingKeys: String, CodingKey {
        case nameOffset = "key.nameoffset"
        case nameLength = "key.namelength"
        case bodyOffset = "key.bodyoffset"
        case bodyLength = "key.bodylength"
        case substructures = "key.substructure"
    }

    // MARK: - Public Stored Properties

    /// The byte offset location of the given parameter.
    public let nameOffset: Int?
    /// The byte length of the given parameter.
    public let nameLength: Int?
    /// The `nameoffset` + the indentation inside the body of the file.
    public let bodyOffset: Int?
    /// The `namelength` + the indentation inside the body of the file.
    public let bodyLength: Int?
    /// An array of `SKCodeCompletionSubstructure` representing ranges of structural elements in the item description,
    /// such as the parameters of a function.
    public let substructures: [SKCodeCompletionSubstructure]?

}

// MARK: - JSON Debug String Convertable Protocol

extension SKCodeCompletionSubstructure: JSONDebugStringConvertible {}

// MARK: - Codable Protocol

extension SKCodeCompletionSubstructure: Codable {}

// MARK: - Equatable Protocol

extension SKCodeCompletionSubstructure: Equatable {}
