//
//  GeneratedEnumerationTests.swift
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

class SourceKitUIDProtocolTests: XCTestCase {

    // MARK: - Test Methods

    func testDescription() {
        XCTAssertEqual(SKDiagnosticStage.parse.description, "parse")
        XCTAssertEqual(SKAccessLevel.internal.description, "internal")
        XCTAssertEqual(SKKind.class.description, "class")
        XCTAssertEqual(SKCodeCompletionContext.thisclass.description, "thisclass")
    }

}
