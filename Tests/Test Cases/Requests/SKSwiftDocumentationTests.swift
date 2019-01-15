//
//  SKSwiftDocumentationTests.swift
//  Sylvester Tests 😼
//
//  Created by Chris Zielinski on 12/3/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

import XCTest
import SourceKittenFramework
#if XPC
@testable import SylvesterXPC
#else
@testable import Sylvester
#endif

class SKSwiftDocumentationTests: SylvesterTestCase {

    // MARK: - Test Methods

    func testInitializers() throws {
        let viewControllerFilePath = filePath(for: .viewController)
        let file = File(pathDeferringReading: viewControllerFilePath)
        let module = SKSwiftDocumentationTests.testModule

        XCTAssertNoThrow(try SKSwiftDocs(file: file, compilerArguments: module.compilerArguments),
                         "`init(file:compilerArguments:)` failed.")
        XCTAssertNoThrow(try SKSwiftDocs(filePath: viewControllerFilePath,
                                                  compilerArguments: module.compilerArguments),
                         "`init(filePath:compilerArguments:)` failed.")

        guard let skModule = try? SKModule(xcodeBuildArguments: [], inPath: SylvesterTestCase.testProjectDirectoryPath)
            else { return XCTFail("failed to create `SKModule`") }

        XCTAssertNoThrow(try SKSwiftDocs(filePath: viewControllerFilePath, module: skModule),
                         "`init(filePath:module:)` failed.")
        XCTAssertNoThrow(try SKSwiftDocs(file: file, module: skModule),
                         "`init(file:module:)` failed.")
    }

    func testViewController() throws {
        let swiftDocumentationResponse = try sendSwiftDocumentationRequest(for: .viewController)
        try SylvesterAssert(swiftDocumentationResponse,
                            equalsTestFixture: .viewControllerSwiftDocsMustache,
                            filePath: filePath(for: .viewController))
    }

    func testPlaceholders() throws {
        let swiftDocumentationResponse = try sendSwiftDocumentationRequest(for: .placeholders)
        try SylvesterAssert(swiftDocumentationResponse,
                            equalsTestFixture: .placeholdersSwiftDocsMustache,
                            filePath: filePath(for: .placeholders))
    }

    func testDocSupportInputsMain() throws {
        let swiftDocumentationResponse = try sendSwiftDocumentationRequest(for: .docSupportInputsMain)
        try SylvesterAssert(swiftDocumentationResponse,
                            equalsTestFixture: .docSupportInputsMainSwiftDocsMustache,
                            filePath: filePath(for: .docSupportInputsMain))
    }

    // MARK: - Test Helper Methods

    func sendSwiftDocumentationRequest(for sourceFile: SourceFile) throws -> SKSwiftDocs {
        return try SKSwiftDocs(filePath: filePath(for: sourceFile),
                               compilerArguments: testModuleCompilerArguments)
    }

}
