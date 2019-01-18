//
//  SKSubstructureSubclass.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 1/18/19.
//  Copyright © 2019 Big Z Labs. All rights reserved.
//

public protocol SKSubstructureSubclass where Self: SKBaseSubstructure {

    var parent: Self? { get set }
    var children: SKSubstructureChildren<Self>? { get set }

}

extension SKSubstructureSubclass {

    public var parent: Self? {
        get { return internalParent as? Self }
        set { internalParent = newValue }
    }

    public var children: SKSubstructureChildren<Self>? {
        get {
            guard let substructures = internalChildren?.substructures as? [Self] else {
                assert(internalChildren == nil)
                return nil
            }
            return SKSubstructureChildren<Self>(substructures: substructures)
        }
        set {
            if let substructures = newValue?.substructures {
                internalChildren?.substructures = substructures
            } else {
                internalChildren = nil
            }
        }
    }

}
