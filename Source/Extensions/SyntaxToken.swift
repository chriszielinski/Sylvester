//
//  SyntaxToken.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 1/15/19.
//  Copyright © 2019 Big Z Labs. All rights reserved.
//

import SourceKittenFramework

extension SyntaxToken {

    public typealias Kind = SKSyntaxKind

    /// Returns the token's `SyntaxKind`.
    ///
    /// - Note: Returns `nil` if the type is unknown.
    public var kind: Kind? {
        return Kind(rawValue: type)
    }

}
