//
//  SKElement.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 12/5/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

open class SKElement: SKGenericKindEntity<SKElement.Kind> {

    // MARK: - Internal Declarations

    enum CodingKeys: String, CodingKey {
        case kind = "key.kind"
    }

    // MARK: - Public Type Aliases

    public typealias Kind = SKElementKind

    // MARK: - Public Initializers

    override public init(kind: Kind, offset: Int, length: Int) {
        super.init(kind: kind, offset: offset, length: length)
    }

    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        kind = try container.decode(forKey: .kind)
    }

    // MARK: - Overridden Methods

    open override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(kind, forKey: .kind)

        try super.encode(to: encoder)
    }

}

// MARK: - SKSortedEntities<SKElement> Methods

extension SKSortedEntities where Entity: SKElement {

    /// Returns the element with the specified kind, or `nil` if nonexistent.
    ///
    /// - Parameter kind: The kind of the element to return.
    /// - Returns: The `SKElement`, or `nil` if nonexistent.
    public func element(with kind: SKElement.Kind) -> SKElement? {
        return entities.first(where: { $0.kind == kind })
    }

    /// Returns whether the specified element kind is a member of the entities.
    ///
    /// - Parameter kind: The kind of the element.
    /// - Returns: `true` if the element kind is a member of the entities; otherwise, `false`.
    public func containsElement(with kind: SKElement.Kind) -> Bool {
        return element(with: kind) != nil
    }

}
