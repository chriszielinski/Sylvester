//
//  SKByteRange.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 12/7/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

open class SKByteRange: Codable, Equatable {

    // MARK: - Private Declarations

    private enum CodingKeys: String, CodingKey {
        case offset = "key.offset"
        case length = "key.length"
    }

    // MARK: - Public Stored Properties

    public let offset: Int
    public let length: Int

    // MARK: - Public Initializers

    public init(offset: Int, length: Int) {
        self.offset = offset
        self.length = length
    }

    // MARK: - Equatable Protocol

    open func isEqual(to rhs: SKByteRange) -> Bool {
        return offset == rhs.offset && length == rhs.length
    }

    public static func == (lhs: SKByteRange, rhs: SKByteRange) -> Bool {
        return lhs.isEqual(to: rhs)
    }

}

// MARK: - Byte Range Convertible Protocol

extension SKByteRange: ByteRangeConvertible {}

// MARK: - JSON Debug String Convertible Protocol

extension SKByteRange: JSONDebugStringConvertible {}
