//
//  SKAnnotation.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 1/28/19.
//  Copyright © 2019 Big Z Labs. All rights reserved.
//

/// Represents an annotation for the token of source text.
///
/// It refers to the text via `offset + length` entries. This includes syntactic annotations (e.g. keywords) and
/// semantic ones. The semantic ones include the name and Unified Symbol Resolution (USR) of the referenced symbol.
open class SKAnnotation: SKGenericKindEntity<SKAnnotation.Kind> {

    // MARK: - Internal Declarations

    enum CodingKeys: String, CodingKey {
        case kind = "key.kind"
        case name = "key.name"
        case usr = "key.usr"
    }

    // MARK: - Public Type Aliases

    /// The UID for the declaration kind (function, class, etc.).
    public typealias Kind = SKSourceKind

    // MARK: - Public Stored Properties

    /// The displayed name for the entity.
    public let name: String?
    /// The Unified Symbol Resolution (USR) string for the entity.
    public let usr: String?

    // MARK: - Public Initializers

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeIfPresent(forKey: .name)
        usr = try container.decodeIfPresent(forKey: .usr)

        try super.init(from: decoder)

        kind = try container.decode(forKey: .kind)
    }

    // MARK: - Overridden Methods

    open override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(kind, forKey: .kind)
        try container.encode(name, forKey: .name)
        try container.encode(usr, forKey: .usr)

        try super.encode(to: encoder)
    }

    // MARK: - Equatable Protocol

    open override func isEqual(to rhs: SKByteRange) -> Bool {
        guard let annotation = rhs as? SKAnnotation
            else { return false }
        return name == annotation.name && usr == annotation.usr && super.isEqual(to: rhs)
    }

}

// MARK: - SKSortedEntities<SKAnnotation> Methods

extension SKSortedEntities where Entity: SKAnnotation {

    /// Returns the annotation with the specified kind, or `nil` if nonexistent.
    ///
    /// - Parameter kind: The kind of the annotation to return.
    /// - Returns: The `SKAnnotation`, or `nil` if nonexistent.
    public func annotation(with kind: SKAnnotation.Kind) -> SKAnnotation? {
        return entities.first(where: { $0.kind == kind })
    }

    /// Returns whether the specified annotation kind is a member of the entities.
    ///
    /// - Parameter kind: The kind of the annotation.
    /// - Returns: `true` if the annotation kind is a member of the entities; otherwise, `false`.
    public func containsAnnotation(with kind: SKAnnotation.Kind) -> Bool {
        return annotation(with: kind) != nil
    }

}
