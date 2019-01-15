//
//  SKSyntaxMapTests.swift
//  Sylvester Tests 😼
//
//  Created by Chris Zielinski on 12/4/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

import XCTest
import SourceKittenFramework
import SylvesterCommon
#if XPC
@testable import SylvesterXPC
#else
@testable import Sylvester
#endif

class SKSyntaxMapTests: SylvesterTestCase {

    // MARK: - Test Methods

    func testInitializers() throws {
        continueAfterFailure = false

        let viewControllerFilePath = filePath(for: .viewController)
        XCTAssertNoThrow(try SKSyntaxMap(file: File(pathDeferringReading: viewControllerFilePath)),
                         "`init(file:)` failed.")
        XCTAssertNoThrow(try SKSyntaxMap(filePath: viewControllerFilePath),
                         "`init(filePath:)` failed.")
        XCTAssertThrowsError(try SKSyntaxMap(filePath: SylvesterTestCase.testProjectDirectoryPath), "") { (error) in
            XCTAssertTrue(error is SKError)
            switch error as? SKError {
            case .sourceKitRequestFailed(let requestError)?:
                XCTAssertNotNil(requestError)
            default:
                XCTFail("Incorrect `SKError` was thrown.")
            }
        }
    }

    func testViewController() throws {
        let syntaxMap = try SKSyntaxMap(filePath: filePath(for: .viewController))
        try SylvesterAssert(syntaxMap, equalsTestFixture: .viewControllerSyntaxMapJSON)

        for token in syntaxMap.tokens {
            XCTAssertNotNil(token.kind)
        }
    }

    func testPlaceholders() throws {
        let syntaxMap = try SKSyntaxMap(filePath: filePath(for: .placeholders))
        try SylvesterAssert(syntaxMap, equalsTestFixture: .placeholdersSyntaxMapJSON)

        for token in syntaxMap.tokens {
            XCTAssertNotNil(token.kind)
        }
    }

    func testDocSupportInputsMain() throws {
        let syntaxMap = try SKSyntaxMap(filePath: filePath(for: .docSupportInputsMain))
        try SylvesterAssert(syntaxMap, equalsTestFixture: .docSupportInputsMainSyntaxMapJSON)

        for token in syntaxMap.tokens {
            XCTAssertNotNil(token.kind)
        }
    }

    func testEquatable() throws {
        let viewControllerTestFixture: SKSyntaxMap = try decodeJSONTestFixture(name: .viewControllerSyntaxMapJSON)
        let viewControllerTestFixtureCopy: SKSyntaxMap = try decodeJSONTestFixture(name: .viewControllerSyntaxMapJSON)
        let placeholdersTestFixture: SKSyntaxMap = try decodeJSONTestFixture(name: .placeholdersSyntaxMapJSON)

        XCTAssertEqual(viewControllerTestFixture, viewControllerTestFixtureCopy)
        XCTAssertNotEqual(viewControllerTestFixture, placeholdersTestFixture)
    }

}
