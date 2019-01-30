//
//  SKAttribute.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 12/5/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

open class SKAttribute: SKGenericKindEntity<SKAttribute.Kind> {

    // MARK: - Internal Declarations

    enum CodingKeys: String, CodingKey {
        case attribute = "key.attribute"
    }

    // MARK: - Public Type Aliases

    public typealias Kind = SKAttributeKind

    // MARK: - Public Initializers

    override public init(kind: Kind, offset: Int, length: Int) {
        super.init(kind: kind, offset: offset, length: length)
    }

    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        kind = try container.decode(forKey: .attribute)
    }

    // MARK: - Overridden Methods

    open override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(kind, forKey: .attribute)

        try super.encode(to: encoder)
    }

}

// MARK: - SKSortedEntities<SKAttribute> Methods

extension SKSortedEntities where Entity: SKAttribute {

    /// Returns the attribute with the specified kind, or `nil` if nonexistent.
    ///
    /// - Parameter kind: The kind of the attribute to return.
    /// - Returns: The `SKAttribute`, or `nil` if nonexistent.
    public func attribute(with kind: SKAttribute.Kind) -> SKAttribute? {
        return entities.first(where: { $0.kind == kind })
    }

    /// Returns whether the specified attribute kind is a member of the entities.
    ///
    /// - Parameter kind: The kind of the attribute.
    /// - Returns: `true` if the attribute kind is a member of the entities; otherwise, `false`.
    public func containsAttribute(with kind: SKAttribute.Kind) -> Bool {
        return attribute(with: kind) != nil
    }

}
