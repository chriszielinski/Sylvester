//
//  SKSequence.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 1/29/19.
//  Copyright © 2019 Big Z Labs. All rights reserved.
//

public protocol SKSequence: class, Equatable, Codable {

    associatedtype SequenceElement where SequenceElement: SKSequence

    /// The zero-based pre-order [depth-first search (DFS)](https://en.wikipedia.org/wiki/Depth-first_search)
    /// index of the substructure relative to the source file.
    ///
    /// - Note: The first entity in each source file will begin from zero.
    var index: Int? { get set }
    /// The path to the source file.
    var filePath: String? { get set }
    /// The parent entity, or `nil` if this entity is a root.
    ///
    /// - Important: The use of `SKFinalSubclass.parent` should be preferred.
    var internalParent: SequenceElement? { get set }
    /// The entity children contained in the particular entity (sub-classes, references, etc.).
    ///
    /// - Important: The use of `SKFinalSubclass.children` should be preferred.
    var internalChildren: [SequenceElement]? { get set }

    /// Overridden by subclasses to substitute a new iterator class for `SKChildren`.
    ///
    /// The default iterator class used is `SKPreOrderDFSIterator`, which is a pre-order (NLR)
    /// [depth-first search (DFS)](https://en.wikipedia.org/wiki/Depth-first_search) traversing iterator.
    ///
    /// - Returns: The iterator class used for iterating through `SKChildren`.
    static func iteratorClass<SequenceElement>() -> SKPreOrderDFSIterator<SequenceElement>.Type

}
