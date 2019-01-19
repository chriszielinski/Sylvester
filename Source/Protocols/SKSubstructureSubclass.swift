//
//  SKSubstructureSubclass.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 1/18/19.
//  Copyright © 2019 Big Z Labs. All rights reserved.
//

public protocol SKSubstructureSubclass where Self: SKBaseSubstructure {

    /// The parent substructure, or `nil` if this substructure is a root.
    var parent: Self? { get set }
    /// The substructure children of the substructure.
    var children: SKSubstructureChildren<Self>? { get set }

}

extension SKSubstructureSubclass {

    public var parent: Self? {
        get { return internalParent as? Self }
        set { internalParent = newValue }
    }

    public var children: SKSubstructureChildren<Self>? {
        get {
            assert(internalChildren is [Self])
            guard let substructures = internalChildren as? [Self]
                else { return nil }
            return SKSubstructureChildren<Self>(substructures: substructures)
        }
        set { internalChildren = newValue?.substructures }
    }

}
