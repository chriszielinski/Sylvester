//
//  SKSubstructure.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 7/2/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

/// Represents the default substructure returned by some requests.
final public class SKSubstructure: SKBaseSubstructure, SKFinalSubclass {

    override public func decodeChildren(from container: DecodingContainer) throws -> [SKBaseSubstructure]? {
        return try decodeChildren(SKSubstructure.self, from: container)
    }

}
