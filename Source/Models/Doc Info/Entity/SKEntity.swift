//
//  SKEntity.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 1/28/19.
//  Copyright © 2019 Big Z Labs. All rights reserved.
//

/// Represents the default entity returned by _SourceKit_ doc info requests.
final public class SKEntity: SKBaseEntity, SKFinalSubclass {

    override public func decodeChildren(from container: DecodingContainer) throws -> [SKBaseEntity]? {
        return try decodeChildren(SKEntity.self, from: container)
    }

}
