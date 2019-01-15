//
//  SKEntity.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 12/7/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

open class SKEntity: Codable {

    // MARK: - Private Declarations

    private enum CodingKeys: String, CodingKey {
        case offset = "key.offset"
        case length = "key.length"
    }

    // MARK: - Public Stored Properties

    /// The byte offset of the entity inside the source contents.
    public let offset: Int
    /// The byte length of the entity inside the source contents.
    public let length: Int

    // MARK: - Public Initializers

    public init(offset: Int, length: Int) {
        self.offset = offset
        self.length = length
    }

    // MARK: - Codable Protocol

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        offset = try container.decode(forKey: .offset)
        length = try container.decode(forKey: .length)
    }

    open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(offset, forKey: .offset)
        try container.encode(length, forKey: .length)
    }

}
