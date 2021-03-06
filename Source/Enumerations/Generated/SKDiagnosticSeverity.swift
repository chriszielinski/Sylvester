//  SKDiagnosticSeverity.swift
//  Sylvester 😼
//
//  Created by the 'generate_boilerplate.swift' script on 01/29/2019.

/// - Warning: This enumeration is generated by the 'generate_boilerplate.swift' script.
///            You can update this enumeration by running `make generate-boilerplate`.
public enum SKDiagnosticSeverity: String, Equatable, Codable, CaseIterable, SourceKitUID {
    /// The `source.diagnostic.severity.warning` SourceKit key.
    case warning = "source.diagnostic.severity.warning"
    /// The `source.diagnostic.severity.error` SourceKit key.
    case error = "source.diagnostic.severity.error"
    /// The `source.diagnostic.severity.note` SourceKit key.
    case note = "source.diagnostic.severity.note"
}
