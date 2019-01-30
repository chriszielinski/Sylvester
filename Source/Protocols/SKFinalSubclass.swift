//
//  SKFinalSubclass.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 1/28/19.
//  Copyright © 2019 Big Z Labs. All rights reserved.
//

public protocol SKFinalSubclass: SKSequence {

    /// The parent entity, or `nil` if this entity is a root.
    ///
    /// - Note: The parents are not compared for equality.
    var parent: Self? { get set }
    /// The entity children contained in the particular entity (sub-classes, references, etc.).
    var children: SKChildren<Self>? { get set }

}

extension SKFinalSubclass {

    public var parent: Self? {
        get { return internalParent as? Self }
        set {
            assert(newValue is Self.SequenceElement)
            internalParent = newValue as? Self.SequenceElement
        }
    }

    public var children: SKChildren<Self>? {
        get {
            assert(internalChildren is [Self] || internalChildren == nil)
            guard let elements = internalChildren as? [Self]
                else { return nil }
            return SKChildren<Self>(elements: elements)
        }
        set {
            assert(newValue?.elements is [Self.SequenceElement] || newValue == nil)
            internalChildren = newValue?.elements as? [Self.SequenceElement]
        }
    }

}
