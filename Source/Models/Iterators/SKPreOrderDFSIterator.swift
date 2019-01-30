//
//  SKPreOrderDFSIterator.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 8/16/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

/// A pre-order (NLR) [depth-first search (DFS)](https://en.wikipedia.org/wiki/Depth-first_search) traversing iterator.
open class SKPreOrderDFSIterator<Child: SKSequence>: IteratorProtocol {

    // MARK: - Public Stored Properties

    public var stack: Stack<Child> = Stack<Child>()

    // MARK: - Public Initializers

    public required init(_ substructures: [Child]) {
        self.push(substructures)
    }

    // MARK: - Iterator Protocol

    open func next() -> Child? {
        guard let nextSubstructure = stack.pop()
            else { return nil }

        assert(nextSubstructure.internalChildren is [Child] || nextSubstructure.internalChildren == nil)
        push(nextSubstructure.internalChildren as? [Child])
        return nextSubstructure
    }

    // MARK: - Helper Methods

    private func push(_ substructures: [Child]?) {
        substructures?.reversed().forEach { stack.push($0) }
    }

}
