//
//  SyntaxToken.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 12/3/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

import SourceKittenFramework

enum SyntaxTokenCodingKey: String, CodingKey {
    case kind = "key.kind"
    case offset = "key.offset"
    case length = "key.length"
}

extension SyntaxToken: Codable {

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: SyntaxTokenCodingKey.self)
        self.init(type: try container.decode(forKey: .kind),
                  offset: try container.decode(forKey: .offset),
                  length: try container.decode(forKey: .length))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: SyntaxTokenCodingKey.self)
        try container.encode(type, forKey: .kind)
        try container.encode(offset, forKey: .offset)
        try container.encode(length, forKey: .length)
    }

}
