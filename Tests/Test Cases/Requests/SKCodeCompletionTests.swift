//
//  SKCodeCompletionTests.swift
//  Sylvester Tests 😼
//
//  Created by Chris Zielinski on 11/30/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

import XCTest
import SourceKittenFramework
#if XPC
@testable import SylvesterXPC
#else
@testable import Sylvester
#endif

class SKCodeCompletionTests: SylvesterTestCase {

    // MARK: - Test Methods

    func testCodeCompletion() throws {
        let path = filePath(for: .viewController)
        let offset: Offset = 523
        let compilerArguments = testModuleCompilerArguments

        let firstCodeCompletion = try SKCodeCompletion(filePath: path,
                                                       offset: offset,
                                                       compilerArguments: compilerArguments)
        XCTAssertGreaterThan(firstCodeCompletion.items.count, 0)

        let firstCodeCompletionItem = firstCodeCompletion.items[0]
        XCTAssert(firstCodeCompletionItem.name == "#colorLiteral(red:green:blue:alpha:)",
                  "First code completion item name is not `#colorLiteral(red:green:blue:alpha:)`.")
        XCTAssert(firstCodeCompletionItem.context == .none,
                  "First code completion item context is not `.none`.")
        XCTAssert(firstCodeCompletionItem.kind == .literalColor,
                  "First code completion item kind is not `.keyword`.")

        guard let sdkPath = testModule.sdkPath
            else { return XCTFail("No '-sdk' value in the module compiler arguments.") }

        let secondCodeCompletion = try SKCodeCompletion(filePath: path,
                                                        offset: offset,
                                                        sdkPath: sdkPath,
                                                        target: testModule.target)
        XCTAssertGreaterThan(secondCodeCompletion.items.count, 0)
    }

    func testFileContentsCodeCompletion() throws {
        let offset: Offset = 25
        let contents = """
                       import UIKit

                       var view = UIVi
                       """

        guard let sdkPath = testModule.sdkPath
            else { return XCTFail("No '-sdk' value in the module compiler arguments.") }

        let firstCodeCompletion = try SKCodeCompletion(contents: contents,
                                                       offset: offset,
                                                       sdkPath: sdkPath,
                                                       target: testModule.target)
        XCTAssertGreaterThan(firstCodeCompletion.items.count, 0)

        guard let target = testModule.target
            else { return XCTFail("No '-target' value in the module compiler arguments.") }

        let secondCodeCompletion = try SKCodeCompletion(contents: contents,
                                                        offset: offset,
                                                        compilerArguments: ["-sdk", sdkPath, "-target", target])
        XCTAssertGreaterThan(secondCodeCompletion.items.count, 0)
    }

    func testMultipleAsynchronousCodeCompletionRequests() throws {
        let requestCount = 3
        let expectation = self.expectation(description: "Can send \(requestCount) asynchronous "
            + "code completion requests.")
        expectation.expectedFulfillmentCount = requestCount

        let path = filePath(for: .viewController)
        let offset = 523
        let compilerArguments = testModuleCompilerArguments

        for _ in (0..<requestCount) {
            DispatchQueue.global().async {
                do {
                    let codeCompletionResult = try SKCodeCompletion(filePath: path,
                                                                    offset: offset,
                                                                    compilerArguments: compilerArguments)
                    if !codeCompletionResult.items.isEmpty {
                        expectation.fulfill()
                    }
                } catch {
                    self.print(error)
                }
            }
        }

        waitForExpectations(timeout: expectationTimeOut)
    }

}
