//
//  SKDiagnostic.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 1/28/19.
//  Copyright © 2019 Big Z Labs. All rights reserved.
//

/// Represents a compiler diagnostics emitted during parsing of a source file.
public struct SKDiagnostic {

    // MARK: - Internal Declarations

    enum CodingKeys: String, CodingKey {
        case line = "key.line"
        case column = "key.column"
        case ranges = "key.ranges"
        case filePath = "key.filepath"
        case severity = "key.severity"
        case description = "key.description"
    }

    // MARK: - Public Type Aliases

    public typealias ByteRange = SKByteRange
    public typealias Severity = SKDiagnosticSeverity

    // MARK: - Public Stored Properties

    /// The line upon which the diagnostic was emitted.
    public let line: Int
    /// The column upon which the diagnostic was emitted.
    public let column: Int
    public let ranges: SKSortedEntities<ByteRange>?
    /// The absolute path to the file that was being parsed when the diagnostic was emitted.
    public let filePath: String
    /// The severity of the diagnostic.
    public let severity: Severity
    /// A description of the diagnostic.
    public let description: String

}

// MARK: - Codable Protocol

extension SKDiagnostic: Codable {}

// MARK: - Equatable Protocol

extension SKDiagnostic: Equatable {}

// MARK: - JSON Debug String Convertible Protocol

extension SKDiagnostic: JSONDebugStringConvertible {}
