//
//  SKSubstructure.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 7/2/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

final public class SKSubstructure: SKBaseSubstructure, SKSubstructureSubclass {

    override public func decodeChildren(from container: DecodingContainer) throws -> [SKBaseSubstructure]? {
        return try decodeChildren(SKSubstructure.self, from: container)
    }

}
