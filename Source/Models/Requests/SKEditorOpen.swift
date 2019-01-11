//
//  SKEditorOpen.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 12/3/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

import SourceKittenFramework

/// Represents a _SourceKit_ editor open request for a Swift file.
open class SKEditorOpen: SKBaseResponse {

    // MARK: - Public Initializers

    /// Creates a new synchronous _SourceKit_ editor open request.
    ///
    /// - Warning: The request is sent synchronously, so ensure this initializer is not called on the main thread.
    ///
    /// - Parameters:
    ///   - file: The source file.
    /// - Throws: A `SKError` if an error occurs.
    public init(file: File) throws {
        super.init(skInformation: try SourceKittenInterface.shared.editorOpen(file: file))

        resolve(from: file.path)
    }

    /// Creates a new synchronous _SourceKit_ editor open request.
    ///
    /// - Warning: The request is sent synchronously, so ensure this initializer is not called on the main thread.
    ///
    /// - Parameters:
    ///   - filePath: The absolute file path to the source file.
    /// - Throws: A `SKError` if an error occurs.
    public convenience init(filePath: String) throws {
        try self.init(file: File(pathDeferringReading: filePath))
    }

    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

}
