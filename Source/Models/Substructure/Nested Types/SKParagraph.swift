//
//  SKParagraph.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 12/27/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

import SylvesterCommon

public struct SKParagraph {

    // MARK: - Internal Declarations

    enum CodingKeys: String, CodingKey {
        case paragraph = "Para"
    }

    // MARK: - Public Stored Properties

    /// The paragraph text contents.
    public let paragraph: String

    public init(paragraph: String) {
        self.paragraph = paragraph
    }

    public init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            paragraph = try container.decode(forKey: .paragraph)
        } catch {
            Utilities.print(error: error)
            paragraph = ""
        }
    }

}

// MARK: - Codable Protocol

extension SKParagraph: Codable {}

// MARK: - Equatable Protocol

extension SKParagraph: Equatable {}

// MARK: - JSON Debug String Convertible Protocol

extension SKParagraph: JSONDebugStringConvertible {}
