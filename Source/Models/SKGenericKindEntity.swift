//
//  SKGenericKindEntity.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 1/29/19.
//  Copyright © 2019 Big Z Labs. All rights reserved.
//

open class SKGenericKindEntity<Kind: Equatable>: SKByteRange {

    // MARK: - Public Stored Properties

    /// The kind of the entity.
    public var kind: Kind!

    // MARK: - Public Initializers

    public init(kind: Kind, offset: Int, length: Int) {
        self.kind = kind

        super.init(offset: offset, length: length)
    }

    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    // MARK: - Equatable Protocol

    open override func isEqual(to rhs: SKByteRange) -> Bool {
        let isSuperEqual = super.isEqual(to: rhs)

        guard let entity = rhs as? SKGenericKindEntity<Kind> else {
            return false
        }

        return isSuperEqual && kind == entity.kind
    }

}
