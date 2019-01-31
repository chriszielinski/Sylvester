//
//  SKGenericDocInfo.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 1/28/19.
//  Copyright © 2019 Big Z Labs. All rights reserved.
//

import SourceKittenFramework

/// A generic _SourceKit_ doc info request.
open class SKGenericDocInfo<Entity: SKBaseEntity>: NSObject, Codable {

    // MARK: - Internal Declarations

    enum CodingKeys: String, CodingKey {
        case sourceText = "key.sourcetext"
        case annotations = "key.annotations"
        case topLevelEntities = "key.entities"
        case diagnostics = "key.diagnostics"
    }

    // MARK: - Public Stored Properties

    /// The source contents.
    public let sourceText: String?
    /// An array of annotations for the tokens of source text.
    public let annotations: SKSortedEntities<SKAnnotation>
    /// A structure of the symbols (a class has its methods as sub-entities, etc.).
    ///
    /// This includes the function parameters and their types as entities.
    public let topLevelEntities: SKChildren<Entity>?
    /// The Compiler diagnostics emitted during parsing of a source file.
    ///
    /// - Note: This key is only present if a diagnostic was emitted
    public let diagnostics: [SKDiagnostic]?

    // MARK: - Public Initializers

    /// Creates a new synchronous _SourceKit_ doc info request.
    ///
    /// - Warning: The request is sent synchronously, so ensure this initializer is not called on the main thread.
    ///
    /// - Note: Ensure this initializer is only called with either a `file` or a `moduleName`, **not both**.
    ///
    /// - Parameters:
    ///   - file: The source file to gather documentation for.
    ///   - moduleName: The module name to gather documentation for.
    ///   - compilerArguments: The compiler arguments used to build the module (e.g `["-sdk", "/path/to/sdk"]`).
    /// - Throws: A `SKError`, if an error occurs.
    public init(file: File?, moduleName: String?, compilerArguments: [String]) throws {
        let sharedInterface = SylvesterInterface.shared
        let response: SKGenericDocInfo<Entity> = try sharedInterface.docInfo(file: file,
                                                                             moduleName: moduleName,
                                                                             compilerArguments: compilerArguments)

        sourceText = response.sourceText
        annotations = response.annotations
        topLevelEntities = response.topLevelEntities
        diagnostics = response.diagnostics

        super.init()

        resolve(from: file?.path)
    }

    /// Creates a new synchronous _SourceKit_ doc info request.
    ///
    /// - Warning: The request is sent synchronously, so ensure this initializer is not called on the main thread.
    ///
    /// - Parameters:
    ///   - file: The source file to gather documentation for.
    ///   - compilerArguments: The compiler arguments used to build the module (e.g `["-sdk", "/path/to/sdk"]`).
    /// - Throws: A `SKError`, if an error occurs.
    public convenience init(file: File, compilerArguments: [String]) throws {
        try self.init(file: file, moduleName: nil, compilerArguments: compilerArguments)
    }

    /// Creates a new synchronous _SourceKit_ doc info request.
    ///
    /// - Warning: The request is sent synchronously, so ensure this initializer is not called on the main thread.
    ///
    /// - Parameters:
    ///   - file: The source file to gather documentation for.
    ///   - sdkPath: The path to the SDK to compile against.
    ///   - target: The target (triple) architecture (e.g. `"arm64-apple-ios12.1"`).
    /// - Throws: A `SKError`, if an error occurs.
    public convenience init(file: File, sdkPath: String, target: String?) throws {
        try self.init(file: file,
                      compilerArguments: Request.createCompilerArguments(sdkPath: sdkPath, target: target))
    }

    /// Creates a new synchronous _SourceKit_ doc info request.
    ///
    /// - Warning: The request is sent synchronously, so ensure this initializer is not called on the main thread.
    ///
    /// - Parameters:
    ///   - moduleName: The module name to gather documentation for.
    ///   - compilerArguments: The compiler arguments used to build the module (e.g `["-sdk", "/path/to/sdk"]`).
    /// - Throws: A `SKError`, if an error occurs.
    public convenience init(moduleName: String, compilerArguments: [String]) throws {
        try self.init(file: nil, moduleName: moduleName, compilerArguments: compilerArguments)
    }

    /// Creates a new synchronous _SourceKit_ doc info request.
    ///
    /// - Warning: The request is sent synchronously, so ensure this initializer is not called on the main thread.
    ///
    /// - Parameters:
    ///   - moduleName: The module name to gather documentation for.
    ///   - sdkPath: The path to the SDK to compile against.
    ///   - target: The target (triple) architecture (e.g. `"arm64-apple-ios12.1"`).
    /// - Throws: A `SKError`, if an error occurs.
    public convenience init(moduleName: String, sdkPath: String, target: String?) throws {
        try self.init(file: nil,
                      moduleName: moduleName,
                      compilerArguments: Request.createCompilerArguments(sdkPath: sdkPath, target: target))
    }

    // MARK: - Public Methods

    /// The entry point to a recursive resolution process that sets each child's `index`, `parent`, and
    /// `filePath` properties.
    ///
    /// This method calls the `topLevelEntities`'s `SKChildren.resolve(parent:index:filePath:)` method.
    ///
    /// - Note: If the resolution process is unnecessary, overriding this method with an empty body will
    ///         suffice to omit it.
    ///
    /// - Parameter filePath: The absolute file path to the request's source file.
    open func resolve(from filePath: String?) {
        topLevelEntities?.resolve(index: 0, filePath: filePath)
    }

}
