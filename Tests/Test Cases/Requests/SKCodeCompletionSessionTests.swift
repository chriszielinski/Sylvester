//
//  SKCodeCompletionSessionTests.swift
//  Sylvester Tests 😼
//
//  Created by Chris Zielinski on 12/4/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

import XCTest
import SourceKittenFramework
#if XPC
@testable import SylvesterXPC
#else
@testable import Sylvester
#endif

class SKCodeCompletionSessionTests: SylvesterTestCase {

    // MARK: - Static Stored Properties

    static let alphabet: [String] = { "abcdefghijklmnopqrstuvwxyz".map { String($0) } }()

    // MARK: - Stored Properties

    let filterTextStrings = ["will", "did", "view", "UIV", "text"]
    let testOffset: Offset = 514

    let testContentsOffset: Offset = 25
    let testContents: String = """
                               import UIKit

                               var view = UIVi
                               """

    // MARK: - Test Methods

    func testCodeCompletionOptionsSourceKitObjectConvertible() {
        continueAfterFailure = false
        var codeCompletionOptions = SKCodeCompletionSession.Options()

        let defaultSourceKitdObject = codeCompletionOptions.sourcekitdObject
        XCTAssertNotNil(defaultSourceKitdObject,
                        "`sourcekitdObject` returns nil for default options.")

        SylvesterAssertEqual(SourceKitObject(defaultSourceKitdObject!).description,
                             expected: """
                                       {
                                         key.codecomplete.addinitstotoplevel: 0,
                                         key.codecomplete.addinneroperators: 1,
                                         key.codecomplete.addinnerresults: 0,
                                         key.codecomplete.callpatternheuristics: 1,
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
                                       """)

        codeCompletionOptions.filterText = "filterText"
        codeCompletionOptions.requestStart = 1
        codeCompletionOptions.requestLimit = 100

        let sourceKitdObject = codeCompletionOptions.sourcekitdObject
        XCTAssertNotNil(sourceKitdObject,
                        "`sourcekitdObject` returns nil for options with `filterText`, `requestStart`, `requestLimit`.")

        SylvesterAssertEqual(SourceKitObject(sourceKitdObject!).description,
                             expected: """
                                       {
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
                                         key.codecomplete.requestlimit: 100,
                                         key.codecomplete.requeststart: 1,
                                         key.codecomplete.showtopnonliteralresults: 3,
                                         key.codecomplete.sort.byname: 0,
                                         key.codecomplete.sort.contextweight: 15,
                                         key.codecomplete.sort.fuzzyweight: 10,
                                         key.codecomplete.sort.popularitybonus: 2,
                                         key.codecomplete.sort.useimportdepth: 1
                                       }
                                       """)
    }

    func sessionErrorHandler(session: SKCodeCompletionSession,
                             response: SKCodeCompletionSession.Response,
                             error: SKError) {
        XCTFail(error.localizedDescription)
    }

    func testSingleCompilerArgumentsSession() {
        let compilerArgumentsSession = SKCodeCompletionSession(filePath: filePath(for: .viewController),
                                                               offset: testOffset,
                                                               compilerArguments: testModuleCompilerArguments)
        AssertOpenCloseSession(compilerArgumentsSession)
    }

    func testSingleSDKPathTargetSession() {
        guard let sdkPath = testModule.sdkPath
            else { return XCTFail("No '-sdk' value in the module compiler arguments.") }

        guard let target = testModule.target
            else { return XCTFail("No '-target' value in the module compiler arguments.") }

        let sdkPathTargetSession = SKCodeCompletionSession(filePath: filePath(for: .viewController),
                                                           offset: testOffset,
                                                           sdkPath: sdkPath,
                                                           target: target)
        AssertOpenCloseSession(sdkPathTargetSession)
    }

    func testSingleFileContentsSession() {
        continueAfterFailure = false

        guard let sdkPath = testModule.sdkPath
            else { return XCTFail("No '-sdk' value in the module compiler arguments.") }

        guard let target = testModule.target
            else { return XCTFail("No '-target' value in the module compiler arguments.") }

        let sdkPathTargetSession = SKCodeCompletionSession(contents: testContents,
                                                           offset: testContentsOffset,
                                                           sdkPath: sdkPath,
                                                           target: target)
        AssertOpenCloseSession(sdkPathTargetSession, filterText: "UIVi", expectedFirstItem: "UIView")

        let compilerArgumentsSession = SKCodeCompletionSession(contents: testContents,
                                                               offset: testContentsOffset,
                                                               compilerArguments: ["-sdk", sdkPath, "-target", target])
        AssertOpenCloseSession(compilerArgumentsSession, filterText: "UIVi", expectedFirstItem: "UIView")
    }

    func testCloseSessionOnDeinitialization() {
        continueAfterFailure = false

        let path = filePath(for: .viewController)
        let offset = 523
        let compilerArguments = testModuleCompilerArguments

        func errorHandler(request: SKCodeCompletionSession,
                          response: SKCodeCompletionSession.Response,
                          error: SKError) {
            print(error)
            XCTFail(error.errorDescription ?? "Encountered an unknown error.")
        }

        let firstExpectation = expectation(description: "first request completes")

        var codeCompletionResult: SKCodeCompletionSession?
        codeCompletionResult = SKCodeCompletionSession(filePath: path,
                                                       offset: offset,
                                                       compilerArguments: compilerArguments)
        codeCompletionResult!.errorHandler = errorHandler
        codeCompletionResult!.completionHandler = { (_, _) in
            firstExpectation.fulfill()
        }
        codeCompletionResult!.open()

        waitForExpectations(timeout: expectationTimeOut)

        let secondExpectation = expectation(description: "second request completes")

        // Deinitializes the previous code session, which should also close the session.
        codeCompletionResult = SKCodeCompletionSession(filePath: path,
                                                       offset: offset,
                                                       compilerArguments: compilerArguments)
        codeCompletionResult!.errorHandler = errorHandler
        codeCompletionResult!.completionHandler = { (_, _) in
            secondExpectation.fulfill()
        }
        codeCompletionResult!.open()

        waitForExpectations(timeout: expectationTimeOut)
    }

    func testOpenSessionTwice() {
        let expectation = self.expectation(description: "session `open()` completes")

        let session = SKCodeCompletionSession(filePath: filePath(for: .viewController),
                                              offset: testOffset,
                                              compilerArguments: testModuleCompilerArguments)
        session.completionHandler = { (_, response) in
            XCTAssertNotNil(response.codeCompletion)
            XCTAssertGreaterThan(response.codeCompletion!.items.count, 0)
            expectation.fulfill()
        }

        session.open()

        XCTAssertTrue(session.isActive)
        XCTAssertEqual(session.queueRequestCount, 1)

        waitForExpectations(timeout: expectationTimeOut)

        XCTAssertFalse(session.isActive)

        session.open()

        XCTAssertFalse(session.isActive)
        XCTAssertEqual(session.queueRequestCount, 0)
    }

    func testCancelOnSubsequentRequest() {
        continueAfterFailure = false

        let path = filePath(for: .viewController)
        let expectation = self.expectation(description: "only the last session `update()` calls the completion handler")

        let session = SKCodeCompletionSession(filePath: path,
                                              offset: testOffset,
                                              compilerArguments: testModuleCompilerArguments)
        session.cancelOnSubsequentRequest = true
        session.errorHandler = sessionErrorHandler
        session.completionHandler = { (session, response) in
            XCTAssertNotNil(response.options)
            XCTAssertNotNil(response.codeCompletion)
            XCTAssertEqual(response.kind, .update)
            XCTAssertEqual(response.options!.filterText, self.filterTextStrings.last)
            expectation.fulfill()
        }
        session.options?.filterText = filterTextStrings.first

        session.open()

        for index in 1..<filterTextStrings.count {
            session.options?.filterText = filterTextStrings[index]
            session.update()
        }

        XCTAssertGreaterThan(session.queueRequestCount, 1)

        waitForExpectations(timeout: expectationTimeOut)

        XCTAssertEqual(session.queueRequestCount, 0)
    }

    func testOpenTwoSessionsWithSameOffset() {
        let path = filePath(for: .viewController)
        let offset = 523
        let compilerArguments = testModuleCompilerArguments

        let expectation = self.expectation(description: "opening two sessions with the same offset throws an error")

        func errorHandler(request: SKCodeCompletionSession,
                          response: SKCodeCompletionSession.Response,
                          error: SKError) {
            expectation.fulfill()

            switch error {
            case .sourceKitRequestFailed(let requestError):
                guard case .failed(_) = requestError
                    else { fallthrough }
            default: XCTFail("Unexpected error was thrown.")
            }
        }

        let firstSession = SKCodeCompletionSession(filePath: path,
                                                   offset: offset,
                                                   compilerArguments: compilerArguments)
        let secondSession = SKCodeCompletionSession(filePath: path,
                                                    offset: offset,
                                                    compilerArguments: compilerArguments)

        firstSession.errorHandler = errorHandler
        secondSession.errorHandler = errorHandler

        firstSession.open()
        secondSession.open()

        waitForExpectations(timeout: expectationTimeOut)
    }

    func testOpenTwoDifferentSessions() {
        continueAfterFailure = false

        let expectation = self.expectation(description: "can open two different sessions")
        expectation.expectedFulfillmentCount = 2

        func completionHandler(request: SKCodeCompletionSession, response: SKCodeCompletionSession.Response) {
            XCTAssertNotNil(response.codeCompletion)
            XCTAssertGreaterThan(response.codeCompletion!.items.count, 0)
            expectation.fulfill()
        }

        let firstRequest = createMockRequest(filterText: filterTextStrings.first!)
        let secondRequest = createMockRequest(filterText: filterTextStrings.first!, offset: 718)

        firstRequest.completionHandler = completionHandler
        secondRequest.completionHandler = completionHandler

        firstRequest.open()
        secondRequest.open()

        waitForExpectations(timeout: expectationTimeOut)
    }

    func testSessionUpdate() {
        continueAfterFailure = false

        let offset = 514
        let path = filePath(for: .viewController)
        let filterStrings = SKCodeCompletionSessionTests.alphabet
        let updateRequestCount = filterStrings.count

        let firstExpectation = expectation(description: "Session open completes.")

        let session = SKCodeCompletionSession(filePath: path,
                                              offset: offset,
                                              compilerArguments: testModuleCompilerArguments)
        session.completionHandler = { (request, response) in
            XCTAssertNotNil(response.codeCompletion)
            XCTAssertGreaterThan(response.codeCompletion!.items.count, 0)
            firstExpectation.fulfill()
        }
        session.open()

        waitForExpectations(timeout: expectationTimeOut)

        let secondExpectation = expectation(description: "\(updateRequestCount) session updates complete.")
        secondExpectation.expectedFulfillmentCount = updateRequestCount

        var responseIndex = 0
        session.completionHandler = { (request, response) in
            XCTAssertEqual(request.latestResponse, response)
            XCTAssertNotNil(response.codeCompletion)
            XCTAssertGreaterThan(response.codeCompletion!.items.count, 0)
            XCTAssertEqual(response.options?.filterText, filterStrings[responseIndex])
            responseIndex += 1
            secondExpectation.fulfill()
        }

        for filterText in filterStrings {
            session.options?.filterText = filterText
            session.update()
        }

        waitForExpectations(timeout: expectationTimeOut)
    }

    func testRequestLimit() throws {
        var codeCompletionOptions = SKCodeCompletionSession.Options()
        codeCompletionOptions.requestLimit = 100

        let codeCompletionResults = try AssertCodeCompletionSession(with: codeCompletionOptions)

        XCTAssert(!codeCompletionResults.items.isEmpty,
                  "Code completion request with request limit returned no items.")
        XCTAssert(codeCompletionResults.items.count == 100,
                  """
                  Code completion request with request limit returned incorrect number of items.
                  Expected 100, returned \(codeCompletionResults.items.count).
                  """)
        XCTAssertEqual(codeCompletionResults.nextRequestStart, 100,
                       "Code completion has incorrect `nextRequestStart`.")
    }

    func testRequestStart() throws {
        var codeCompletionOptions = SKCodeCompletionSession.Options()
        codeCompletionOptions.requestLimit = 5

        let codeCompletionResults = try AssertCodeCompletionSession(with: codeCompletionOptions)

        codeCompletionOptions.requestStart = 1
        codeCompletionOptions.requestLimit = 4
        let codeCompletionResultsWithStart = try AssertCodeCompletionSession(with: codeCompletionOptions)

        XCTAssertEqual(Array(codeCompletionResults.items.dropFirst()), codeCompletionResultsWithStart.items)
    }

    func testFilterFuzzyMatching() throws {
        let filterText = "viewDid"
        var codeCompletionOptions = SKCodeCompletionSession.Options()
        codeCompletionOptions.filterText = filterText

        let codeCompletionResults = try AssertCodeCompletionSession(with: codeCompletionOptions)

        let resultsIncludeFuzzyItem = codeCompletionResults.items.contains(where: { !$0.name.contains(filterText) })
        let resultsIncludeNonFuzzyItem = codeCompletionResults.items.contains(where: { $0.name.contains(filterText) })
        XCTAssert(resultsIncludeFuzzyItem && resultsIncludeNonFuzzyItem,
                  "Code completion request with fuzzy matching and filter \"\(filterText)\" does not "
                    + "return fuzzy and non-fuzzy items.")
    }

    func testFilterNoFuzzyMatching() throws {
        let filterText = "viewDid"
        var codeCompletionOptions = SKCodeCompletionSession.Options()
        codeCompletionOptions.fuzzyMatching = false
        codeCompletionOptions.filterText = filterText

        let codeCompletionResults = try AssertCodeCompletionSession(with: codeCompletionOptions)

        for item in codeCompletionResults.items {
            XCTAssert(item.name.contains(filterText),
                      "Code completion request with no fuzzy matching and filter \"\(filterText)\""
                        + " returned fuzzy match \"\(item.name)\"")
        }
    }

    func testHideLowPriority() throws {
        var codeCompletionOptions = SKCodeCompletionSession.Options()

        let codeCompletionResults = try AssertCodeCompletionSession(with: codeCompletionOptions)

        codeCompletionOptions.hideLowPriority = false
        let codeCompletionWithLowPriorityResults = try AssertCodeCompletionSession(with: codeCompletionOptions)

        XCTAssert(codeCompletionResults.items != codeCompletionWithLowPriorityResults.items,
                  "Code completion request with low Priority does not return more items.")
    }

    // MARK: - Test Helper Methods

    func createMockRequest(filterText: String? = nil, offset: Offset = 514) -> SKCodeCompletionSession {
        let session = SKCodeCompletionSession(filePath: filePath(for: .viewController),
                                              offset: offset,
                                              compilerArguments: SKCodeCompletionTests.testModule.compilerArguments)
        session.options!.filterText = filterText
        return session
    }

    // MARK: - Test Assertion Methods

    // swiftlint:disable:next identifier_name
    func AssertCodeCompletionSession(with options: SKCodeCompletionSession.Options) throws -> SKCodeCompletion {
        continueAfterFailure = false
        let sourceFilePath = filePath(for: .viewController)

        let session = SKCodeCompletionSession(filePath: sourceFilePath,
                                              offset: 514,
                                              compilerArguments: testModuleCompilerArguments)
        session.options = options

        let expectation = self.expectation(description: "code completion session `open()` completes")
        var codeCompletionResponse: SKCodeCompletion?
        var responseError: SKError?

        session.completionHandler = { (_, response) in
            XCTAssertEqual(response.kind, .open)
            XCTAssertEqual(response.options, options)
            XCTAssertNotNil(response.codeCompletion)
            codeCompletionResponse = response.codeCompletion

            expectation.fulfill()
        }
        session.errorHandler = { (_, _, error) in
            self.print(error)
            responseError = error

            expectation.fulfill()
        }

        session.open()
        waitForExpectations(timeout: expectationTimeOut)

        if let error = responseError {
            throw error
        }

        return codeCompletionResponse!
    }

    // swiftlint:disable:next identifier_name
    func AssertOpenCloseSession(_ session: SKCodeCompletionSession,
                                filterText: String? = nil,
                                expectedFirstItem: String? = nil) {
        let openExpectation = expectation(description: "session `open()` completes")

        XCTAssertNotNil(session.options)

        session.options?.filterText = filterText
        session.errorHandler = sessionErrorHandler
        session.completionHandler = { (session, response) in
            XCTAssertNotNil(response.options)
            XCTAssertNotNil(response.codeCompletion)
            XCTAssertGreaterThan(response.codeCompletion!.items.count, 0)

            if let expectedFirstItem = expectedFirstItem {
                XCTAssertEqual(response.codeCompletion!.items.first?.name, expectedFirstItem)
            }

            openExpectation.fulfill()
        }

        session.open()

        XCTAssertTrue(session.isActive)
        XCTAssertEqual(session.queueRequestCount, 1)

        waitForExpectations(timeout: expectationTimeOut)

        XCTAssertEqual(session.queueRequestCount, 0)
        XCTAssertFalse(session.isActive)
        XCTAssertTrue(session.isOpen)

        let closeExpectation = expectation(description: "session `close()` completes")

        session.completionHandler = { (session, response) in
            XCTAssertEqual(response.kind, .close)
            XCTAssertNil(response.options)
            XCTAssertNil(response.codeCompletion)

            closeExpectation.fulfill()
        }

        session.close()

        XCTAssertTrue(session.isActive)
        XCTAssertEqual(session.queueRequestCount, 1)

        waitForExpectations(timeout: expectationTimeOut)

        XCTAssertEqual(session.queueRequestCount, 0)
        XCTAssertFalse(session.isActive)
        XCTAssertTrue(session.isClosed)
    }

}
