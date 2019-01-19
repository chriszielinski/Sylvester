//
//  SKSubstructureIterator.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 8/16/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

/// A pre-order (NLR) [depth-first search (DFS)](https://en.wikipedia.org/wiki/Depth-first_search) traversing iterator.
open class SKSubstructureIterator<Substructure: SKBaseSubstructure>: IteratorProtocol {

    // MARK: - Public Stored Properties

    public var stack: Stack<Substructure> = Stack<Substructure>()

    // MARK: - Public Initializers

    public required init(_ substructures: [Substructure]) {
        self.push(substructures)
    }

    // MARK: - Iterator Protocol

    open func next() -> Substructure? {
        guard let nextSubstructure = stack.pop()
            else { return nil }

        assert(nextSubstructure.internalChildren is [Substructure] || nextSubstructure.internalChildren == nil)
        push(nextSubstructure.internalChildren as? [Substructure])
        return nextSubstructure
    }

    // MARK: - Helper Methods

    private func push(_ substructures: [Substructure]?) {
        substructures?.reversed().forEach { stack.push($0) }
    }

}
