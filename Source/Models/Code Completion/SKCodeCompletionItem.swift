//
//  SKCodeCompletionItem.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 12/16/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

public struct SKCodeCompletionItem {

    // MARK: - Internal Declarations

    enum CodingKeys: String, CodingKey {
        case kind = "key.kind"
        case name = "key.name"
        case sourceText = "key.sourcetext"
        case description = "key.description"
        case typeName = "key.typename"
        case briefDocumentation = "key.doc.brief"
        case context = "key.context"
        case numberOfBytesToErase = "key.num_bytes_to_erase"
        case isNotRecommended = "key.not_recommended"
        case substructure = "key.substructure"
        case associatedUSRs = "key.associated_usrs"
        case moduleName = "key.modulename"
    }

    // MARK: - Public Type Aliases

    public typealias Context = SKCodeCompletionContext
    public typealias Kind = SKSourceKind
    public typealias Substructure = SKCodeCompletionSubstructure

    // MARK: - Public Stored Properties

    /// The UID for the declaration kind (function, class, etc.).
    public let kind: Kind
    /// The name of the word being completed.
    public let name: String
    /// The text to be inserted in source.
    public let sourceText: String
    /// The text to be displayed in code-completion window.
    public let description: String
    /// The text describing the type of the item.
    public let typeName: String
    /// The brief documentation of the item.
    public let briefDocumentation: String?
    /// The semantic context of the code completion item.
    public let context: Context
    /// The number of bytes to the left of the cursor that should be erased before inserting this completion item.
    public let numberOfBytesToErase: Int
    /// Whether the item is to be avoided (e.g. because the declaration is unavailable).
    public let isNotRecommended: Bool
    /// The substructure that represents ranges of structural elements in the item description, such as the
    /// parameters of a function.
    ///
    /// Only present for `SKCodeCompletionSession` requests.
    public let substructure: Substructure?
    /// The associated Unified Symbol Resolutions (USRs) of the item.
    public let associatedUSRs: String?
    /// The name of the module the item belongs to.
    public let moduleName: String?

}

// MARK: - Codable Protocol

extension SKCodeCompletionItem: Codable {

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        kind = try container.decode(forKey: .kind)
        name = try container.decode(forKey: .name)
        sourceText = try container.decode(forKey: .sourceText)
        description = try container.decode(forKey: .description)
        typeName = try container.decode(forKey: .typeName)
        briefDocumentation = try container.decodeIfPresent(forKey: .briefDocumentation)
        context = try container.decode(forKey: .context)
        numberOfBytesToErase = try container.decode(forKey: .numberOfBytesToErase)

        if container.contains(.isNotRecommended) {
            // For normal code completion requests, the JSON value is a Boolean.
            // For code completion session requests, the JSON value is a Number...
            if let notRecommendedBoolean: Bool = try? container.decode(forKey: .isNotRecommended) {
                isNotRecommended = notRecommendedBoolean
            } else {
                let notRecommendedNumber: Int = try container.decode(forKey: .isNotRecommended)
                isNotRecommended = notRecommendedNumber == 1
            }
        } else {
            isNotRecommended = false
        }

        substructure = try container.decodeIfPresent(forKey: .substructure)
        associatedUSRs = try container.decodeIfPresent(forKey: .associatedUSRs)
        moduleName = try container.decodeIfPresent(forKey: .moduleName)
    }

}

// MARK: - JSON Debug String Convertable Protocol

extension SKCodeCompletionItem: JSONDebugStringConvertible {}

// MARK: - Equatable Protocol

extension SKCodeCompletionItem: Equatable {}
