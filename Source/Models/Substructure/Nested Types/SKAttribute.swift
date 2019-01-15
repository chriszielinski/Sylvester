//
//  SKAttribute.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 12/5/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

open class SKAttribute: SKEntity {

    // MARK: - Internal Declarations

    enum CodingKeys: String, CodingKey {
        case attribute = "key.attribute"
    }

    // MARK: - Public Type Aliases

    public typealias Kind = SKAttributeKind

    // MARK: - Public Stored Properties

    /// The kind of the attribute.
    public let kind: Kind

    // MARK: - Public Initializers

    public init(kind: Kind, offset: Int, length: Int) {
        self.kind = kind

        super.init(offset: offset, length: length)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        kind = try container.decode(forKey: .attribute)

        try super.init(from: decoder)
    }

    // MARK: - Overridden Methods

    open override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(kind, forKey: .attribute)

        try super.encode(to: encoder)
    }

}

// MARK: - Custom Debug String Convertible Protocol

extension SKAttribute: CustomDebugStringConvertible {

    public var debugDescription: String {
        return "Attribute(kind: \"\(String(reflecting: kind))\", offset: \(offset), length: \(length))"
    }

}

// MARK: - Equatable Protocol

extension SKAttribute: Equatable {

    public static func == (lhs: SKAttribute, rhs: SKAttribute) -> Bool {
        return lhs.kind == rhs.kind && lhs.offset == rhs.offset && lhs.length == rhs.length
    }

}

// MARK: - SKEntities<SKAttribute> Methods

extension SKEntities where Entity: SKAttribute {

    /// Returns the attribute with the specified kind, or `nil` if nonexistent.
    ///
    /// - Parameter kind: The kind of the attribute to return.
    /// - Returns: The `SKAttribute`, or `nil` if nonexistent.
    public func attribute(with kind: SKAttribute.Kind) -> SKAttribute? {
        return entities.first(where: { $0.kind == kind })
    }

    /// Returns whether the specified attribute kind is a member of the array.
    ///
    /// - Parameter kind: The kind of the attribute.
    /// - Returns: `true` if the attribute kind is a member of the array; otherwise, `false`.
    public func containsAttribute(with kind: SKAttribute.Kind) -> Bool {
        return attribute(with: kind) != nil
    }

}
