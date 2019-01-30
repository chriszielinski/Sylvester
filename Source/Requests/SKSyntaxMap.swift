//
//  SKSyntaxMap.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 12/3/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

import SourceKittenFramework

/// Represents a Swift file’s syntax information.
open class SKSyntaxMap: Codable {

    // MARK: - Public Stored Properties

    /// The backing _SourceKitten_ `SyntaxMap`.
    public let syntaxMap: SyntaxMap

    // MARK: - Public Stored Properties

    /// Array of `SyntaxToken`s.
    public var tokens: [SyntaxToken] {
        return syntaxMap.tokens
    }

    // MARK: - Public Initializers

    /// Creates a new synchronous _SourceKitten_ syntax map request.
    ///
    /// - Warning: The request is sent synchronously, so ensure this initializer is not called on the main thread.
    ///
    /// - Parameters:
    ///   - file: The source file.
    /// - Throws: A `SKError`, if an error occurs.
    public init(file: File) throws {
        syntaxMap = try SylvesterInterface.shared.syntaxMap(file: file)
    }

    /// Creates a new synchronous _SourceKitten_ syntax map request.
    ///
    /// - Warning: The request is sent synchronously, so ensure this initializer is not called on the main thread.
    ///
    /// - Parameters:
    ///   - filePath: The absolute file path to the source file.
    /// - Throws: A `SKError`, if an error occurs.
    public convenience init(filePath: String) throws {
        try self.init(file: File(pathDeferringReading: filePath))
    }

}

// MARK: - JSON Debug String Convertable Protocol

extension SKSyntaxMap: JSONDebugStringConvertible {}

// MARK: - Equatable Protocol

extension SKSyntaxMap: Equatable {

    public static func == (lhs: SKSyntaxMap, rhs: SKSyntaxMap) -> Bool {
        return lhs.syntaxMap == rhs.syntaxMap
    }

}
