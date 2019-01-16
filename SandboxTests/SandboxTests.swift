//
//  SandboxTests.swift
//  SandboxTests
//
//  Created by Chris Zielinski on 12/22/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

import XCTest
import SourceKittenFramework
import Sandbox

class SandboxTests: XCTestCase {

    // MARK: - Static Stored Properties

    static var testFixturesURL: URL = {
        return URL(fileURLWithPath: ProcessInfo.processInfo.environment["TEST_FIXTURES_PATH"]!, isDirectory: true)
    }()
    static var testProjectDirectoryPath: String = {
        return testFixturesURL.appendingPathComponent("Test Project").path
    }()
    static var testModuleSDKPath: String?
    static var testModuleTarget: String?

    // MARK: - Stored Properties

    let expectationTimeOut: TimeInterval = 30
    let testContentsOffset = 25
    let testContents = """
                       import UIKit

                       var view = UIVi
                       """

    let missingCompilerArgumentsMessage: String = "missing compiler arguments"

    // MARK: - Computed Properties

    var testCompilerArguments: [String]? {
        guard let sdkPath = SandboxTests.testModuleSDKPath, let target = SandboxTests.testModuleTarget
            else { return nil }
        return ["-sdk", sdkPath, "-target", target]
    }
    var testContentsFile: File {
        return File(contents: testContents)
    }

    // MARK: - Test Methods

    func test1SKModule() throws {
        let module = try SylvesterInterface.skModule(in: SandboxTests.testProjectDirectoryPath)

        SandboxTests.testModuleSDKPath = module.sdkPath
        SandboxTests.testModuleTarget = module.target

        let docs = module.docs
        XCTAssertGreaterThan(docs.count, 0)
    }

    func testSKEditorOpen() throws {
        let editorOpen = try SylvesterInterface.editorOpen(file: testContentsFile)

        XCTAssertGreaterThan(editorOpen.length, 0)
        XCTAssertGreaterThan(editorOpen.topLevelSubstructures.count, 0)
        XCTAssertNotNil(editorOpen.syntaxMap)
    }

    func testCustomEditorOpen() throws {
        let customEditorOpen = try SylvesterInterface.customEditorOpen(file: testContentsFile)

        XCTAssertTrue(customEditorOpen.overriddenResolveCalled)
    }

    func testSKSyntaxMap() throws {
        let syntaxMap = try SylvesterInterface.syntaxMap(file: testContentsFile)

        XCTAssertGreaterThan(syntaxMap.tokens.count, 0)
    }

    func testSKSwiftDocs() throws {
        guard let compilerArguments = testCompilerArguments
            else { return XCTFail(missingCompilerArgumentsMessage) }

        let swiftDocs = try SylvesterInterface.swiftDocs(file: testContentsFile,
                                                         compilerArguments: compilerArguments)

        XCTAssertGreaterThan(swiftDocs.length, 0)
        XCTAssertGreaterThan(swiftDocs.topLevelSubstructures.count, 0)
    }

    func testCustomSwiftDocs() throws {
        continueAfterFailure = false

        guard let compilerArguments = testCompilerArguments
            else { return XCTFail(missingCompilerArgumentsMessage) }

        let customSwiftDocs = try SylvesterInterface.customSwiftDocs(file: testContentsFile,
                                                                     compilerArguments: compilerArguments)

        XCTAssertTrue(customSwiftDocs.overriddenResolveCalled)
        XCTAssertNotNil(customSwiftDocs.topLevelSubstructures.first)
        XCTAssertTrue(customSwiftDocs.topLevelSubstructures.first!.iAmASubclass)
    }

    func testSKCodeCompletion() throws {
        guard let compilerArguments = testCompilerArguments
            else { return XCTFail(missingCompilerArgumentsMessage) }

        let codeCompletion = try SylvesterInterface.codeCompletion(file: testContentsFile,
                                                                   offset: testContentsOffset,
                                                                   compilerArguments: compilerArguments)

        XCTAssertGreaterThan(codeCompletion.items.count, 0)
    }

    func testSKCodeCompletionSession() throws {
        continueAfterFailure = false

        guard let compilerArguments = testCompilerArguments
            else { return XCTFail(missingCompilerArgumentsMessage) }

        let session = SylvesterInterface.codeCompletionSession(file: testContentsFile,
                                                               offset: testContentsOffset,
                                                               compilerArguments: compilerArguments)

        XCTAssertNotNil(session.options)

        let openExpectation = expectation(description: "session `open()` completes")

        session.completionHandler = { (_, response) in
            XCTAssertNotNil(response.codeCompletion)
            XCTAssertGreaterThan(response.codeCompletion!.items.count, 0)
            openExpectation.fulfill()
        }
        session.open()

        waitForExpectations(timeout: expectationTimeOut)

        session.options!.filterText = "UIVi"

        let updateExpectation = expectation(description: "session `update()` completes")

        session.completionHandler = { (_, response) in
            XCTAssertNotNil(response.codeCompletion)
            XCTAssertGreaterThan(response.codeCompletion!.items.count, 0)
            XCTAssertEqual(response.codeCompletion!.items.first?.name, "UIView")
            updateExpectation.fulfill()
        }
        session.update()

        waitForExpectations(timeout: expectationTimeOut)
    }

    func testXCRun() {
        continueAfterFailure = false

        let output = SylvesterInterface.xcRun(arguments: ["-f", "swift"])

        XCTAssertNotNil(output)
        XCTAssertTrue(output!.hasSuffix("/usr/bin/swift"))
    }

    func testXcodeBuild() {
        continueAfterFailure = false

        let output = SylvesterInterface.xcodeBuild(arguments: ["-list", "-project", "Test.xcodeproj"],
                                                   currentDirectoryPath: SandboxTests.testProjectDirectoryPath)

        XCTAssertNotNil(output)
        XCTAssertTrue(output!.hasSuffix("Test"))
    }

    func testExecuteBash() {
        let echoString = "nice"
        continueAfterFailure = false

        let output = SylvesterInterface.executeBash(command: "echo '\(echoString)'")

        XCTAssertNotNil(output)
        XCTAssertEqual(output, echoString)
    }

    func testExecuteShell() {
        continueAfterFailure = false

        let output = SylvesterInterface.executeSubprocess(launchPath: "/usr/bin/swift",
                                                          arguments: ["-version"],
                                                          shouldPipeStandardError: true)

        XCTAssertNotNil(output)
        XCTAssertTrue(output!.hasPrefix("Apple Swift version"))
    }

}
