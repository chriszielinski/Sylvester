//
//  SKConvertMarkupToXML.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 3/4/19.
//  Copyright © 2019 Big Z Labs. All rights reserved.
//

/// Represents a _SourceKit_ Markup parsing request.
open class SKConvertMarkupToXML: SKSourceTextResponse {

    // MARK: - Public Initializers

    /// Creates a new synchronous _SourceKit_ Markup parsing request.
    ///
    /// - Warning: The request is sent synchronously, so ensure this initializer is not called on the main thread.
    ///
    /// - Parameters:
    ///   - markup: The extracted Markup to parse.
    /// - Throws: A `SKError`, if an error occurs.
    public init(markup: String) throws {
        let response = try SylvesterInterface.shared.convertMarkupToXML(sourceText: markup)
        super.init(sourceText: response.sourceText)
    }

    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

}
