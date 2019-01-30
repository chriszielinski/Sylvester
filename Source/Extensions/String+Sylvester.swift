//
//  String.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 12/6/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

import Foundation

extension String {

    /// Converts a range of byte offsets in `self` to a `Range<String.Index>` suitable for filtering `self`
    /// as a `String`.
    ///
    /// - Parameter byteRange: The byte range.
    /// - Returns: An equivalent `Range<String.Index>`.
    public func range(from byteRange: NSRange) -> Range<String.Index>? {
        return self.bridge().rangeFromByteRange(start: byteRange.location, length: byteRange.length)
    }

}
