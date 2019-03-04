//
//  SKCursorInfoTests.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 2/16/19.
//  Copyright © 2019 Big Z Labs. All rights reserved.
//

import XCTest
import SourceKittenFramework
import SylvesterCommon
#if XPC
@testable import SylvesterXPC
#else
@testable import Sylvester
#endif

class SKCursorInfoTests: SylvesterTestCase {

    // MARK: - Test Methods

    func testViewController() throws {
        let viewControllerFilePath = filePath(for: .viewController)
        let file = File(pathDeferringReading: viewControllerFilePath)

        let cursorInfo = try SKCursorInfo(file: file,
                                          offset: 293,
                                          compilerArguments: testModuleCompilerArguments,
                                          cancelOnSubsequentRequest: false)

        try SylvesterAssert(cursorInfo,
                            equalsTestFixture: .viewControllerCursorInfoMustache,
                            filePath: viewControllerFilePath)
    }

    func testAnnotatedDeclarationEquatable() {
        let testAnnotatedDeclaration = SKAnnotatedDeclaration(annotatedDeclaration: "test")
        let anotherTestAnnotatedDeclaration = SKAnnotatedDeclaration(annotatedDeclaration: "test")
        let differentAnnotatedDeclaration = SKAnnotatedDeclaration(annotatedDeclaration: "test-different")

        XCTAssertEqual(testAnnotatedDeclaration, anotherTestAnnotatedDeclaration)
        XCTAssertNotEqual(testAnnotatedDeclaration, differentAnnotatedDeclaration)
    }

}
