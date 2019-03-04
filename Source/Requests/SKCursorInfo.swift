//
//  SKCursorInfo.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 2/16/19.
//  Copyright © 2019 Big Z Labs. All rights reserved.
//

import SourceKittenFramework

/// Represents a _SourceKit_ cursor info request.
open class SKCursorInfo: Codable {

    // MARK: - Internal Declarations

    enum CodingKeys: String, CodingKey {
        case kind = "key.kind"
        case name = "key.name"
        case usr = "key.usr"
        case filePath = "key.filepath"
        case offset = "key.offset"
        case length = "key.length"
        case typeName = "key.typename"
        case annotatedDeclaration = "key.annotated_decl"
        case fullyAnnotatedDeclaration = "key.fully_annotated_decl"
        case docFullAsXML = "key.doc.full_as_xml"
        case typeUSR = "key.typeusr"
        case privateIsSystem = "key.is_system"
        case groupName = "key.groupname"
        case overrides = "key.overrides"
        case moduleName = "key.modulename"
        case relatedDeclarations = "key.related_decls"
    }

    // MARK: - Public Stored Properties

    /// The UID for the declaration or reference kind (function, class, etc.).
    public let kind: SKSourceKind
    /// The displayed name for the token.
    public let name: String
    /// The Unified Symbol Resolutions (USR) string for the token.
    public let usr: String?
    /// The path to the file.
    public let filePath: String?
    /// The byte offset of the token inside the source contents.
    public let offset: Int?
    /// The byte length of the token.
    public let length: Int?
    /// The text describing the type of the result.
    public let typeName: String
    /// The XML representing how the token was declared.
    public let annotatedDeclaration: String
    /// The XML representing the token.
    public let fullyAnnotatedDeclaration: String
    /// The XML representing the token and its documentation.
    public let docFullAsXML: String?
    /// The Unified Symbol Resolutions (USR) string for the type.
    public let typeUSR: String
    /// The name of the group the token belongs to.
    public let groupName: String?
    /// An array of Unified Symbol Resolutions (USR) that the token overrides.
    public let overrides: [SKOverride]?
    /// The module name that the token is a member of.
    public let moduleName: String?
    /// An array of related declarations.
    public let relatedDeclarations: [SKAnnotatedDeclaration]?

    // MARK: - Private Stored Properties

    /// Whether the token is a member of a system module.
    ///
    /// This property stores the decoded value. Use `isSystem` for retrieval.
    private let privateIsSystem: Bool?

    // MARK: - Public Computed Properties

    /// Whether the token is a member of a system module.
    public var isSystem: Bool {
        return privateIsSystem == nil ? false : privateIsSystem!
    }

    // MARK: - Public Initializers

    /// The designated initializer.
    ///
    /// The convenience initilizers `init(file:offset:compilerArguments:cancelOnSubsequentRequest:)` and
    /// `init(file:usr:compilerArguments:cancelOnSubsequentRequest:)` should be used.
    public init?(file: File,
                 offset: Int?,
                 usr: String?,
                 compilerArguments: [String],
                 cancelOnSubsequentRequest: Bool) throws {
        guard let cursorInfo = try SylvesterInterface.shared
            .cursorInfo(file: file,
                        offset: offset,
                        usr: usr,
                        compilerArguments: compilerArguments,
                        cancelOnSubsequentRequest: cancelOnSubsequentRequest)
            else { return nil }

        kind = cursorInfo.kind
        name = cursorInfo.name
        self.usr = cursorInfo.usr
        self.filePath = cursorInfo.filePath
        self.offset = cursorInfo.offset
        length = cursorInfo.length
        typeName = cursorInfo.typeName
        annotatedDeclaration = cursorInfo.annotatedDeclaration
        fullyAnnotatedDeclaration = cursorInfo.fullyAnnotatedDeclaration
        docFullAsXML = cursorInfo.docFullAsXML
        typeUSR = cursorInfo.typeUSR
        privateIsSystem = cursorInfo.isSystem
        groupName = cursorInfo.groupName
        overrides = cursorInfo.overrides
        moduleName = cursorInfo.moduleName
        relatedDeclarations = cursorInfo.relatedDeclarations
    }

    /// Creates a new synchronous _SourceKit_ cursor info request.
    ///
    /// - Important: The cursor info request requires a valid source file path.
    ///
    /// - Warning: The request is sent synchronously, so ensure this initializer is not called on the main thread.
    ///
    /// - Parameters:
    ///   - file: The source file.
    ///   - offset: The byte offset of the code point inside the source contents.
    ///   - compilerArguments: The compiler arguments used to build the module (e.g `["-sdk",
    ///     "/path/to/sdk"]`). These must include the path to the file.
    ///   - cancelOnSubsequentRequest: Whether this request should be canceled if a new cursor-info request is
    ///     made that uses the same AST. This behavior is a workaround for not having first-class cancelation.
    ///     For backwards compatibility, the default is `true`.
    /// - Returns: The resulting `SKCursorInfo`, or `nil` if an invalid `offset` or `usr` was provided.
    /// - Throws: A `SKError`, if an error occurs.
    public convenience init?(file: File,
                             offset: Int,
                             compilerArguments: [String],
                             cancelOnSubsequentRequest: Bool = true) throws {
        try self.init(file: file,
                      offset: offset,
                      usr: nil,
                      compilerArguments: compilerArguments,
                      cancelOnSubsequentRequest: cancelOnSubsequentRequest)
    }

    /// Creates a new synchronous _SourceKit_ cursor info request.
    ///
    /// - Important: The cursor info request requires a valid source file path.
    ///
    /// - Warning: The request is sent synchronously, so ensure this initializer is not called on the main thread.
    ///
    /// - Parameters:
    ///   - file: The source file.
    ///   - usr: The Unified Symbol Resolutions (USR) string for the entity.
    ///   - compilerArguments: The compiler arguments used to build the module (e.g `["-sdk",
    ///     "/path/to/sdk"]`). These must include the path to the file.
    ///   - cancelOnSubsequentRequest: Whether this request should be canceled if a new cursor-info request is
    ///     made that uses the same AST. This behavior is a workaround for not having first-class cancelation.
    ///     For backwards compatibility, the default is `true`.
    /// - Throws: A `SKError`, if an error occurs.
    public convenience init?(file: File,
                             usr: String,
                             compilerArguments: [String],
                             cancelOnSubsequentRequest: Bool = true) throws {
        try self.init(file: file,
                      offset: nil,
                      usr: usr,
                      compilerArguments: compilerArguments,
                      cancelOnSubsequentRequest: cancelOnSubsequentRequest)
    }

}

// MARK: - JSON Debug String Convertible Protocol

extension SKCursorInfo: JSONDebugStringConvertible {}
