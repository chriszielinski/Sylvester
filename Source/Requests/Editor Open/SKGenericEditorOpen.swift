//
//  SKGenericEditorOpen.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 1/16/19.
//  Copyright © 2019 Big Z Labs. All rights reserved.
//

import SourceKittenFramework

/// Represents a generic _SourceKit_ editor open request for a Swift file.
open class SKGenericEditorOpen<Substructure: SKBaseSubstructure>: SKGenericResponse<Substructure> {

    // MARK: - Public Initializers

    /// Creates a new synchronous _SourceKit_ editor open request.
    ///
    /// - Warning: The request is sent synchronously, so ensure this initializer is not called on the main thread.
    ///
    /// - Parameters:
    ///   - file: The source file.
    /// - Throws: A `SKError`, if an error occurs.
    public init(file: File) throws {
        super.init(skInformation: try SylvesterInterface.shared.editorOpen(file: file))

        resolve(from: file.path)
    }

    /// Creates a new synchronous _SourceKit_ editor open request.
    ///
    /// - Warning: The request is sent synchronously, so ensure this initializer is not called on the main thread.
    ///
    /// - Parameters:
    ///   - filePath: The absolute file path to the source file.
    /// - Throws: A `SKError`, if an error occurs.
    public convenience init(filePath: String) throws {
        try self.init(file: File(pathDeferringReading: filePath))
    }

    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

}
