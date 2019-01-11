//
//  SKDocumentationParameter.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 12/5/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

public struct SKDocumentationParameter {

    // MARK: - Public Type Aliases

    public typealias Paragraph = SKParagraph

    // MARK: - Public Stored Properties

    public let name: String
    public let discussion: [Paragraph]

}

// MARK: - Codable Protocol

extension SKDocumentationParameter: Codable {}

// MARK: - Custom String Convertible Protocol

extension SKDocumentationParameter: CustomStringConvertible {

    public var description: String {
        return discussion.map({ $0.paragraph }).joined(separator: "\n")
    }

}

// MARK: - Equatable Protocol

extension SKDocumentationParameter: Equatable {

    public static func == (lhs: SKDocumentationParameter, rhs: SKDocumentationParameter) -> Bool {
        return lhs.name == rhs.name && lhs.discussion == rhs.discussion
    }

}
