//
//  FirstDifferenceBetweenStrings.swift
//  Sylvester Tests 😼
//
//  Created by Chris Zielinski on 12/3/18.
//  Written by [Kristopher Johnson](https://github.com/kristopherjohnson)
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

import Foundation

/// Find first differing character between two strings.
///
/// - Author: [Kristopher Johnson](https://github.com/kristopherjohnson)
///
/// - SeeAlso: [GitHub Gist](https://gist.github.com/kristopherjohnson/543687c763cd6e524c91)
///
/// - Parameters:
///   - s1: First String.
///   - s2: Second String.
/// - Returns: .differenceAtIndex(i) or .noDifference
public func firstDifferenceBetweenStrings(_ string1: String, _ string2: String) -> FirstDifferenceResult {
    let nsString1 = string1 as NSString
    let nsString2 = string2 as NSString
    let len1 = nsString1.length
    let len2 = nsString2.length

    let lenMin = min(len1, len2)

    for index in 0..<lenMin {
        if nsString1.character(at: index) != nsString2.character(at: index) {
            return .differenceAtIndex(index)
        }
    }

    if len1 < len2 {
        return .differenceAtIndex(len1)
    }

    if len2 < len1 {
        return .differenceAtIndex(len2)
    }

    return .noDifference
}

/// Create a formatted String representation of difference between strings.
///
/// - Parameters:
///   - s1: First String.
///   - s2: Second String.
/// - Returns: A string, possibly containing significant whitespace and newlines
public func prettyFirstDifferenceBetweenStrings(_ string1: String,
                                                _ string2: String,
                                                withNewLines: Bool = true) -> String {
    let firstDifferenceResult = firstDifferenceBetweenStrings(string1, string2)
    return prettyDescriptionOfFirstDifferenceResult(firstDifferenceResult: firstDifferenceResult,
                                                    string1: string1,
                                                    string2: string2,
                                                    withNewLines: withNewLines)
}

/// Create a formatted String representation of a FirstDifferenceResult for two strings
///
/// :param: firstDifferenceResult FirstDifferenceResult
/// :param: s1 First string used in generation of firstDifferenceResult
/// :param: s2 Second string used in generation of firstDifferenceResult
///
/// :returns: a printable string, possibly containing significant whitespace and newlines
public func prettyDescriptionOfFirstDifferenceResult(firstDifferenceResult: FirstDifferenceResult,
                                                     string1: String,
                                                     string2: String,
                                                     withNewLines: Bool = true) -> String {

    func diffString(index: Int, string1: String, string2: String, withNewLines: Bool) -> String {
        let markerArrow = "\u{2b06}"  // "⬆"
        let ellipsis    = "\u{2026}"  // "…"
        let nsString1 = string1 as NSString
        let nsString2 = string2 as NSString

        /// Given a string and a range, return a string representing that substring.
        ///
        /// If the range starts at a position other than 0, an ellipsis
        /// will be included at the beginning.
        ///
        /// If the range ends before the actual end of the string, an ellipsis is added at the end.
        func windowSubstring(_ string: NSString, range: NSRange) -> String {
            let validRange = NSRange(location: range.location,
                                     length: min(range.length, string.length - range.location))
            let substring = string.substring(with: validRange)

            let prefix = range.location > 0 ? ellipsis : ""
            let suffix = (string.length - range.location > range.length) ? ellipsis : ""

            return "\(prefix)\(substring)\(suffix)"
        }

        // Show this many characters before and after the first difference
        let windowPrefixLength = 10
        let windowSuffixLength = 10
        let windowLength = windowPrefixLength + 1 + windowSuffixLength

        let windowIndex = max(index - windowPrefixLength, 0)
        let windowRange = NSRange(location: windowIndex, length: windowLength)

        let sub1 = windowSubstring(nsString1, range: windowRange)
        let sub2 = windowSubstring(nsString2, range: windowRange)

        let markerPosition = min(windowSuffixLength, index) + (windowIndex > 0 ? 1 : 0)

        let markerPrefix = String(repeating: " ", count: markerPosition)
        let markerLine = "\(markerPrefix)\(markerArrow)"

        if withNewLines {
            return "Difference at index \(index):\n\"\(sub1)\"\n\n\"\(sub2)\"\n\(markerLine)"
        } else {
            return "Difference at index \(index): \(sub1) || \(sub2)"
        }
    }

    switch firstDifferenceResult {
    case .noDifference:
        return "No difference"
    case .differenceAtIndex(let index):
        return diffString(index: index, string1: string1, string2: string2, withNewLines: withNewLines)
    }
}

/// Result type for firstDifferenceBetweenStrings()
public enum FirstDifferenceResult {
    /// Strings are identical
    case noDifference

    /// Strings differ at the specified index.
    ///
    /// This could mean that characters at the specified index are different,
    /// or that one string is longer than the other
    case differenceAtIndex(Int)
}

extension FirstDifferenceResult: CustomStringConvertible, CustomDebugStringConvertible {
    /// Textual representation of a FirstDifferenceResult
    public var description: String {
        switch self {
        case .noDifference:
            return "No difference."
        case .differenceAtIndex(let index):
            return "Difference at index: \(index)."
        }
    }

    /// Textual representation of a FirstDifferenceResult for debugging purposes
    public var debugDescription: String {
        return self.description
    }
}
