//
//  Array.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 1/19/19.
//  Copyright © 2019 Big Z Labs. All rights reserved.
//

extension Array where Element: SKBaseSubstructure {

    /// A recursive resolution process that sets each child's `index`, `parent`, and `filePath` properties.
    ///
    /// - Parameters:
    ///   - parent: The parent substructure to the receiving children substructures (self).
    ///   - index: The next index (yet to be assigned).
    ///   - filePath: The absolute file path to the request's source file.
    /// - Returns: The subseqent index to assign next.
    @discardableResult
    func resolve(parent: Element? = nil, index: Int, filePath: String?) -> Int {
        var currentIndex = index

        forEach {
            $0.internalParent = parent
            $0.index = currentIndex
            currentIndex += 1

            if $0.filePath == nil {
                $0.filePath = filePath
            }

            if let children = $0.internalChildren {
                currentIndex = children.resolve(parent: $0, index: currentIndex, filePath: filePath)
            }
        }

        return currentIndex
    }

}
