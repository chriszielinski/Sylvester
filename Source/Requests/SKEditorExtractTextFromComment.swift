//
//  SKEditorExtractTextFromComment.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 3/4/19.
//  Copyright © 2019 Big Z Labs. All rights reserved.
//

/// Represents a _SourceKit_ editor text extraction request.
open class SKEditorExtractTextFromComment: SKSourceTextResponse {

    // MARK: - Public Initializers

    /// Creates a new synchronous _SourceKit_ editor text extraction request.
    ///
    /// - Warning: The request is sent synchronously, so ensure this initializer is not called on the main thread.
    ///
    /// - Parameters:
    ///   - comment: The raw comment to extract the text from.
    /// - Throws: A `SKError`, if an error occurs.
    public init(_ comment: String) throws {
        let response = try SylvesterInterface.shared.editorExtractTextFromComment(sourceText: comment)
        super.init(sourceText: response.sourceText)
    }

    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

}
