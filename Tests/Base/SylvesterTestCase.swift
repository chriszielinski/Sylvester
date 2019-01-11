//
//  SylvesterTestCase.swift
//  Sylvester Tests 😼
//
//  Created by Chris Zielinski on 12/2/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

import XCTest
import SourceKittenFramework
import Mustache
#if XPC
@testable import SylvesterXPC
#else
@testable import Sylvester
#endif

class SylvesterTestCase: XCTestCase {

    // MARK: - Internal Declarations

    enum MustacheKey: String {
        case filePath = "file_path"
    }

    enum SourceFile: String {
        case appDelegate = "AppDelegate"
        case viewController = "ViewController"
        case placeholders = "Placeholders"
        case aProtocol = "AProtocol"
    }

    // swiftlint:disable nesting
    struct TestFixture {

        enum Directory: String {
            case testProjectDirectory = "Test Project"
        }

        enum Mustache: String {
            case appDelegateEditorOpenMustache = "app-delegate-editor-open.mustache"
            case appDelegateSwiftDocumentationMustache = "app-delegate-swift-documentation.mustache"

            case viewControllerEditorOpenMustache = "view-controller-editor-open.mustache"
            case viewControllerSwiftDocumentationMustache = "view-controller-swift-documentation.mustache"

            case placeholdersEditorOpenMustache = "placeholders-editor-open.mustache"
            case placeholdersSwiftDocumentationMustache = "placeholders-swift-documentation.mustache"

            case aProtocolEditorOpenMustache = "a-protocol-editor-open.mustache"
        }

        enum JSON: String {
            case viewControllerSyntaxMapJSON = "view-controller-syntax-map.json"
            case placeholdersSyntaxMapJSON = "placeholders-syntax-map.json"
        }
    }
    // swiftlint:enable nesting

    // MARK: - Static Stored Properties

    static var isTravisBuild: Bool {
        #if TRAVIS
        return true
        #else
        return false
        #endif
    }

    static var isXcodeBuild: Bool {
        #if XCODEBUILD
        return true
        #else
        return false
        #endif
    }

    static var testFixturesURL: URL = {
        return URL(fileURLWithPath: ProcessInfo.processInfo.environment["TEST_FIXTURES_PATH"]!, isDirectory: true)
    }()

    static var testProjectDirectoryPath: String = {
        return filePath(for: TestFixture.Directory.testProjectDirectory).path
    }()

    static var testModule: Module = {
        return Module(xcodeBuildArguments: [], name: nil, inPath: testProjectDirectoryPath)!
    }()

    /// A dictionary mapping a source file name to its file path.
    ///
    /// - Warning: Assumes that the source file names are unique.
    ///
    static var testModuleSourceFiles: [String: String] = {
        return Dictionary(uniqueKeysWithValues: testModule.sourceFiles
            .map({ (URL(fileURLWithPath: $0, isDirectory: false).deletingPathExtension().lastPathComponent, $0) }))
    }()

    // MARK: - Static Methods

    static func loadModule() {
        _ = testModule
    }

    static func filePath(forTestFixture name: String) -> URL {
        return SylvesterTestCase.testFixturesURL.appendingPathComponent(name)
    }

    static func filePath<T: RawRepresentable>(for testFixture: T) -> URL where T.RawValue == String {
        return filePath(forTestFixture: testFixture.rawValue)
    }

    static func print(_ item: Any, separator: String = " ", terminator: String = "\n") {
        if isXcodeBuild {
            Swift.print("Test Suite '\(item)' started at", separator: separator, terminator: terminator)
        } else {
            Swift.print(item, separator: separator, terminator: terminator)
        }
    }

    // MARK: - Stored Properties

    let expectationTimeOut: TimeInterval = 15

    // MARK: - Computed Properties

    var testModule: Module {
        return SylvesterTestCase.testModule
    }

    var testModuleCompilerArguments: [String] {
        return SylvesterTestCase.testModule.compilerArguments
    }

    // MARK: - File Helper Methods

    func filePath(for testFixture: TestFixture.Mustache) -> URL {
        return SylvesterTestCase.filePath(for: testFixture)
    }

    func filePath(for testFixture: TestFixture.JSON) -> URL {
        return SylvesterTestCase.filePath(for: testFixture)
    }

    func filePath(for sourceFile: SourceFile) -> String {
        return SylvesterTestCase.testModuleSourceFiles[sourceFile.rawValue]!
    }

    func readSourceFile(_ name: SourceFile) throws -> String {
        return try String(contentsOfFile: filePath(for: name))
    }

    func readTestFixture(_ name: TestFixture.Mustache) throws -> String {
        return try readTestFixture(enumCase: name)
    }

    func readTestFixture(_ name: TestFixture.JSON) throws -> String {
        return try readTestFixture(enumCase: name)
    }

    private func readTestFixture<T: RawRepresentable>(enumCase: T) throws -> String where T.RawValue == String {
        return try String(contentsOf: SylvesterTestCase.filePath(for: enumCase))
    }

    // MARK: - Mustache Test Fixture Methods

    func renderMustache(template: TestFixture.Mustache, usingFilePath path: String) -> String {
        do {
            let mustacheTemplate = try Template(URL: filePath(for: template))
            return try mustacheTemplate.render([
                MustacheKey.filePath.rawValue: path.replacingOccurrences(of: "/", with: "\\/")
                ])
        } catch {
            print(error)
            fatalError(error.localizedDescription)
        }
    }

    func renderMustache(template: TestFixture.Mustache, using values: Any) -> String {
        do {
            let mustacheTemplate = try Template(URL: filePath(for: template))
            return try mustacheTemplate.render(values)
        } catch {
            print(error)
            fatalError(error.localizedDescription)
        }
    }

    func decodeMustache(template: TestFixture.Mustache, sourceFile: SourceFile) throws -> SKBaseResponse {
        let path = filePath(for: sourceFile)
        let jsonString = renderMustache(template: template,
                                        usingFilePath: path)

        do {
            let response: SKBaseResponse = try decodeJSON(string: jsonString)
            response.resolve(from: path)
            return response
        } catch {
            fatalError((error as NSError).description)
        }
    }

    // MARK: - JSON Test Fixture Methods

    func decodeJSONTestFixture<T: Decodable>(name: TestFixture.JSON) throws -> T {
        let data = try Data(contentsOf: filePath(for: name))
        return try decodeJSON(data: data)
    }

    func decodeJSON<T: Decodable>(string: String) throws -> T {
        return try decodeJSON(data: string.data(using: .utf8)!)
    }

    func decodeJSON<T: Decodable>(data: Data) throws -> T {
        return try JSONDecoder().decode(T.self, from: data)
    }

    func encodeObjectToJSON<T: Encodable>(_ object: T) throws -> String {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        let jsonData = try jsonEncoder.encode(object)
        return String(data: jsonData, encoding: .utf8)!
    }

    func writeJSONFixture<T: Encodable>(for encodableObject: T, name: TestFixture.Mustache) {
        writeJSONFixture(for: encodableObject, enumCase: name) { jsonString in
            let sourceFile: SourceFile
            switch name {
            case .appDelegateEditorOpenMustache, .appDelegateSwiftDocumentationMustache:
                sourceFile = .appDelegate
            case .viewControllerEditorOpenMustache, .viewControllerSwiftDocumentationMustache:
                sourceFile = .viewController
            case .placeholdersEditorOpenMustache, .placeholdersSwiftDocumentationMustache:
                sourceFile = .placeholders
            case .aProtocolEditorOpenMustache:
                sourceFile = .aProtocol
            }
            let path = self.filePath(for: sourceFile).replacingOccurrences(of: "/", with: "\\/")
            return jsonString.replacingOccurrences(of: path, with: "{{ file_path }}")
        }
    }

    func writeJSONFixture<T: Encodable>(for encodableObject: T, name: TestFixture.JSON) {
        writeJSONFixture(for: encodableObject, enumCase: name)
    }

    private func writeJSONFixture<T1: Encodable,
                                  T2: RawRepresentable>(for encodableObject: T1,
                                                        enumCase: T2,
                                                        modifyClosure: ((String) -> String)? = nil)
                                                        where T2.RawValue == String {
        do {
            var jsonString = try encodeObjectToJSON(encodableObject)

            if let closure = modifyClosure {
                jsonString = closure(jsonString)
            }

            try jsonString.write(to: SylvesterTestCase.filePath(for: enumCase), atomically: true, encoding: .utf8)
        } catch {
            print("Failed to write JSON fixture '\(enumCase.rawValue)':\n\t\(error)")
        }
    }

    // MARK: - Helper Methods

    func print(_ item: Any, separator: String = " ", terminator: String = "\n") {
        SylvesterTestCase.print(item, separator: separator, terminator: terminator)
    }

    func diff(_ string: String, expected expectedString: String, withNewLines: Bool = true) -> String? {
        let firstDifferenceResult = firstDifferenceBetweenStrings(string, expectedString)

        switch firstDifferenceResult {
        case .noDifference:
            return nil
        case .differenceAtIndex:
            return prettyDescriptionOfFirstDifferenceResult(firstDifferenceResult: firstDifferenceResult,
                                                            string1: string,
                                                            string2: expectedString,
                                                            withNewLines: withNewLines)
        }
    }

    // MARK: - Test Assertion Methods

    // swiftlint:disable identifier_name
    func SylvesterAssert<T: Encodable>(_ object: T,
                                       equalsTestFixture testFixture: TestFixture.JSON,
                                       file: StaticString = #file,
                                       line: UInt = #line) throws {
        let jsonFixture = try readTestFixture(testFixture)
        try SylvesterAssert(object, expected: jsonFixture, file: file, line: line)
    }

    func SylvesterAssert<T: Encodable>(_ object: T,
                                       equalsTestFixture testFixture: TestFixture.Mustache,
                                       filePath: String,
                                       file: StaticString = #file,
                                       line: UInt = #line) throws {
        let jsonFixture = renderMustache(template: testFixture, usingFilePath: filePath)
        try SylvesterAssert(object, expected: jsonFixture, file: file, line: line)
    }

    func SylvesterAssert<T: Encodable>(_ object: T,
                                       expected expectedString: String,
                                       file: StaticString = #file,
                                       line: UInt = #line) throws {
        let jsonObject = try encodeObjectToJSON(object)
        SylvesterAssertEqual(jsonObject, expected: expectedString, file: file, line: line)
    }

    func SylvesterAssertEqual(_ string: String?,
                              expected expectedString: String,
                              file: StaticString = #file,
                              line: UInt = #line) {
        guard let string = string
            else { return XCTFail("Provided string is nil.", file: file, line: line) }

        let diffResultString = diff(string, expected: expectedString, withNewLines: !SylvesterTestCase.isTravisBuild)
        let failureMessage: String

        if SylvesterTestCase.isTravisBuild {
            failureMessage = diffResultString?.replacingOccurrences(of: "\n", with: " ") ?? ""
        } else {
            failureMessage = "\"\n\n\(diffResultString ?? "")\n\n\""
        }

        let diffIsEmpty = diffResultString == nil
        XCTAssertTrue(diffIsEmpty, failureMessage, file: file, line: line)
    }
    // swiftlint:enable identifier_name

}
