//
//  KeyedDecodingContainer.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 12/27/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

public extension KeyedDecodingContainer {

    /// Decodes a value of the implicit type for the given key.
    ///
    /// - Parameter key: The key that the decoded value is associated with.
    /// - Returns: A value of the implicitly requested type, if present for the given key and convertible to
    ///            the implicitly requested type.
    /// - Throws: A `DecodingError`.
    func decode<T: Decodable>(forKey key: Key) throws -> T {
        return try decode(T.self, forKey: key)
    }

    /// Decodes a value of the implicit type for the given key, if present.
    ///
    /// - Parameter key: The key that the decoded value is associated with.
    /// - Returns: A decoded value of the implicitly requested type, or nil if the `Decoder` does not have an entry
    ///            associated with the given key, or if the value is a null value.
    /// - Throws: `DecodingError.typeMismatch` if the encountered encoded value is not convertible to the
    ///           requested type.
    func decodeIfPresent<T: Decodable>(forKey key: Key) throws -> T? {
        return try decodeIfPresent(T.self, forKey: key)
    }

}
