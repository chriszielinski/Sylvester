//
//  OtherTests.swift
//  Sylvester Tests 😼
//
//  Created by Chris Zielinski on 12/11/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

import XCTest
import SourceKittenFramework
#if XPC
@testable import SylvesterXPC
#else
@testable import Sylvester
#endif
@testable import SylvesterCommon

class OtherTests: SylvesterMockEditorOpenTestCase {

    // MARK: - Test Methods

    func testStringExtensions() {
        continueAfterFailure = false
        let testString = "This is a test string 👍 with a unicode character in it."
        let byteNSRange = NSRange(location: 9, length: 18)

        let byteRange = testString.range(from: byteNSRange)
        XCTAssertNotNil(byteRange,
                        "Range returned by String is nil.")
        let substring = testString[byteRange!]
        XCTAssertEqual(String(substring), " test string 👍 ",
                       "Incorrect range returned by String.")

        let byteRangeFromNSString = (testString as NSString).range(from: byteNSRange)
        XCTAssertNotNil(byteRangeFromNSString,
                        "Range returned by NSString is nil.")
        XCTAssertEqual(String(testString[byteRangeFromNSString!]), " test string 👍 ",
                       "Incorrect range returned by NSString.")
    }

    func testBoolExtensions() {
        XCTAssertEqual(true.toInt, 1)
        XCTAssertEqual(false.toInt, 0)
    }

    func testRequestExtensions() {
        var options = SylvesterCommon.SKCodeCompletionSessionOptions()
        options.filterText = "filterText"

        let fileWithPath = File(pathDeferringReading: "/a/path")
        let offset = 10
        let compilerArguments = ["compiler", "arguments"]

        let codeCompletionRequest = Request.codeCompletion(file: fileWithPath,
                                                           offset: offset,
                                                           compilerArguments: compilerArguments)
        let openRequest = Request.codeCompletionOpen(file: fileWithPath,
                                                     offset: offset,
                                                     options: options,
                                                     compilerArguments: compilerArguments)

        options.filterText = "differentFilterText"
        let updateRequest = Request.codeCompletionUpdate(name: fileWithPath.name,
                                                         offset: offset,
                                                         options: options)
        let closeRequest = Request.codeCompletionClose(name: fileWithPath.name, offset: offset)

        SylvesterAssertEqual(codeCompletionRequest.description,
                             expected: """
                                       {
                                         key.request: source.request.codecomplete,
                                         key.name: "/a/path",
                                         key.compilerargs: [
                                           "-c",
                                           "/a/path",
                                           "compiler",
                                           "arguments"
                                         ],
                                         key.offset: 10,
                                         key.sourcefile: "/a/path",
                                         key.toolchains: [
                                           "com.apple.dt.toolchain.XcodeDefault"
                                         ]
                                       }
                                       """)

        SylvesterAssertEqual(openRequest.description,
                             expected: """
                                       {
                                         key.request: source.request.codecomplete.open,
                                         key.name: "/a/path",
                                         key.compilerargs: [
                                           "-c",
                                           "/a/path",
                                           "compiler",
                                           "arguments"
                                         ],
                                         key.offset: 10,
                                         key.sourcefile: "/a/path",
                                         key.codecomplete.options: {
                                           key.codecomplete.addinitstotoplevel: 0,
                                           key.codecomplete.addinneroperators: 1,
                                           key.codecomplete.addinnerresults: 0,
                                           key.codecomplete.callpatternheuristics: 1,
                                           key.codecomplete.filtertext: "filterText",
                                           key.codecomplete.fuzzymatching: 1,
                                           key.codecomplete.group.overloads: 0,
                                           key.codecomplete.group.stems: 0,
                                           key.codecomplete.hidebyname: 1,
                                           key.codecomplete.hidelowpriority: 1,
                                           key.codecomplete.hideunderscores: 1,
                                           key.codecomplete.includeexactmatch: 1,
                                           key.codecomplete.showtopnonliteralresults: 3,
                                           key.codecomplete.sort.byname: 0,
                                           key.codecomplete.sort.contextweight: 15,
                                           key.codecomplete.sort.fuzzyweight: 10,
                                           key.codecomplete.sort.popularitybonus: 2,
                                           key.codecomplete.sort.useimportdepth: 1
                                         },
                                         key.toolchains: [
                                           "com.apple.dt.toolchain.XcodeDefault"
                                         ]
                                       }
                                       """)

        SylvesterAssertEqual(updateRequest.description,
                             expected: """
                                       {
                                         key.request: source.request.codecomplete.update,
                                         key.name: "/a/path",
                                         key.offset: 10,
                                         key.codecomplete.options: {
                                           key.codecomplete.addinitstotoplevel: 0,
                                           key.codecomplete.addinneroperators: 1,
                                           key.codecomplete.addinnerresults: 0,
                                           key.codecomplete.callpatternheuristics: 1,
                                           key.codecomplete.filtertext: "differentFilterText",
                                           key.codecomplete.fuzzymatching: 1,
                                           key.codecomplete.group.overloads: 0,
                                           key.codecomplete.group.stems: 0,
                                           key.codecomplete.hidebyname: 1,
                                           key.codecomplete.hidelowpriority: 1,
                                           key.codecomplete.hideunderscores: 1,
                                           key.codecomplete.includeexactmatch: 1,
                                           key.codecomplete.showtopnonliteralresults: 3,
                                           key.codecomplete.sort.byname: 0,
                                           key.codecomplete.sort.contextweight: 15,
                                           key.codecomplete.sort.fuzzyweight: 10,
                                           key.codecomplete.sort.popularitybonus: 2,
                                           key.codecomplete.sort.useimportdepth: 1
                                         }
                                       }
                                       """)

        SylvesterAssertEqual(closeRequest.description,
                             expected: """
                                       {
                                         key.request: source.request.codecomplete.close,
                                         key.name: "/a/path",
                                         key.offset: 10
                                       }
                                       """)
    }

    func testSwiftDocsEncodable() throws {
        let file = viewControllerFile

        guard let swiftDocs = SwiftDocs(file: file,
                                        arguments: testModule.compilerArguments)
            else { return XCTFail("failed to create `SwiftDocs` object") }

        guard let expectedData = try? JSONSerialization.data(withJSONObject: swiftDocs.docsDictionary)
            else { return XCTFail("failed to serialize `docsDictionary`") }

        guard let expectedResponse = try? JSONDecoder().decode(SKBaseResponse.self, from: expectedData)
            else { return XCTFail("failed to decode expected response") }

        let encodedSwiftDocs = try JSONEncoder().encode(swiftDocs)
        let decodedSwiftDocs = try JSONDecoder().decode(SKSwiftDocs.self, from: encodedSwiftDocs)

        XCTAssertEqual(decodedSwiftDocs.file.contents, file.contents)
        XCTAssertEqual(decodedSwiftDocs.offset, expectedResponse.offset)
        XCTAssertEqual(decodedSwiftDocs.length, expectedResponse.length)
        XCTAssertEqual(decodedSwiftDocs.topLevelSubstructures.count,
                       expectedResponse.topLevelSubstructures.count)
        XCTAssertEqual(decodedSwiftDocs.syntaxMap, expectedResponse.syntaxMap)
    }

    func testModuleCodable() throws {
        let encodedModule = try JSONEncoder().encode(testModule)
        let decodedModule = try JSONDecoder().decode(Module.self, from: encodedModule)

        XCTAssertEqual(decodedModule, testModule)
    }

    func testFileCodable() throws {
        let fileWithPath = File(pathDeferringReading: "/a/path")
        let encodedFileWithPathData = try JSONEncoder().encode(fileWithPath)
        let decodedFileWithPath = try JSONDecoder().decode(File.self, from: encodedFileWithPathData)

        XCTAssertEqual(fileWithPath.path, decodedFileWithPath.path)

        let fileWithContents = File(contents: "This has some contents.")
        let encodedFileWithContentsData = try JSONEncoder().encode(fileWithContents)
        let decodedFileWithContents = try JSONDecoder().decode(File.self, from: encodedFileWithContentsData)

        XCTAssertEqual(fileWithContents.contents, decodedFileWithContents.contents)
    }

}
