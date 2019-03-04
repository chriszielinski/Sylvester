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
import SourceKittenFramework

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
        guard !SylvesterTestCase.isTravisBuild,
            let sdkPath = testModule.sdkPath,
            let target = testModule.target
            else { return }

        let appDelegateFilePath = filePath(for: .appDelegate)
        let viewControllerFilePath = filePath(for: .viewController)
        let placeholdersFilePath = filePath(for: .placeholders)
        let aProtocolFilePath = filePath(for: .aProtocol)
        let docSupportInputsMainFilePath = filePath(for: .docSupportInputsMain)

        let appDelegateFile = File(pathDeferringReading: appDelegateFilePath)
        let viewControllerFile = File(pathDeferringReading: viewControllerFilePath)
        let placeholdersFile = File(pathDeferringReading: placeholdersFilePath)
        let aProtocolFile = File(pathDeferringReading: aProtocolFilePath)
        let docSupportInputsMainFile = File(pathDeferringReading: docSupportInputsMainFilePath)

        writeJSONFixture(for: try SKEditorOpen(filePath: appDelegateFilePath),
                         name: .appDelegateEditorOpenMustache)
        writeJSONFixture(for: try SKEditorOpen(filePath: viewControllerFilePath),
                         name: .viewControllerEditorOpenMustache)
        writeJSONFixture(for: try SKEditorOpen(filePath: placeholdersFilePath),
                         name: .placeholdersEditorOpenMustache)
        writeJSONFixture(for: try SKEditorOpen(filePath: aProtocolFilePath),
                         name: .aProtocolEditorOpenMustache)
        writeJSONFixture(for: try SKEditorOpen(filePath: docSupportInputsMainFilePath),
                         name: .docSupportInputsMainEditorOpenMustache)

        writeJSONFixture(for: try SKSwiftDocs(filePath: appDelegateFilePath,
                                              compilerArguments: testModuleCompilerArguments),
                         name: .appDelegateSwiftDocsMustache)
        writeJSONFixture(for: try SKSwiftDocs(filePath: viewControllerFilePath,
                                              compilerArguments: testModuleCompilerArguments),
                         name: .viewControllerSwiftDocsMustache)
        writeJSONFixture(for: try SKSwiftDocs(filePath: placeholdersFilePath,
                                              compilerArguments: testModuleCompilerArguments),
                         name: .placeholdersSwiftDocsMustache)
        writeJSONFixture(for: try SKSwiftDocs(filePath: docSupportInputsMainFilePath,
                                              compilerArguments: testModuleCompilerArguments),
                         name: .docSupportInputsMainSwiftDocsMustache)

        writeJSONFixture(for: try SKSyntaxMap(filePath: viewControllerFilePath),
                         name: .viewControllerSyntaxMapJSON)
        writeJSONFixture(for: try SKSyntaxMap(filePath: placeholdersFilePath),
                         name: .placeholdersSyntaxMapJSON)
        writeJSONFixture(for: try SKSyntaxMap(filePath: docSupportInputsMainFilePath),
                         name: .docSupportInputsMainSyntaxMapJSON)

        writeJSONFixture(for: try SKDocInfo(file: appDelegateFile, sdkPath: sdkPath, target: target),
                         name: .appDelegateDocInfoMustache)
        writeJSONFixture(for: try SKDocInfo(file: viewControllerFile, sdkPath: sdkPath, target: target),
                         name: .viewControllerDocInfoMustache)
        writeJSONFixture(for: try SKDocInfo(file: placeholdersFile, sdkPath: sdkPath, target: target),
                         name: .placeholdersDocInfoMustache)
        writeJSONFixture(for: try SKDocInfo(file: aProtocolFile, sdkPath: sdkPath, target: target),
                         name: .aProtocolDocInfoMustache)
        writeJSONFixture(for: try SKDocInfo(file: docSupportInputsMainFile, sdkPath: sdkPath, target: target),
                         name: .docSupportInputsMainDocInfoMustache)

        writeJSONFixture(for: try SKCursorInfo(file: viewControllerFile,
                                               offset: 293,
                                               compilerArguments: testModuleCompilerArguments),
                         name: .viewControllerCursorInfoMustache)
    }
}
