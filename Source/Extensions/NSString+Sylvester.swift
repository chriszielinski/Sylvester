//
//  NSString.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 12/6/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

public extension NSString {

    /// Converts a range of byte offsets in `self` to a `Range<String.Index>` suitable for filtering `self` as
    /// a `String`.
    ///
    /// - Parameters:
    ///   - start: Starting byte offset.
    ///   - length: Length of bytes to include in range.
    /// - Returns: An equivalent `Range<String.Index>`.
    func rangeFromByteRange(start: Int, length: Int) -> Range<String.Index>? {
        guard let nsRange = byteRangeToNSRange(start: start, length: length)
            else { return nil }
        return Range(nsRange, in: self.bridge())
    }

    /// Converts a range of byte offsets in `self` to a `Range<String.Index>` suitable for filtering `self` as a
    /// `String`.
    ///
    /// - Parameter byteRange: The byte range.
    /// - Returns: An equivalent `Range<String.Index>`.
    func range(from byteRange: NSRange) -> Range<String.Index>? {
        return rangeFromByteRange(start: byteRange.location, length: byteRange.length)
    }

}
