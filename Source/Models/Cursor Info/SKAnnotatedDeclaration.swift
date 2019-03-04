//
//  SKAnnotatedDeclaration.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 3/4/19.
//  Copyright © 2019 Big Z Labs. All rights reserved.
//

public struct SKAnnotatedDeclaration {

    // MARK: - Internal Declarations

    enum CodingKeys: String, CodingKey {
        case annotatedDeclaration = "key.annotated_decl"
    }

    // MARK: - Public Stored Properties

    public let annotatedDeclaration: String

    // MARK: - Public Initializers

    public init(annotatedDeclaration: String) {
        self.annotatedDeclaration = annotatedDeclaration
    }

}

// MARK: - Codable Protocol

extension SKAnnotatedDeclaration: Codable {}

// MARK: - Equatable Protocol

extension SKAnnotatedDeclaration: Equatable {

    public static func == (lhs: SKAnnotatedDeclaration, rhs: SKAnnotatedDeclaration) -> Bool {
        return lhs.annotatedDeclaration == rhs.annotatedDeclaration
    }

}

// MARK: - JSON Debug String Convertible Protocol

extension SKAnnotatedDeclaration: JSONDebugStringConvertible {}
