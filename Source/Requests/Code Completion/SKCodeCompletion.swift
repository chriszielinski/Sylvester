//
//  SKCodeCompletion.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 7/25/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

import SourceKittenFramework

/// Represents a _SourceKit_ code completion request that provides code completion suggestions.
open class SKCodeCompletion: Codable {

    // MARK: - Internal Declarations

    enum CodingKeys: String, CodingKey {
        case items = "key.results"
        case nextRequestStart = "key.nextrequeststart"
    }

    // MARK: - Public Type Aliases

    public typealias Item = SKCodeCompletionItem

    // MARK: - Public Stored Properties

    /// The value to use for `SKCodeCompletionSession.Options.requestStart` in the next request when
    /// using `SKCodeCompletionSession.Options.requestLimit`.
    ///
    /// - Note: Only present for `SKCodeCompletionSession` requests.
    public let nextRequestStart: Int?
    /// The code completion items for the request.
    public var items: [Item]

    // MARK: - Public Initializers

    /// Creates a new synchronous _SourceKit_ code completion request.
    ///
    /// - Warning: The request is sent synchronously, so ensure this initializer is not called on the main thread.
    ///
    /// - Parameters:
    ///   - file: The source file.
    ///   - offset: The byte offset of the code completion point inside the source contents.
    ///   - compilerArguments: The compiler arguments used to build the module (e.g `["-sdk", "/path/to/sdk"]`).
    /// - Throws: A `SKError`, if an error occurs.
    public init(file: File, offset: Offset, compilerArguments: [String]) throws {
        let codeCompletion = try SylvesterInterface.shared.codeCompletion(file: file,
                                                                             offset: offset,
                                                                             compilerArguments: compilerArguments)
        self.nextRequestStart = codeCompletion.nextRequestStart
        self.items = codeCompletion.items
    }

    /// Creates a new synchronous _SourceKit_ code completion request.
    ///
    /// - Warning: The request is sent synchronously, so ensure this initializer is not called on the main thread.
    ///
    /// - Parameters:
    ///   - file: The source file.
    ///   - offset: The byte offset of the code completion point inside the source contents.
    ///   - sdkPath: The path to the SDK to compile against.
    ///   - target: The target (triple) architecture to generate completions for (e.g. `"arm64-apple-ios12.1"`).
    /// - Throws: A `SKError`, if an error occurs.
    public convenience init(file: File, offset: Offset, sdkPath: String, target: String? = nil) throws {
        var compilerArguments = ["-sdk", sdkPath]

        if let target = target {
            compilerArguments.append(contentsOf: ["-target", target])
        }

        try self.init(file: file, offset: offset, compilerArguments: compilerArguments)
    }

    /// Creates a new synchronous _SourceKit_ code completion request.
    ///
    /// - Warning: The request is sent synchronously, so ensure this initializer is not called on the main thread.
    ///
    /// - Parameters:
    ///   - filePath: The absolute file path to the source file.
    ///   - offset: The byte offset of the code completion point inside the source contents.
    ///   - compilerArguments: The compiler arguments used to build the module (e.g `["-sdk", "/path/to/sdk"]`).
    /// - Throws: A `SKError`, if an error occurs.
    public convenience init(filePath: String, offset: Offset, compilerArguments: [String]) throws {
        try self.init(file: File(pathDeferringReading: filePath), offset: offset, compilerArguments: compilerArguments)
    }

    /// Creates a new synchronous _SourceKit_ code completion request.
    ///
    /// - Warning: The request is sent synchronously, so ensure this initializer is not called on the main thread.
    ///
    /// - Parameters:
    ///   - contents: The source code contents.
    ///   - offset: The byte offset of the code completion point inside the source contents.
    ///   - compilerArguments: The compiler arguments used to build the module (e.g `["-sdk", "/path/to/sdk"]`).
    /// - Throws: A `SKError`, if an error occurs.
    public convenience init(contents: String, offset: Offset, compilerArguments: [String]) throws {
        try self.init(file: File(contents: contents), offset: offset, compilerArguments: compilerArguments)
    }

    /// Creates a new synchronous _SourceKit_ code completion request.
    ///
    /// - Warning: The request is sent synchronously, so ensure this initializer is not called on the main thread.
    ///
    /// - Parameters:
    ///   - filePath: The absolute file path to the source file.
    ///   - offset: The byte offset of the code completion point inside the source contents.
    ///   - sdkPath: The path to the SDK to compile against.
    ///   - target: The target (triple) architecture to generate completions for (e.g. `"arm64-apple-ios12.1"`).
    /// - Throws: A `SKError`, if an error occurs.
    public convenience init(filePath: String, offset: Offset, sdkPath: String, target: String? = nil) throws {
        try self.init(file: File(pathDeferringReading: filePath), offset: offset, sdkPath: sdkPath, target: target)
    }

    /// Creates a new synchronous _SourceKit_ code completion request.
    ///
    /// - Warning: The request is sent synchronously, so ensure this initializer is not called on the main thread.
    ///
    /// - Parameters:
    ///   - contents: The source code contents.
    ///   - offset: The byte offset of the code completion point inside the source contents.
    ///   - sdkPath: The path to the SDK to compile against.
    ///   - target: The target (triple) architecture to generate completions for (e.g. `"arm64-apple-ios12.1"`).
    /// - Throws: A `SKError`, if an error occurs.
    public convenience init(contents: String, offset: Offset, sdkPath: String, target: String? = nil) throws {
        try self.init(file: File(contents: contents), offset: offset, sdkPath: sdkPath, target: target)
    }

}

// MARK: - JSON Debug String Convertable Protocol

extension SKCodeCompletion: JSONDebugStringConvertible {}

// MARK: - Equatable Protocol

extension SKCodeCompletion: Equatable {

    public static func == (lhs: SKCodeCompletion, rhs: SKCodeCompletion) -> Bool {
        return lhs.nextRequestStart == rhs.nextRequestStart
            && lhs.items == rhs.items
    }

}
