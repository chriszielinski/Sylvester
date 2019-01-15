//
//  SKElement.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 12/5/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

open class SKElement: SKEntity {

    // MARK: - Internal Declarations

    enum CodingKeys: String, CodingKey {
        case kind = "key.kind"
    }

    // MARK: - Public Type Aliases

    public typealias Kind = SKElementKind

    // MARK: - Public Stored Properties

    /// The kind of the element.
    public let kind: Kind

    // MARK: - Public Initializers

    public init(kind: Kind, offset: Int, length: Int) {
        self.kind = kind

        super.init(offset: offset, length: length)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        kind = try container.decode(forKey: .kind)

        try super.init(from: decoder)
    }

    // MARK: - Overridden Methods

    open override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(kind, forKey: .kind)

        try super.encode(to: encoder)
    }

}

// MARK: - Custom Debug String Convertible Protocol

extension SKElement: CustomDebugStringConvertible {

    public var debugDescription: String {
        return "Element(kind: \"\(String(reflecting: kind))\", offset: \(offset), length: \(length))"
    }

}

// MARK: - Equatable Protocol

extension SKElement: Equatable {

    public static func == (lhs: SKElement, rhs: SKElement) -> Bool {
        return lhs.kind == rhs.kind && lhs.offset == rhs.offset && lhs.length == rhs.length
    }

}

// MARK: - SKEntities<SKElement> Methods

extension SKEntities where Entity: SKElement {

    /// Returns the element with the specified kind, or `nil` if nonexistent.
    ///
    /// - Parameter kind: The kind of the element to return.
    /// - Returns: The `SKElement`, or `nil` if nonexistent.
    public func element(with kind: SKElement.Kind) -> SKElement? {
        return entities.first(where: { $0.kind == kind })
    }

    /// Returns whether the specified element kind is a member of the array.
    ///
    /// - Parameter kind: The kind of the element.
    /// - Returns: `true` if the element kind is a member of the array; otherwise, `false`.
    public func containsElement(with kind: SKElement.Kind) -> Bool {
        return element(with: kind) != nil
    }

}
