//
//  GenericSubstructure.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 1/16/19.
//  Copyright © 2019 Big Z Labs. All rights reserved.
//

/// Workaround for declaring a generic, recursive `SKSubstructure`.
protocol GenericSubstructure: class {

    // MARK: - Associated Types

    associatedtype Substructure: SKSubstructure

    // MARK: - Properties

    var parent: Substructure? { get set }
    var children: SKSubstructureChildren<Substructure>? { get set }

}
