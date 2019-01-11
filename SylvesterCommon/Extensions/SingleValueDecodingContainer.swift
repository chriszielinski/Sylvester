//
//  SingleValueDecodingContainer.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 8/5/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

public extension SingleValueDecodingContainer {

    /// Decodes a single value of the implicit type.
    func decode<T: Decodable>() throws -> T {
        return try decode(T.self)
    }

}
