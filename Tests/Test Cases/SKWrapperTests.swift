//
//  SKWrapperTests.swift
//  Sylvester Tests 😼
//
//  Created by Chris Zielinski on 12/22/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

import SourceKittenFramework
import SylvesterCommon
import XCTest

class SKWrapperTests: SylvesterSecureCodingTests {

    // MARK: - Test Methods

    func testSKFileWrapper() throws {
        continueAfterFailure = false

        let file = File(pathDeferringReading: "/a/path")
        let fileWrapper = SKFileWrapper(file: file)
        let decodedFileWrapper: SKFileWrapper = AssertSecureCoding(fileWrapper)

        XCTAssertEqual(file.path, decodedFileWrapper.file.path)
    }

    func testSKDataWrapper() throws {
        continueAfterFailure = false

        // swiftlint:disable:next nesting
        struct MockCodableStruct: Codable, Equatable {
            let string: String
        }

        let testObject = MockCodableStruct(string: "This is a test string.")
        let dataWrapper = try SKDataWrapper(object: testObject)
        let decodedDataWrapper: SKDataWrapper = AssertSecureCoding(dataWrapper)

        let decodedTestObject: MockCodableStruct = try decodedDataWrapper.decodeData()

        XCTAssertEqual(decodedTestObject, testObject)

        XCTAssertThrowsError(try decodedDataWrapper.xpcDecodeData() as String,
                             "No error thrown when decoding as invalid type.") { (error) in
                                XCTAssertTrue(error is SKXPCError)

                                // swiftlint:disable:next force_cast
                                switch (error as! SKXPCError).bridge {
                                case .jsonDecodingFailed(let errorDescription):
                                    XCTAssertNotNil(errorDescription)
                                default:
                                    XCTFail("Incorrect error thrown.")
                                }
        }
        XCTAssertThrowsError(try decodedDataWrapper.decodeData() as String,
                             "No error thrown when decoding as invalid type.") { (error) in
                                XCTAssertTrue(error is SKError)

                                // swiftlint:disable:next force_cast
                                switch error as! SKError {
                                case .jsonDecodingFailed(let errorDescription):
                                    XCTAssertNotNil(errorDescription)
                                default:
                                    XCTFail("Incorrect error thrown.")
                                }
        }

        let requestResponse = try Request.editorOpen(file: viewControllerFile).send()
        let responseDataWrapper = try SKDataWrapper(requestResponse)
        let decodedResponse: SKDataWrapper = AssertSecureCoding(responseDataWrapper)

        XCTAssertEqual(responseDataWrapper.data, decodedResponse.data)

        let testArray = ["Test", "Array"]
        let sourceKitRepresentableDataWrapper = try SKDataWrapper(testArray)
        let decodedSourceKitRepresentableDataWrapper = AssertSecureCoding(sourceKitRepresentableDataWrapper)

        XCTAssertEqual(testArray, try decodedSourceKitRepresentableDataWrapper.decodeData() as [String])
    }

    func testSKSyntaxMapWrapper() throws {
        continueAfterFailure = false

        let syntaxMap = SyntaxMap(tokens: [SyntaxToken(type: "type", offset: 10, length: 100)])
        let syntaxMapWrapper = SKSyntaxMapWrapper(syntaxMap: syntaxMap)
        let decodedSyntaxMapWrapper: SKSyntaxMapWrapper = AssertSecureCoding(syntaxMapWrapper)

        XCTAssertGreaterThan(syntaxMap.tokens.count, 0)
        XCTAssertEqual(syntaxMap, decodedSyntaxMapWrapper.syntaxMap)
    }

    func testSKModuleWrapper() throws {
        continueAfterFailure = false

        let moduleWrapper = try SKModuleWrapper(module: testModule)
        XCTAssertEqual(try moduleWrapper.module(), testModule)
    }

}
