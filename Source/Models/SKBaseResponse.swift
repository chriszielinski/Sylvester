//
//  SKBaseResponse.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 6/11/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

import SourceKittenFramework

open class SKBaseResponse: NSObject, Codable {

    // MARK: - Internal Declarations

    enum CodingKeys: String, CodingKey {
        case diagnosticStage = "key.diagnostic_stage"
        case length = "key.length"
        case offset = "key.offset"
        case topLevelSubstructures = "key.substructure"
        case syntaxMap = "key.syntaxmap"
    }

    // MARK: - Public Type Aliases

    public typealias DiagnosticStage = SKDiagnosticStage

    // MARK: - Public Stored Properties

    // swiftlint:disable:next line_length
    /// The compiler [diagnostic stage](https://github.com/apple/swift/blob/master/docs/SIL.rst#sil-in-the-swift-compiler).
    public let diagnosticStage: DiagnosticStage
    /// The byte length of the analyzed source contents.
    public let length: Int
    /// The starting byte offset of the analyzed source contents.
    public let offset: Int
    /// The top-level substructures in the analyzed source contents.
    public let topLevelSubstructures: SKSubstructureChildren
    /// The syntax map of the analyzed source contents.
    public let syntaxMap: SyntaxMap?

    // MARK: - Public Initializers

    public init(diagnosticStage: DiagnosticStage,
                length: Int,
                offset: Int,
                substructureChildren: SKSubstructureChildren,
                syntaxMap: SyntaxMap?) {
        self.diagnosticStage = diagnosticStage
        self.length = length
        self.offset = offset
        self.topLevelSubstructures = substructureChildren
        self.syntaxMap = syntaxMap
    }

    public init(skInformation: SKBaseResponse) {
        diagnosticStage = skInformation.diagnosticStage
        length = skInformation.length
        offset = skInformation.offset
        topLevelSubstructures = skInformation.topLevelSubstructures
        syntaxMap = skInformation.syntaxMap
    }

    // MARK: - Public Methods

    /// The entry point to a recursive resolution process that sets each child's `index`, `parent`, and
    /// `filePath` properties.
    ///
    /// This method calls the `topLevelSubstructures`'s `SKSubstructureChildren.resolve(parent:index:filePath:)` method.
    ///
    /// - Note: If the resolution process is unnecessary, overriding this method with an empty body will
    ///         suffice to omit it.
    ///
    /// - Parameter filePath: The absolute file path to the source file analyzed.
    open func resolve(from filePath: String?) {
        topLevelSubstructures.resolve(index: 0, filePath: filePath)
    }

}

// MARK: - JSON Debug String Convertable Protocol

extension SKBaseResponse: JSONDebugStringConvertable {

    open override var debugDescription: String {
        return jsonDebugDescription
    }

}

// MARK: - Equatable Protocol

extension SKBaseResponse {

    open override func isEqual(_ object: Any?) -> Bool {
        guard let rhs = object as? SKBaseResponse
            else { return false }

        return diagnosticStage == rhs.diagnosticStage
            && length == rhs.length
            && offset == rhs.offset
            && topLevelSubstructures == rhs.topLevelSubstructures
            && syntaxMap == rhs.syntaxMap
    }

}
