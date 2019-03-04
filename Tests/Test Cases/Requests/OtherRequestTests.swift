//
//  OtherRequestTests.swift
//  Sylvester Tests 😼
//
//  Created by Chris Zielinski on 12/21/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

import XCTest
#if XPC
@testable import SylvesterXPC
#else
@testable import Sylvester
#endif

class OtherRequestTests: XCTestCase {

    // MARK: - Test Methods

    func testEditorExtractTextFromComment() throws {
        let sourceText = """
                          /// Partially applies a binary operator.
                          ///
                          /// - Parameters:
                          ///   - a: The left-hand side to partially apply.
                          ///   - combine: A binary operator.
                          ///     - Parameters:
                          ///       - lhs: The left-hand side of the operator
                          ///       - rhs: The right-hand side of the operator
                          ///     - Returns: A result.
                          ///     - Throws: Nothing.
                          """
        let expectedResponseText = """
                                   Partially applies a binary operator.

                                   - Parameters:
                                     - a: The left-hand side to partially apply.
                                     - combine: A binary operator.
                                       - Parameters:
                                         - lhs: The left-hand side of the operator
                                         - rhs: The right-hand side of the operator
                                       - Returns: A result.
                                       - Throws: Nothing.

                                   """

        let extractedComment = try SKEditorExtractTextFromComment(sourceText)
        XCTAssertEqual(extractedComment.sourceText, expectedResponseText)

        let differentExtractedComment = try SKEditorExtractTextFromComment("// Different")
        XCTAssertNotEqual(extractedComment, differentExtractedComment)
    }

    func testEditorExtractTextFromMultilineComment() throws {
        let sourceText = """
                         /**
                           Brief.

                           This is not a code block.
                         */
                         """
        let expectedResponseText = """
                                   Brief.

                                   This is not a code block.

                                   """

        let extractedComment = try SKEditorExtractTextFromComment(sourceText)
        XCTAssertEqual(extractedComment.sourceText, expectedResponseText)
    }

    func testMarkupToXML() throws {
        let sourceText = """
                         Brief.

                         _This_ is not a `code` block.
                         """
        // swiftlint:disable:next line_length
        let expectedResponseText = "<Abstract><Para>Brief.</Para></Abstract><Discussion><Para><emphasis>This</emphasis> is not a <codeVoice>code</codeVoice> block.</Para></Discussion>"

        let markupXML = try SKConvertMarkupToXML(markup: sourceText)
        XCTAssertEqual(markupXML.sourceText, expectedResponseText)
    }

    func testXCRun() {
        continueAfterFailure = false

        let output = SylvesterInterface.shared.xcRun(arguments: ["-f", "swift"])

        XCTAssertNotNil(output)
        XCTAssertTrue(output!.hasSuffix("/usr/bin/swift"))
    }

    func testXcodeBuild() {
        continueAfterFailure = false

        let currentDirectoryURL = URL(fileURLWithPath: SylvesterTestCase.testProjectDirectoryPath)
        let output = SylvesterInterface.shared.xcodeBuild(arguments: ["-list", "-project", "Test.xcodeproj"],
                                                          currentDirectoryURL: currentDirectoryURL)

        XCTAssertNotNil(output)
        XCTAssertTrue(output!.hasSuffix("Test"))
    }

    func testExecuteBash() {
        let echoString = "nice"
        continueAfterFailure = false

        let output = SylvesterInterface.shared.executeBash(command: "echo '\(echoString)'")

        XCTAssertNotNil(output)
        XCTAssertEqual(output, echoString)
    }

    func testLaunchSubprocess() throws {
        continueAfterFailure = false

        var subprocess = SKSubprocess(executableURL: URL(fileURLWithPath: "/usr/bin/swift"))
        subprocess.arguments = ["-version"]
        subprocess.shouldPipeStandardError = true
        let output = try SylvesterInterface.shared.launch(subprocess: subprocess)

        XCTAssertNotNil(output)
        XCTAssertTrue(output!.hasPrefix("Apple Swift version"))
    }

}
