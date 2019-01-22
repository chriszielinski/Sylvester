//
//  SKGenericSwiftDocs.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 1/16/19.
//  Copyright © 2019 Big Z Labs. All rights reserved.
//

import SourceKittenFramework
import SylvesterCommon

/// Represents a generic _SourceKitten_ Swift Documentation request for a Swift file.
open class SKGenericSwiftDocs<Substructure: SKBaseSubstructure>: SKGenericResponse<Substructure> {

    // MARK: - Public Stored Properties

    /// The file that documentation was requested for.
    public let file: File

    // MARK: - Public Initializers

    /// Creates a new synchronous _SourceKitten_ Swift Documentation request.
    ///
    /// - Warning: The request is sent synchronously, so ensure this initializer is not called on the main thread.
    ///
    /// - Parameters:
    ///   - file: The source file to gather documentation for.
    ///   - compilerArguments: The compiler arguments used to build the module (e.g `["-sdk", "/path/to/sdk"]`).
    /// - Throws: A `SKError`, if an error occurs.
    public init(file: File, compilerArguments: [String]) throws {
        self.file = file

        super.init(skInformation: try SylvesterInterface.shared.swiftDocs(file: file,
                                                                             compilerArguments: compilerArguments))

        resolve(from: file.path)
    }

    /// Creates a new synchronous _SourceKitten_ Swift Documentation request.
    ///
    /// - Warning: The request is sent synchronously, so ensure this initializer is not called on the main thread.
    ///
    /// - Parameters:
    ///   - filePath: The absolute file path to the source file to gather documentation for.
    ///   - compilerArguments: The compiler arguments used to build the module (e.g `["-sdk", "/path/to/sdk"]`).
    /// - Throws: A `SKError`, if an error occurs.
    public convenience init(filePath: String, compilerArguments: [String]) throws {
        try self.init(file: File(pathDeferringReading: filePath), compilerArguments: compilerArguments)
    }

    /// Creates a new synchronous _SourceKitten_ Swift Documentation request.
    ///
    /// - Warning: The request is sent synchronously, so ensure this initializer is not called on the main thread.
    ///
    /// - Parameters:
    ///   - filePath: The absolute file path to the source file to gather documentation for.
    ///   - module: The module that contains the source file.
    public convenience init(filePath: String, module: SKModule) throws {
        try self.init(filePath: filePath, compilerArguments: module.compilerArguments)
    }

    /// Creates a new synchronous _SourceKitten_ Swift Documentation request.
    ///
    /// - Warning: The request is sent synchronously, so ensure this initializer is not called on the main thread.
    ///
    /// - Parameters:
    ///   - file: The source file to gather documentation for.
    ///   - module: The module that contains the source file.
    /// - Throws: A `SKError`, if an error occurs.
    public convenience init(file: File, module: SKModule) throws {
        try self.init(file: file, compilerArguments: module.compilerArguments)
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: SwiftDocsCodingKey.self)

        file = try container.decode(forKey: .file)
        let decodedResponse = try JSONDecoder().decode(SKGenericResponse<Substructure>.self,
                                                       from: container.decode(forKey: .response))
        super.init(skInformation: decodedResponse)
    }

}
