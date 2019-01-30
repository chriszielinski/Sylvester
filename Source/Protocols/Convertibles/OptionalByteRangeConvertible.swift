//
//  OptionalByteRangeConvertible.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 1/29/19.
//  Copyright © 2019 Big Z Labs. All rights reserved.
//

public protocol OptionalByteRangeConvertible {

    /// The byte offset of the entity inside the source contents.
    var offset: Offset? { get }
    /// The byte length of the entity inside the source contents.
    var length: Int? { get }
    /// The byte range (i.e. `offset..<length`).
    var byteRange: NSRange? { get }

}

extension OptionalByteRangeConvertible {

    public var byteRange: NSRange? {
        guard let offset = offset, let length = length
            else { return nil }
        return NSRange(location: offset, length: length)
    }

}
