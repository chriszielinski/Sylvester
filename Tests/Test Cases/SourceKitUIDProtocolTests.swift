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
        XCTAssertEqual(SKDiagnosticStage.parse.description,
                       "source.diagnostic.stage.swift.parse")
        XCTAssertEqual(SKAccessLevel.internal.description,
                       "source.lang.swift.accessibility.internal")
        XCTAssertEqual(SKDeclarationKind.class.description,
                       "source.lang.swift.decl.class")
        XCTAssertEqual(SKCodeCompletionContext.thisclass.description,
                       "source.codecompletion.context.thisclass")
    }

}
