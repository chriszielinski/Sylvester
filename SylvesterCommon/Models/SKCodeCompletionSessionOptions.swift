//
//  SKCodeCompletionSessionOptions.swift
//  SylvesterCommon 😼
//
//  Created by Chris Zielinski on 9/17/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

import SourceKittenFramework

/// The default values reflect those defined in
/// [SourceKit](https://github.com/apple/swift/blob/master/tools/SourceKit/lib/SwiftLang/CodeCompletionOrganizer.h)
public struct SKCodeCompletionSessionOptions: Codable {

    // MARK: - Internal Declarations

    enum CodingKeys: String, CodingKey {
        case filterText = "key.codecomplete.filtertext"
        case requestStart = "key.codecomplete.requeststart"
        case requestLimit = "key.codecomplete.requestlimit"
        case sortByName = "key.codecomplete.sort.byname"
        case useImportDepth = "key.codecomplete.sort.useimportdepth"
        case groupOverloads = "key.codecomplete.group.overloads"
        case groupStems = "key.codecomplete.group.stems"
        case hideUnderscores = "key.codecomplete.hideunderscores"
        case hideLowPriority = "key.codecomplete.hidelowpriority"
        case hideByName = "key.codecomplete.hidebyname"
        case includeExactMatch = "key.codecomplete.includeexactmatch"
        case addInnerResults = "key.codecomplete.addinnerresults"
        case addInnerOperators = "key.codecomplete.addinneroperators"
        case addInitsToTopLevel = "key.codecomplete.addinitstotoplevel"
        case callPatternHeuristics = "key.codecomplete.callpatternheuristics"
        case fuzzyMatching = "key.codecomplete.fuzzymatching"
        case showTopNonLiteralResults = "key.codecomplete.showtopnonliteralresults"
        case semanticContextWeight = "key.codecomplete.sort.contextweight"
        case fuzzyMatchWeight = "key.codecomplete.sort.fuzzyweight"
        case popularityBonus = "key.codecomplete.sort.popularitybonus"
    }

    // MARK: - Public Stored Properties

    /// This property has a default value of `nil`.
    public var filterText: String?
    /// The result offset.
    ///
    /// This property has a default value of `nil`.
    public var requestStart: Int?
    /// The maximum number of results to return.
    ///
    /// This property has a default value of `nil`.
    public var requestLimit: Int?

    /// This property has a default value of `false`.
    public var sortByName: Bool = false
    /// This property has a default value of `true`.
    public var useImportDepth: Bool = true
    /// This property has a default value of `false`.
    public var groupOverloads: Bool = false
    /// This property has a default value of `false`.
    public var groupStems: Bool = false
    /// Greater than one to `reallyHideAllUnderscores`.
    ///
    /// This property has a default value of `1`.
    ///
    /// - Note: Not sure what `reallyHideAllUnderscores` means; found in the open-source Swift project.
    public var hideUnderscores: Int = 1
    /// This property has a default value of `true`.
    public var hideLowPriority: Bool = true
    /// This property has a default value of `true`.
    public var hideByName: Bool = true
    /// This property has a default value of `true`.
    public var includeExactMatch: Bool = true
    /// This property has a default value of `false`.
    public var addInnerResults: Bool = false
    /// This property has a default value of `true`.
    public var addInnerOperators: Bool = true
    /// This property has a default value of `false`.
    public var addInitsToTopLevel: Bool = false
    /// This property has a default value of `true`.
    public var callPatternHeuristics: Bool = true
    /// This property has a default value of `true`.
    public var fuzzyMatching: Bool = true
    /// This property has a default value of `3`.
    public var showTopNonLiteralResults: Int = 3
    /// Options for combining priorities.
    ///
    /// This property has a default value of `15`.
    public var semanticContextWeight: Int = 15
    /// This property has a default value of `10`.
    public var fuzzyMatchWeight: Int = 10
    /// This property has a default value of `2`.
    public var popularityBonus: Int = 2

    // MARK: - Public Initializers

    public init() {}

}

// MARK: - Equatable Protocol

extension SKCodeCompletionSessionOptions: Equatable {}

// MARK: - SourceKit Object Convertible Protocol

extension SKCodeCompletionSessionOptions: SourceKitObjectConvertible {

    public var sourcekitdObject: sourcekitd_object_t? {
        let sourceKitObjectDictionary: SourceKitObject = [
            "key.codecomplete.sort.byname": sortByName.toInt,
            "key.codecomplete.sort.useimportdepth": useImportDepth.toInt,
            "key.codecomplete.group.overloads": groupOverloads.toInt,
            "key.codecomplete.group.stems": groupStems.toInt,
            "key.codecomplete.hideunderscores": hideUnderscores,
            "key.codecomplete.hidelowpriority": hideLowPriority.toInt,
            "key.codecomplete.hidebyname": hideByName.toInt,
            "key.codecomplete.includeexactmatch": includeExactMatch.toInt,
            "key.codecomplete.addinnerresults": addInnerResults.toInt,
            "key.codecomplete.addinneroperators": addInnerOperators.toInt,
            "key.codecomplete.addinitstotoplevel": addInitsToTopLevel.toInt,
            "key.codecomplete.callpatternheuristics": callPatternHeuristics.toInt,
            "key.codecomplete.fuzzymatching": fuzzyMatching.toInt,
            "key.codecomplete.showtopnonliteralresults": showTopNonLiteralResults,
            "key.codecomplete.sort.contextweight": semanticContextWeight,
            "key.codecomplete.sort.fuzzyweight": fuzzyMatchWeight,
            "key.codecomplete.sort.popularitybonus": popularityBonus
        ]

        if let filterText = filterText {
            sourceKitObjectDictionary.updateValue(filterText, forKey: "key.codecomplete.filtertext")
        }
        if let requestStart = requestStart {
            sourceKitObjectDictionary.updateValue(requestStart, forKey: "key.codecomplete.requeststart")
        }
        if let requestLimit = requestLimit {
            sourceKitObjectDictionary.updateValue(requestLimit, forKey: "key.codecomplete.requestlimit")
        }

        return sourceKitObjectDictionary.sourcekitdObject
    }

}
