//
//  SKYAMLRequestTests.swift
//  Sylvester Tests 😼
//
//  Created by Chris Zielinski on 12/10/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

import XCTest
import SylvesterCommon
#if XPC
@testable import SylvesterXPC
#else
@testable import Sylvester
#endif

class SKYAMLRequestTests: SylvesterTestCase {

    // MARK: - Test Methods

    #if XPC
    /// - Important: Ensure this test is run last; otherwise, the behavior of the next XPC test will be undefined.
    func testXPCCrash() {
        continueAfterFailure = false

        let yamlCrashRequest = """
                               key.request: source.request.editor.open
                               key.name: "name"
                               key.sourcefile: "
                               """

        XCTAssertThrowsError(try SKYAMLRequest<SKBaseResponse>(yaml: yamlCrashRequest),
                             "XPC unexpected crashed.") { (error) in
                                switch error as? SKError {
                                case .sourceKittenCrashed?: ()
                                default:
                                    XCTFail("Error thrown is not `SKError.sourceKittenCrashed`.")
                                }
        }
    }
    #endif

    func testCustomYAMLRequest() throws {
        let viewControllerFilePath = filePath(for: .viewController)
        let yaml = """
                   key.request: source.request.editor.open
                   key.name: "\(viewControllerFilePath)"
                   key.sourcefile: "\(viewControllerFilePath)"
                   """

        let response = try SKYAMLRequest<SKBaseResponse>(yaml: yaml)
        response.response.resolve(from: viewControllerFilePath)
        try SylvesterAssert(response.response,
                            equalsTestFixture: .viewControllerEditorOpenMustache,
                            filePath: viewControllerFilePath)
    }

}
