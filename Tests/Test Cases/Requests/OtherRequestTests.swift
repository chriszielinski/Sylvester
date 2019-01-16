//
//  OtherRequestTests.swift
//  Sylvester Tests 😼
//
//  Created by Chris Zielinski on 12/21/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

import XCTest
#if XPC
@testable import SylvesterXPC
#else
@testable import Sylvester
#endif

class OtherRequestTests: XCTestCase {

    // MARK: - Test Methods

    func testXCRun() {
        continueAfterFailure = false

        let output = SourceKittenInterface.shared.xcRun(arguments: ["-f", "swift"])

        XCTAssertNotNil(output)
        XCTAssertTrue(output!.hasSuffix("/usr/bin/swift"))
    }

    func testXcodeBuild() {
        continueAfterFailure = false

        let path = SylvesterTestCase.testProjectDirectoryPath
        let output = SourceKittenInterface.shared.xcodeBuild(arguments: ["-list", "-project", "Test.xcodeproj"],
                                                             currentDirectoryPath: path)

        XCTAssertNotNil(output)
        XCTAssertTrue(output!.hasSuffix("Test"))
    }

    func testExecuteBash() {
        let echoString = "nice"
        continueAfterFailure = false

        let output = SourceKittenInterface.shared.executeBash(command: "echo '\(echoString)'")

        XCTAssertNotNil(output)
        XCTAssertEqual(output, echoString)
    }

    func testLaunchSubprocess() {
        continueAfterFailure = false

        let output = SourceKittenInterface.shared.launchSubprocess(launchPath: "/usr/bin/swift",
                                                                   arguments: ["-version"],
                                                                   shouldPipeStandardError: true)

        XCTAssertNotNil(output)
        XCTAssertTrue(output!.hasPrefix("Apple Swift version"))
    }

}
