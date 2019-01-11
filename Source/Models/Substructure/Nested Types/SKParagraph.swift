//
//  SKParagraph.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 12/27/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

public struct SKParagraph {

    // MARK: - Internal Declarations

    enum CodingKeys: String, CodingKey {
        case paragraph = "Para"
    }

    // MARK: - Public Stored Properties

    public let paragraph: String

}

// MARK: - Codable Protocol

extension SKParagraph: Codable {}

// MARK: - Equatable Protocol

extension SKParagraph: Equatable {}
