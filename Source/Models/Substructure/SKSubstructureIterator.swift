//
//  SKSubstructureIterator.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 8/16/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

/// A pre-order (NLR) [depth-first search (DFS)](https://en.wikipedia.org/wiki/Depth-first_search) traversing iterator.
public struct SKSubstructureIterator<Substructure: SKBaseSubstructure> {

    // MARK: - Public Stored Properties

    public var stack: Stack<Substructure> = Stack<Substructure>()

    // MARK: - Public Initializers

    public init(_ substructures: [Substructure]) {
        self.push(substructures)
    }

}

// MARK: - Iterator Protocol

extension SKSubstructureIterator: IteratorProtocol {

    public mutating func next() -> Substructure? {
        guard let nextSubstructure = stack.pop()
            else { return nil }

        push(nextSubstructure.internalChildren?.substructures as? [Substructure])
        return nextSubstructure
    }

    private mutating func push(_ substructures: [Substructure]?) {
        substructures?.reversed().forEach { stack.push($0) }
    }

}
