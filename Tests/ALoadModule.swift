//
//  ALoadModule.swift
//  Sylvester Tests 😼
//
//  Created by Chris Zielinski on 12/4/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

import XCTest
#if XPC
@testable import SylvesterXPC
#else
@testable import Sylvester
#endif

/// Prefixed with 'A' in order to be the first test suite executed.
class ALoadModule: SylvesterTestCase {

    // MARK: - Test Methods

    /// Loads the module used for the tests.
    ///
    /// - Important: This test method should be executed ~first.
    func testLoadModule() {
        ALoadModule.loadModule()
    }

    func testIsTravisBuild() {
        print("IsTravisBuild=\(SylvesterTestCase.isTravisBuild)")
        #if TRAVIS
        XCTAssertTrue(SylvesterTestCase.isTravisBuild)
        #else
        XCTAssertFalse(SylvesterTestCase.isTravisBuild)
        #endif
    }

    // MARK: - Helper Methods

    /// Generates and writes the _SourceKit_ request test fixtures to 'Tests/Fixtures/'.
    ///
    /// This method should only be manually invoked to update the test fixtures when necessary.
    func testGenerateRequestFixtures() throws {
        // The test case is disabled, so should never be invoked, but you never know...
        guard !SylvesterTestCase.isTravisBuild
            else { return }

        let appDelegateFilePath = filePath(for: .appDelegate)
        let viewControllerFilePath = filePath(for: .viewController)
        let placeholdersFilePath = filePath(for: .placeholders)
        let aProtocolFilePath = filePath(for: .aProtocol)

        writeJSONFixture(for: try SKEditorOpen(filePath: appDelegateFilePath),
                         name: .appDelegateEditorOpenMustache)
        writeJSONFixture(for: try SKEditorOpen(filePath: viewControllerFilePath),
                         name: .viewControllerEditorOpenMustache)
        writeJSONFixture(for: try SKEditorOpen(filePath: placeholdersFilePath),
                         name: .placeholdersEditorOpenMustache)
        writeJSONFixture(for: try SKEditorOpen(filePath: aProtocolFilePath),
                         name: .aProtocolEditorOpenMustache)

        writeJSONFixture(for: try SKSwiftDocs(filePath: appDelegateFilePath,
                                              compilerArguments: testModule.compilerArguments),
                         name: .appDelegateSwiftDocumentationMustache)
        writeJSONFixture(for: try SKSwiftDocs(filePath: viewControllerFilePath,
                                              compilerArguments: testModule.compilerArguments),
                         name: .viewControllerSwiftDocumentationMustache)
        writeJSONFixture(for: try SKSwiftDocs(filePath: placeholdersFilePath,
                                              compilerArguments: testModule.compilerArguments),
                         name: .placeholdersSwiftDocumentationMustache)

        writeJSONFixture(for: try SKSyntaxMap(filePath: viewControllerFilePath),
                         name: .viewControllerSyntaxMapJSON)
        writeJSONFixture(for: try SKSyntaxMap(filePath: placeholdersFilePath),
                         name: .placeholdersSyntaxMapJSON)
    }
}
