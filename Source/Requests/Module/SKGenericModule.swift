//
//  SKGenericModule.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 1/2/19.
//  Copyright © 2019 Big Z Labs. All rights reserved.
//

import SourceKittenFramework
#if !COCOAPODS
import SylvesterCommon
#endif

/// Represents a generic _SourceKitten_ documentation request for a given module.
open class SKGenericModule<S: SKBaseSubstructure, T: SKGenericSwiftDocs<S>> {

    // MARK: - Public Stored Properties

    /// The backing _SourceKitten_ module.
    public let module: Module

    // MARK: - Public Stored Properties

    /// The path to the SDK the module was compiled with.
    public lazy var sdkPath: String? = {
        return module.sdkPath
    }()
    /// The target (triple) architecture the module was compiled for (e.g. `"arm64-apple-ios12.1"`).
    public lazy var target: String? = {
        return module.target
    }()

    // MARK: - Public Computed Properties

    /// The name of the module.
    public var name: String {
        return module.name
    }
    /// The compiler arguments required by _SourceKit_ to process the module's source files.
    public var compilerArguments: [String] {
        return module.compilerArguments
    }
    /// The source files in this module.
    ///
    /// The values are absolute file paths.
    public var sourceFiles: [String] {
        return module.sourceFiles
    }
    /// The documentation for the module's source files.
    ///
    /// - Warning: Typically expensive computed property.
    open var docs: [T] {
        do {
            return try SylvesterInterface.shared.moduleDocs(module: module)
        } catch {
            Utilities.print(error: error)
            return []
        }
    }

    // MARK: - Public Initializers

    /// Creates a new synchronous _SourceKitten_ module information request.
    ///
    /// - Warning: The request is sent synchronously, so ensure this initializer is not called on the main thread.
    ///
    /// - Parameters:
    ///   - xcodeBuildArguments: The arguments necessary pass in to `xcodebuild` to build this module.
    ///   - name: The module name. Will be parsed from `xcodebuild` output if nil.
    ///   - path: The path to run `xcodebuild` from. Uses current path by default.
    /// - Throws: A `SKError`, if an error occurs.
    public init(xcodeBuildArguments: [String],
                name: String? = nil,
                inPath path: String = FileManager.default.currentDirectoryPath) throws {
        module = try SylvesterInterface.shared.moduleInfo(xcodeBuildArguments: xcodeBuildArguments,
                                                             name: name,
                                                             in: path)
    }

}
