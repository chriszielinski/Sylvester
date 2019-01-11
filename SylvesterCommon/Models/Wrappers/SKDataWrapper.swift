//
//  SKDataWrapper.swift
//  SylvesterCommon 😼
//
//  Created by Chris Zielinski on 12/11/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

import SourceKittenFramework

@objc
public class SKDataWrapper: NSObject, NSSecureCoding {

    // MARK: - Internal Declarations

    enum CodingKeys: String, CodingKey {
        case data
    }

    // MARK: - Public Static Computed Properties

    public class var supportsSecureCoding: Bool {
        return true
    }

    // MARK: - Public Stored Properties

    public let data: Data

    // MARK: - Public Initializers

    public init(data: Data) {
        self.data = data
    }

    public required init?(coder aDecoder: NSCoder) {
        guard let data = aDecoder.decodeObject(of: NSData.self, forKey: CodingKeys.data.rawValue)
            else { return nil }
        self.data = data as Data
    }

    /// Creates a new data wrapper for an `Encodable` object.
    ///
    /// - Parameter object: The object to encode and store.
    /// - Throws: A `SKXPCError`, if encoding fails.
    public convenience init<T: Encodable>(xpcObject: T) throws {
        do {
            self.init(data: try JSONEncoder().encode(xpcObject))
        } catch let error as EncodingError {
            throw SKXPCError.jsonEncodingFailed(error)
        } catch {
            throw SKXPCError.unknown(error)
        }
    }

    /// Creates a new data wrapper for an `Encodable` object.
    ///
    /// - Parameter object: The object to encode and store.
    /// - Throws: A `SKError`, if encoding fails.
    public convenience init<T: Encodable>(object: T) throws {
        do {
            try self.init(xpcObject: object)
        } catch {
            throw error.toSKError()
        }
    }

    /// A convenience initializer that tries to create a data wrapper from an object.
    ///
    /// - Parameter object: The object to encode.
    /// - Throws: An `SKError` if encoding fails.
    public convenience init(_ object: SourceKitRepresentable) throws {
        guard JSONSerialization.isValidJSONObject(object),
            let data = try? JSONSerialization.data(withJSONObject: object)
            else { throw SKError.jsonDataEncodingFailed }
        self.init(data: data)
    }

    /// A convenience initializer that tries to create a data wrapper from an object.
    ///
    /// If succesfully encodes the object, it is passed in to the `reply` closure. If it fails, it passes
    /// the `SKXPCError` in to the `reply` closure, and rethrows the error.
    ///
    /// - Parameters:
    ///   - object: The object to encode.
    ///   - reply: The XPC reply closure.
    /// - Throws: An `SKXPCError` if encoding fails.
    public convenience init(_ object: SourceKitRepresentable,
                            reply: (SKDataWrapper?, SKXPCError?) -> Void) throws {
        do {
            try self.init(object)
            reply(self, nil)
        } catch {
            let xpcError = SKXPCError.jsonDataEncodingFailed()
            reply(nil, xpcError)
            throw xpcError
        }
    }

    // MARK: - Coding Protocol

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(data as NSData, forKey: CodingKeys.data.rawValue)
    }

    // MARK: - Public Decoding Methods

    /// Returns a value of the type you specify, decoded from this wrapper's data.
    ///
    /// - Returns: A value of the requested type.
    /// - Throws: A `SKXPCError`, if decoding fails.
    public func xpcDecodeData<T: Decodable>() throws -> T {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch let error as DecodingError {
            throw SKXPCError.jsonDecodingFailed(error)
        } catch {
            throw SKXPCError.unknown(error)
        }
    }

    /// Returns a value of the type you specify, decoded from this wrapper's data.
    ///
    /// - Returns: A value of the requested type.
    /// - Throws: A `SKError`, if decoding fails.
    public func decodeData<T: Decodable>() throws -> T {
        do {
            return try xpcDecodeData()
        } catch {
            throw error.toSKError()
        }
    }

}
