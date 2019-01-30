//
//  ByteRangeConvertible.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 1/29/19.
//  Copyright © 2019 Big Z Labs. All rights reserved.
//

public protocol ByteRangeConvertible {

    /// The byte offset of the entity inside the source contents.
    var offset: Offset { get }
    /// The byte length of the entity inside the source contents.
    var length: Int { get }
    /// The byte range (i.e. `offset..<length`).
    var byteRange: NSRange { get }

}

extension ByteRangeConvertible {

    public var byteRange: NSRange {
        return NSRange(location: offset, length: length)
    }

}
