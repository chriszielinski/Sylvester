#!/usr/bin/swift
//
//  GenerateBoilerplate.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 12/2/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

import Foundation

let ignore: Set<String> = ["source.lang.swift.stmt"]
let prefixes: Set<String> = ["NS", "UI", "LLDB"]
let replacements: [String: String] = [
    "source.lang.swift.keyword.self": "keywordSelf",
    "source.lang.swift.keyword.Self": "keywordUppercaseSelf",
    "id": "ID",
    "url": "URL"
]
let keywords: Set<String> = [
    "associatedtype",
    "class",
    "deinit",
    "enum",
    "extension",
    "fileprivate",
    "func",
    "import",
    "init",
    "inout",
    "internal",
    "let",
    "open",
    "operator",
    "private",
    "protocol",
    "public",
    "static",
    "struct",
    "subscript",
    "typealias",
    "var",
    "break",
    "case",
    "continue",
    "default",
    "defer",
    "do",
    "else",
    "fallthrough",
    "for",
    "guard",
    "if",
    "in",
    "repeat",
    "return",
    "switch",
    "where",
    "while",
    "as",
    "Any",
    "catch",
    "false",
    "is",
    "nil",
    "rethrows",
    "super",
    "self",
    "Self",
    "throw",
    "throws",
    "true",
    "try",
    "#available",
    "#colorLiteral",
    "#column",
    "#else",
    "#elseif",
    "#endif",
    "#error",
    "#file",
    "#fileLiteral",
    "#function",
    "#if",
    "#imageLiteral",
    "#line",
    "#selector",
    "#sourceLocation",
    "#warning",
    "associativity",
    "convenience",
    "dynamic",
    "didSet",
    "final",
    "get",
    "infix",
    "indirect",
    "lazy",
    "left",
    "mutating",
    "none",
    "nonmutating",
    "optional",
    "override",
    "postfix",
    "precedence",
    "prefix",
    "Protocol",
    "required",
    "right",
    "set",
    "Type",
    "unowned",
    "weak",
    "willSet",
    "precedencegroup"
]

extension String {
    var invertFirstLetterCasing: String {
        let firstCharacterString = String(self.first!)
        if firstCharacterString.lowercased() == firstCharacterString {
            // First letter is lowercased.
            return firstCharacterString.uppercased() + String(self.dropFirst())
        } else {
            // First letter is uppercased.
            return firstCharacterString.lowercased() + String(self.dropFirst())
        }
    }
}

struct Boilerplate {

    class UID {

        let key: String
        let uniqueComponent: String

        var hasName: Bool {
            if name == nil {
                print("Skipping \"\(key)\"")
            }
            return name != nil
        }

        lazy var name: String? = {
            if let hardcodedName = replacements[key] {
                return hardcodedName
            }

            let keyComponents = uniqueComponent.components(separatedBy: .punctuationCharacters)

            // Filter out funky UIDs, such as `source.lang.swift.keyword._`.
            guard !keyComponents.isEmpty, !keyComponents.contains("")
                else { return nil }

            var firstComponent = keyComponents.first!
            if let prefixString = prefixes.first(where: { firstComponent.hasPrefix($0) }),
                let prefixRange = firstComponent.range(of: prefixString) {
                firstComponent.replaceSubrange(prefixRange, with: prefixString.lowercased())
            }

            let name = firstComponent + keyComponents.dropFirst().map({
                if let replacement = replacements[$0] {
                    return replacement
                } else {
                    return $0.invertFirstLetterCasing
                }
            }).joined()

            guard !keywords.contains(name)
                else { return "`\(name)`" }

            return name
        }()

        init(key: String, uniqueComponent: String) {
            self.key = key
            self.uniqueComponent = uniqueComponent
        }

    }

    typealias EnumerationCase = (uniqueKeyComponent: String, regex: String)

    static let sourceKitServicePath = "/Applications/Xcode.app/Contents/Developer/Toolchains/"
        + "XcodeDefault.xctoolchain/usr/lib/sourcekitd.framework/Versions/Current/XPCServices/"
        + "SourceKitService.xpc/Contents/MacOS/SourceKitService"

    let enumerationName: String
    var enumerationCaseTuples: [EnumerationCase]
    var enumerationCaseProtocols: [String]

    func generate() {
        var uidSets: [[UID]] = []

        for (uniqueKeyComponent, regex) in enumerationCaseTuples {
            let stringsOutput = Pipe()
            let grepOutput = Pipe()
            let uniqOutput = Pipe()

            let stringsProcess = Process()
            stringsProcess.launchPath = "/usr/bin/env"
            stringsProcess.arguments = [
                "strings",
                Boilerplate.sourceKitServicePath
            ]
            stringsProcess.standardOutput = stringsOutput

            let grep = Process()
            grep.launchPath = "/usr/bin/env"
            grep.arguments = ["grep", uniqueKeyComponent]
            grep.standardInput = stringsOutput
            grep.standardOutput = grepOutput

            let uniq = Process()
            uniq.launchPath = "/usr/bin/env"
            uniq.arguments = ["uniq"]
            uniq.standardInput = grepOutput
            uniq.standardOutput = uniqOutput

            stringsProcess.launch()
            grep.launch()
            uniq.launch()
            uniq.waitUntilExit()

            let data = uniqOutput.fileHandleForReading.readDataToEndOfFile()
            guard let output = String(data: data, encoding: .utf8)
                else { return print("[Error] Could not convert data to UTF-8 string.") }

            let nsOutput = output as NSString
            // swiftlint:disable:next force_try
            let regularExpression = try! NSRegularExpression(pattern: regex, options: [.anchorsMatchLines])
            let range = NSRange(location: 0, length: output.utf16.count)
            var uidSet: [UID] = []
            regularExpression.enumerateMatches(in: output,
                                               options: [],
                                               range: range) { (match, _, _) in
                                                let key = nsOutput.substring(with: match!.range)

                                                guard !ignore.contains(key)
                                                    else { return }

                                                let uniqueKeyComponent = nsOutput.substring(with: match!.range(at: 1))
                                                uidSet.append(UID(key: key,
                                                                  uniqueComponent: uniqueKeyComponent))
            }

            uidSets.append(uidSet)
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.setLocalizedDateFormatFromTemplate("MM/dd/yyyy")
        let formattedDate = dateFormatter.string(from: Date())

        let customProtocols = enumerationCaseProtocols.isEmpty
            ? ""
            : ", " + enumerationCaseProtocols.joined(separator: " ,")
        let enumerationConformingProtocols = "String, Equatable, Codable, "
            + "CaseIterable, SourceKitUID\(customProtocols)"

        var enumerationCases = ""
        for (index, uidSet) in uidSets.enumerated() {
            if index != 0 {
                enumerationCases += "\n\n"
            }

            enumerationCases += uidSet.filter({ $0.hasName }).map({ """
                    /// The `\($0.key)` SourceKit key.
                    case \($0.name!) = \"\($0.key)\"
                """ }).joined(separator: "\n")
        }

        let enumDeclaration = """
        //  \(enumerationName).swift
        //  Sylvester 😼
        //
        //  Created by the 'GenerateBoilerplate' script on \(formattedDate).

        /// - Warning: This enumeration is generated by the 'GenerateBoilerplate' script.
        ///            You can update this enumeration by running `make generate-boilerplate`.
        public enum \(enumerationName): \(enumerationConformingProtocols) {
        \(enumerationCases)
        }
        """

        let currentDirectoryURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        let outputURL = URL(fileURLWithPath: "\(enumerationName).swift",
                            isDirectory: false,
                            relativeTo: currentDirectoryURL)

        print("Writing '\(enumerationName).swift' to \(outputURL.absoluteString)")

        do {
            try (enumDeclaration.trimmingCharacters(in: .whitespacesAndNewlines) + "\n")
                .write(to: outputURL, atomically: true, encoding: .utf8)
        } catch {
            print(error)
        }
    }
}

Boilerplate(enumerationName: "SKSourceKind",
            enumerationCaseTuples: [
                ("source.lang.swift", "^source\\.lang\\.swift\\.(.+)$")
    ],
            enumerationCaseProtocols: []).generate()

Boilerplate(enumerationName: "SKCodeCompletionContext",
            enumerationCaseTuples: [
                ("source.codecompletion.context", "^source\\.codecompletion\\.context\\.(.+)$")
    ],
            enumerationCaseProtocols: []).generate()

Boilerplate(enumerationName: "SKDiagnosticStage",
            enumerationCaseTuples: [
                ("source.diagnostic.stage.swift", "^source\\.diagnostic\\.stage\\.swift\\.(.+)$")
    ],
            enumerationCaseProtocols: []).generate()

Boilerplate(enumerationName: "SKAccessLevel",
            enumerationCaseTuples: [
                ("source.lang.swift.accessibility", "^source\\.lang\\.swift\\.accessibility\\.(.+)$")
    ],
            enumerationCaseProtocols: []).generate()

Boilerplate(enumerationName: "SKKind",
            enumerationCaseTuples: [
                ("source.lang.swift.decl", "^source\\.lang\\.swift\\.decl\\.(.+)$"),
//                ("source.lang.swift.decl", "^source\\.lang\\.swift\\.(.+)$"),
//                ("source.lang.swift.ref", "^source\\.lang\\.swift\\.(.+)$"),
                ("source.lang.swift.syntaxtype", "^source\\.lang\\.swift\\.syntaxtype\\.(.+)$"),
                ("source.lang.swift.expr", "^source\\.lang\\.swift\\.(.+)$"),
                ("source.lang.swift.stmt", "^source\\.lang\\.swift\\.(.+)$")
    ],
            enumerationCaseProtocols: []).generate()

Boilerplate(enumerationName: "SKAttributeKind",
            enumerationCaseTuples: [
                ("source.decl.attribute", "^source\\.decl\\.attribute\\.(.+)$")
    ],
            enumerationCaseProtocols: []).generate()

Boilerplate(enumerationName: "SKElementKind",
            enumerationCaseTuples: [
                ("source.lang.swift.structure.elem", "^source\\.lang\\.swift\\.structure\\.elem\\.(.+)$")
    ],
            enumerationCaseProtocols: []).generate()

Boilerplate(enumerationName: "SKSyntaxKind",
            enumerationCaseTuples: [
                ("source.lang.swift.syntaxtype", "^source\\.lang\\.swift\\.syntaxtype\\.(.+)$")
    ],
            enumerationCaseProtocols: []).generate()
