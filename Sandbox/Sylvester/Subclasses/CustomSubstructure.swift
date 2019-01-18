//
//  CustomSubstructure.swift
//  Sandbox
//
//  Created by Chris Zielinski on 1/16/19.
//  Copyright © 2019 Big Z Labs. All rights reserved.
//

import SylvesterXPC

final public class CustomSubstructure: SKBaseSubstructure, SKSubstructureSubclass {

    // Public Stored Properties

    public var iAmASubclass: Bool = true

    // Public Overridden Methods

    override public func decodeChildren(from container: DecodingContainer) throws -> [SKBaseSubstructure]? {
        return try decodeChildren(CustomSubstructure.self, from: container)
    }

}
