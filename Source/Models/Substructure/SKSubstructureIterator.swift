//
//  SKSubstructureIterator.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 8/16/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

/// A pre-order (NLR) [depth-first search (DFS)](https://en.wikipedia.org/wiki/Depth-first_search) traversing iterator.
public struct SKSubstructureIterator {

    // MARK: - Public Stored Properties

    public var stack: Stack<SKSubstructure> = Stack<SKSubstructure>()

    // MARK: - Public Initializers

    public init(_ substructures: [SKSubstructure]) {
        self.push(substructures)
    }

}

// MARK: - Iterator Protocol

extension SKSubstructureIterator: IteratorProtocol {

    public mutating func next() -> SKSubstructure? {
        guard let nextSubstructure = stack.pop()
            else { return nil }

        push(nextSubstructure.children?.substructures)
        return nextSubstructure
    }

    private mutating func push(_ substructures: [SKSubstructure]?) {
        substructures?.reversed().forEach { stack.push($0) }
    }

}
