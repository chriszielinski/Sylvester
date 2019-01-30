//
//  Array.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 1/19/19.
//  Copyright © 2019 Big Z Labs. All rights reserved.
//

extension Array where Element: SKSequence {

    /// A recursive resolution process that sets each child's `index`, `parent`, and `filePath` properties.
    ///
    /// - Parameters:
    ///   - parent: The parent to the receiving children (self).
    ///   - index: The next index (yet to be assigned).
    ///   - filePath: The absolute file path to the source file that contains the children.
    /// - Returns: The subseqent index to assign next.
    @discardableResult
    func resolve(parent: Element? = nil, index: Int, filePath: String?) -> Int {
        var currentIndex = index

        forEach {
            $0.internalParent = parent as? Element.SequenceElement
            $0.index = currentIndex
            currentIndex += 1

            if $0.filePath == nil {
                $0.filePath = filePath
            }

            if let children = $0.internalChildren {
                currentIndex = children.resolve(parent: $0 as? Element.SequenceElement,
                                                index: currentIndex,
                                                filePath: filePath)
            }
        }

        return currentIndex
    }

}
