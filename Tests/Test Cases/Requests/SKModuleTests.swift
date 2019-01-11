//
//  SKModuleTests.swift
//  Sylvester Tests 😼
//
//  Created by Chris Zielinski on 12/12/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

import XCTest
#if XPC
@testable import SylvesterXPC
#else
@testable import Sylvester
#endif

class SKModuleTests: SylvesterTestCase {

    // MARK: - Test Methods

    func testSKModule() throws {
        continueAfterFailure = false

        let module = try SKModule(xcodeBuildArguments: [],
                                  inPath: SylvesterTestCase.testProjectDirectoryPath)

        XCTAssertEqual(module.name, testModule.name)
        XCTAssertEqual(module.compilerArguments, testModule.compilerArguments)
        XCTAssertEqual(module.sourceFiles, testModule.sourceFiles)

        let docs = module.docs
        XCTAssertEqual(docs.count, 4)

        XCTAssertNotNil(module.sdkPath)
        XCTAssertNotNil(module.target)
    }

}
