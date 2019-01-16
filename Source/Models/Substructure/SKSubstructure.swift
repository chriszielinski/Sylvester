//
//  SKSubstructure.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 7/2/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

import SourceKittenFramework

open class SKSubstructure: NSObject, Codable {

    // MARK: - Internal Declarations

    enum CodingKeys: String, CodingKey {
        case accessibility = "key.accessibility"
        case annotatedDeclaration = "key.annotated_decl"
        case attributes = "key.attributes"
        case bodyLength = "key.bodylength"
        case bodyOffset = "key.bodyoffset"
        case docColumn = "key.doc.column"
        case docComment = "key.doc.comment"
        case docDeclaration = "key.doc.declaration"
        case docFile = "key.doc.file"
        case docFullAsXML = "key.doc.full_as_xml"
        case docLine = "key.doc.line"
        case docName = "key.doc.name"
        case docParameters = "key.doc.parameters"
        case docType = "key.doc.type"
        case docLength = "key.doclength"
        case docOffset = "key.docoffset"
        case elements = "key.elements"
        case filePath = "key.filepath"
        case fullyAnnotatedDeclaration = "key.fully_annotated_decl"
        case inheritedTypes = "key.inheritedtypes"
        case kind = "key.kind"
        case length = "key.length"
        case name = "key.name"
        case nameLength = "key.namelength"
        case nameOffset = "key.nameoffset"
        case offset = "key.offset"
        case parsedDeclaration = "key.parsed_declaration"
        case parsedScopeEnd = "key.parsed_scope.end"
        case parsedScopeStart = "key.parsed_scope.start"
        case runtimeName = "key.runtime_name"
        case overrides = "key.overrides"
        case setterAccessibility = "key.setter_accessibility"
        case children = "key.substructure"
        case typeName = "key.typename"
        case typeUSR = "key.typeusr"
        case usr = "key.usr"
    }

    // MARK: - Public Type Aliases

    public typealias AccessLevel = SKAccessLevel
    public typealias Attribute = SKAttribute
    public typealias DocumentationParameter = SKDocumentationParameter
    public typealias Element = SKElement
    public typealias InheritedType = SKInheritedType
    public typealias Override = SKOverride
    public typealias Kind = SKSubstructureKind

    // MARK: - Public Stored Properties

    /// The zero-based index of the substructure relative to the source file.
    ///
    /// - Note: The first substructure in each source file will begin from zero.
    ///
    public var index: Int!
    /// The parent substructure, or `nil` if this substructure is a root.
    public weak var parent: SKSubstructure?

    /// The [access level](https://docs.swift.org/swift-book/LanguageGuide/AccessControl.html) of the substructure.
    public let accessibility: AccessLevel?
    /// The XML representing how the substructure was declared.
    public let annotatedDeclaration: String?
    /// The [attributes](https://docs.swift.org/swift-book/ReferenceManual/Attributes.html) of the substructure.
    ///
    /// The attributes include prefixed keywords such as `override`.
    ///
    /// - Note: The attributes are ordered by decreasing byte offset (i.e. the first attribute in the source
    ///         is the last element in the array).
    public let attributes: SKEntities<Attribute>?
    /// The byte offset of the substructure's body inside the source contents.
    public let bodyOffset: Int?
    /// The byte length of the substructure's body inside the source contents.
    public let bodyLength: Int?
    /// The column where the token's declaration begins (Int64).
    public let docColumn: Int?
    /// The documentation comment.
    public let docComment: String?
    /// The declaration of documented token.
    public let docDeclaration: String?
    /// The file where the documented token is located.
    public let docFile: String?
    /// The XML representing the substructure and its documentation.
    ///
    /// Only present when the substructure is documented.
    public let docFullAsXML: String?
    /// The line where the token's declaration begins (Int64).
    public let docLine: Int?
    /// The name of the documented token (String).
    public let docName: String?
    /// The parameters of the documented token.
    public let docParameters: [DocumentationParameter]?
    /// The type of the documented token.
    public let docType: String?
    /// The byte offset of the substructure's documentation inside the source contents.
    public let docOffset: Int?
    /// The byte length of the substructure's documentation inside the source contents.
    public let docLength: Int?
    /// The elements of the substructure.
    ///
    /// - Note: The elements are ordered by increasing byte offset (i.e. the first element in the source
    ///         is the first element in the array).
    public let elements: SKEntities<Element>?
    /// The path to the source file.
    public var filePath: String?
    /// The XML representing the substructure.
    public let fullyAnnotatedDeclaration: String?
    /// The inherited types of the substructure.
    ///
    /// Only present when the response is from a `SKSwiftDocumentation` request.
    public let inheritedTypes: [InheritedType]?
    /// The UID for the declaration or reference kind (function, class, etc.).
    public let kind: Kind
    /// The byte offset of the substructure inside the source contents.
    ///
    /// This offset is the location of the substructure's declarative keyword (e.g. `class`, `let`, `func`, etc.).
    public let offset: Offset
    /// The byte length of the substructure inside the source contents.
    ///
    /// The length includes the substructure's body, if present.
    public let length: Int
    /// The display name for the substructure.
    public let name: String?
    /// The byte offset of the substructure's name inside the source contents.
    public let nameOffset: Int?
    /// The byte length of the substructure's name inside the source contents.
    ///
    /// For a function, the name encompasses everything up to the closing parameter `)`, including the generic
    /// parameter clause `<...>`.
    public let nameLength: Int?
    /// The parsed declaration.
    public let parsedDeclaration: String?
    /// The parsed scope end (Int64).
    public let parsedScopeEnd: Int?
    /// The parsed scope start (Int64).
    public let parsedScopeStart: Int?
    /// The objective-c runtime name.
    public let runtimeName: String?
    /// The overrides of the substructure.
    public let overrides: [Override]?
    /// The setter access level.
    public let setterAccessibility: AccessLevel?
    /// The substructure children of the substructure.
    public var children: SKSubstructureChildren?
    /// A string describing the type of the substructure.
    public let typeName: String?
    /// The Unified Symbol Resolution (USR) for the substructure's type.
    public let typeUSR: String?
    /// The Unified Symbol Resolution (USR) for the substructure.
    public let usr: String?

    // MARK: - Public Lazy Stored Properties

    /// Whether the substructure has a body (i.e. `bodyOffset` and `bodyLength` are non-nil).
    open lazy var hasBody: Bool = {
        return bodyByteRange != nil
    }()

    /// The byte range of the substructure (i.e. `offset` and `length`).
    ///
    /// Unlike `contentByteRange`, this range does not include the attributes.
    open lazy var byteRange: NSRange = {
        return NSRange(location: offset, length: length)
    }()

    /// The byte range of the substructure's name (i.e. `nameOffset` and `nameLength`).
    ///
    /// For a function, the name byte offset encompasses everything up to the closing parameter
    /// parenthesis `)`, including the generic parameter clause `<...>`.
    open lazy var nameByteRange: NSRange? = {
        guard let nameOffset = nameOffset,
            let nameLength = nameLength,
            nameOffset != 0 && nameLength != 0
            else { return nil }
        return NSRange(location: nameOffset, length: nameLength)
    }()

    /// The byte range of the substructure's body (i.e. `bodyOffset` and `bodyLength`).
    open lazy var bodyByteRange: NSRange? = {
        guard let bodyOffset = bodyOffset, let bodyLength = bodyLength
            else { return nil }
        return NSRange(location: bodyOffset, length: bodyLength)
    }()

    /// The byte range encompassing the entire substructure content, including any attributes.
    open lazy var contentByteRange: NSRange = {
        let startingOffset = attributes?.first?.offset ?? offset
        return NSRange(location: startingOffset, length: (offset + length) - startingOffset)
    }()

    /// Whether the substructure is a function-kind and has a return type.
    open lazy var isReturningFunction: Bool = {
        return functionReturnType != nil
    }()

    /// Returns the return type (`typeName`) of a function-kind substructure.
    open lazy var functionReturnType: String? = {
        guard isFunction
            else { return nil }
        return typeName
    }()

    // swiftlint:disable:next todo
    /// Whether the substructure is a mark delimiter, which are `TODO`, `FIXME`, and `MARK`.
    open lazy var isMark: Bool = {
        return kind == .commentMark
    }()

    /// Whether the substructure is a protocol or protocol extension.
    open lazy var isProtocol: Bool = {
        switch kind {
        case .protocol, .extensionProtocol:
            return true
        default:
            return false
        }
    }()

    /// Whether the substructure is a class-kind.
    ///
    /// Class-kinds are:
    ///  * `.class`
    ///  * `.varClass`
    ///  * `.extensionClass`
    ///  * `.functionMethodClass`
    ///
    open lazy var isClass: Bool = {
        switch kind {
        case .class, .varClass, .extensionClass, .functionMethodClass:
            return true
        default:
            return false
        }
    }()

    /// Whether the substructure is an extension-kind.
    ///
    /// Extension-kinds are:
    ///  * `.extension`
    ///  * `.extensionClass`
    ///  * `.extensionEnum`
    ///  * `.extensionStruct`
    ///  * `.extensionProtocol`
    ///
    open lazy var isExtension: Bool = {
        switch kind {
        case .extension, .extensionClass, .extensionEnum, .extensionStruct, .extensionProtocol:
            return true
        default:
            return false
        }
    }()

    /// Whether the substructure is a variable-kind.
    ///
    /// Variable-kinds are:
    ///  * `.varLocal`
    ///  * `.varInstance`
    ///  * `.varClass`
    ///  * `.varStatic`
    ///  * `.varGlobal`
    ///
    open lazy var isVariable: Bool = {
        switch kind {
        case .varLocal, .varInstance, .varClass, .varStatic, .varGlobal:
            return true
        default:
            return false
        }
    }()

    /// Whether the substructure is a function-kind.
    ///
    /// Function-kinds are:
    ///  * `.functionMethodInstance`
    ///  * `.functionMethodClass`
    ///  * `.functionMethodStatic`
    ///  * `.functionFree`
    ///
    open lazy var isFunction: Bool = {
        switch kind {
        case .functionMethodInstance, .functionMethodClass, .functionMethodStatic, .functionFree:
            return true
        default:
            return false
        }
    }()

    /// Whether the substructure is an overridden function.
    open lazy var isOverride: Bool = {
        return attributes?.containsAttribute(with: .override) ?? false
    }()

    /// Whether the substructure's parent is a protocol declaration.
    open lazy var isInsideProtocolDeclaration: Bool = {
        return parent?.kind == .protocol
    }()

}

// MARK: - Overridden NSObject Methods

extension SKSubstructure {

    override open func isEqual(_ object: Any?) -> Bool {
        guard let rhs = object as? SKSubstructure
            else { return false }

        return offset == rhs.offset
            && accessibility == rhs.accessibility
            && annotatedDeclaration == rhs.annotatedDeclaration
            && attributes == rhs.attributes
            && bodyOffset == rhs.bodyOffset
            && bodyLength == rhs.bodyLength
            && docColumn == rhs.docColumn
            && docComment == rhs.docComment
            && docDeclaration == rhs.docDeclaration
            && docFile == rhs.docFile
            && docFullAsXML == rhs.docFullAsXML
            && docLine == rhs.docLine
            && docName == rhs.docName
            && docParameters == rhs.docParameters
            && docType == rhs.docType
            && docOffset == rhs.docOffset
            && docLength == rhs.docLength
            && elements == rhs.elements
            && filePath == rhs.filePath
            && fullyAnnotatedDeclaration == rhs.fullyAnnotatedDeclaration
            && inheritedTypes == rhs.inheritedTypes
            && kind == rhs.kind
            && length == rhs.length
            && name == rhs.name
            && nameOffset == rhs.nameOffset
            && nameLength == rhs.nameLength
            && parsedDeclaration == rhs.parsedDeclaration
            && parsedScopeEnd == rhs.parsedScopeEnd
            && parsedScopeStart == rhs.parsedScopeStart
            && runtimeName == rhs.runtimeName
            && overrides == rhs.overrides
            && setterAccessibility == rhs.setterAccessibility
            && children == rhs.children
            && typeName == rhs.typeName
            && typeUSR == rhs.typeUSR
            && usr == rhs.usr
    }

}
