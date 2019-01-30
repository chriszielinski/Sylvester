//
//  SKErrorTests.swift
//  Sylvester Tests 😼
//
//  Created by Chris Zielinski on 12/22/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

import SylvesterCommon
import SourceKittenFramework
import XCTest

class SKErrorTests: SylvesterSecureCodingTestCase {

    // MARK: - Stored Properties

    let failMessage: String = "incorrect `SKError` case"

    // MARK: - Overridden Test Case Methods

    override func setUp() {
        continueAfterFailure = false
    }

    // MARK: - Test Methods

    func testSKErrorAndSKXPCErrorConversion() {
        let errorDescription = "Failed"
        let requestError = Request.Error.failed(errorDescription)
        let skError = SKError.sourceKitRequestFailed(requestError)

        let skXPCError = skError.toSKXPCError()
        switch skXPCError.toSKError() {
        case .sourceKitRequestFailed(let request):
            guard case .failed(let description?) = request
                else { fallthrough }
            XCTAssertEqual(description, errorDescription)
        default: XCTFail(failMessage)
        }

        switch skXPCError.toSKXPCError().toSKError() {
        case .sourceKitRequestFailed(let request):
            guard case .failed(let description?) = request
                else { fallthrough }
            XCTAssertEqual(description, errorDescription)
        default: XCTFail(failMessage)
        }

        switch skError.toSKError() {
        case .sourceKitRequestFailed(let request):
            guard case .failed(let description?) = request
                else { fallthrough }
            XCTAssertEqual(description, errorDescription)
        default: XCTFail(failMessage)
        }

        let cocoaError = CocoaError(CocoaError.Code.coderValueNotFound,
                                    userInfo: [NSLocalizedDescriptionKey: "This is a description."])
        let cocoaErrorDescription = (cocoaError as NSError).description

        switch cocoaError.toSKError() {
        case .unknown(let description):
            XCTAssertEqual(description, cocoaErrorDescription)
        default: XCTFail(failMessage)
        }

        switch cocoaError.toSKXPCError().toSKError() {
        case .unknown(let description):
            XCTAssertEqual(description, cocoaErrorDescription)
        default: XCTFail(failMessage)
        }
    }

    func testSKXPCErrorRequestErrorConnectionInterruptedBridge() {
        let connectionInterruptedError = Request.Error.connectionInterrupted("Test string")
        let connectionInterruptedXPCError = SKXPCError.sourceKitRequestFailed(connectionInterruptedError)
        let decodedConnectionInterruptedError: SKXPCError = AssertSecureCoding(connectionInterruptedXPCError)
        switch decodedConnectionInterruptedError.bridge {
        case .sourceKitRequestFailed(let error):
            guard case .connectionInterrupted(let string) = error
                else { fallthrough }
            XCTAssertEqual(connectionInterruptedError.description, string)
        default: XCTFail(failMessage)
        }
    }

    func testSKXPCErrorRequestErrorInvalidBridge() {
        let invalidError = Request.Error.invalid("Test string")
        let invalidXPCError = SKXPCError.sourceKitRequestFailed(invalidError)
        let decodedInvalidError: SKXPCError = AssertSecureCoding(invalidXPCError)
        switch decodedInvalidError.bridge {
        case .sourceKitRequestFailed(let error):
            guard case .invalid(let string) = error
                else { fallthrough }
            XCTAssertEqual(invalidError.description, string)
        default: XCTFail(failMessage)
        }
    }

    func testSKXPCErrorRequestErrorFailedBridge() {
        let failedError = Request.Error.failed("Test string")
        let failedXPCError = SKXPCError.sourceKitRequestFailed(failedError)
        let decodedFailedError: SKXPCError = AssertSecureCoding(failedXPCError)
        switch decodedFailedError.bridge {
        case .sourceKitRequestFailed(let error):
            guard case .failed(let string) = error
                else { fallthrough }
            XCTAssertEqual(failedError.description, string)
        default: XCTFail(failMessage)
        }
    }

    func testSKXPCErrorRequestErrorCancelledBridge() {
        let cancelledError = Request.Error.cancelled("Test string")
        let cancelledXPCError = SKXPCError.sourceKitRequestFailed(cancelledError)
        let decodedCancelledError: SKXPCError = AssertSecureCoding(cancelledXPCError)
        switch decodedCancelledError.bridge {
        case .sourceKitRequestFailed(let error):
            guard case .cancelled(let string) = error
                else { fallthrough }
            XCTAssertEqual(cancelledError.description, string)
        default: XCTFail(failMessage)
        }
    }

    func testSKXPCErrorRequestErrorUnknownBridge() {
        let unknownRequestError = Request.Error.unknown("Test string")
        let unknownXPCError = SKXPCError.sourceKitRequestFailed(unknownRequestError)
        let decodedUnknownXPCError: SKXPCError = AssertSecureCoding(unknownXPCError)
        switch decodedUnknownXPCError.bridge {
        case .sourceKitRequestFailed(let error):
            guard case .unknown(let string) = error
                else { fallthrough }
            XCTAssertEqual(unknownRequestError.description, string)
        default: XCTFail(failMessage)
        }
    }

    func testSKXPCErrorJSONDecodingFailedBridge() {
        let decodingErrorContext = DecodingError.Context(codingPath: [], debugDescription: "This is a description.")
        let decodingError = DecodingError.typeMismatch(String.self, decodingErrorContext)
        let decodingErrorDescription = (decodingError as NSError).description
        let jsonDecodingFailedError = SKXPCError.jsonDecodingFailed(decodingError)
        let decodedJSONDecodingFailedError: SKXPCError = AssertSecureCoding(jsonDecodingFailedError)
        switch decodedJSONDecodingFailedError.bridge {
        case .jsonDecodingFailed(let string):
            XCTAssertEqual(string, decodingErrorDescription)
        default: XCTFail(failMessage)
        }

        let decodingSKError = SKError.jsonDecodingFailed(error: decodingError)
        switch decodingSKError {
        case .jsonDecodingFailed(let description):
            XCTAssertEqual(description, decodingErrorDescription)
        default: XCTFail(failMessage)
        }
    }

    func testSKXPCErrorJSONEncodingFailedBridge() {
        let encodingErrorContext = EncodingError.Context(codingPath: [], debugDescription: "This is a description.")
        let encodingError = EncodingError.invalidValue(1, encodingErrorContext)
        let encodingErrorDescription = (encodingError as NSError).description
        let jsonEncodingFailedError = SKXPCError.jsonEncodingFailed(encodingError)
        let encodedJSONDecodingFailedError: SKXPCError = AssertSecureCoding(jsonEncodingFailedError)
        switch encodedJSONDecodingFailedError.bridge {
        case .jsonEncodingFailed(let string):
            XCTAssertEqual(string, encodingErrorDescription)
        default: XCTFail(failMessage)
        }

        let encodingSKError = SKError.jsonEncodingFailed(error: encodingError)
        switch encodingSKError {
        case .jsonEncodingFailed(let description):
            XCTAssertEqual(description, encodingErrorDescription)
        default: XCTFail(failMessage)
        }
    }

    func testSKXPCErrorJSONDataEncodingFailedBridge() {
        let jsonDataEncodingFailedError = SKXPCError.jsonDataEncodingFailed()
        let decodedJSONDataEncodingFailedError: SKXPCError = AssertSecureCoding(jsonDataEncodingFailedError)
        switch decodedJSONDataEncodingFailedError.bridge {
        case .jsonDataEncodingFailed: ()
        default: XCTFail(failMessage)
        }
    }

    #if XPC
    func testSKXPCErrorSourceKittenCrashedBridge() {
        let sourceKittenCrashedError = SKXPCError.sourceKittenCrashed()
        let decodedSourceKittenCrashedError: SKXPCError = AssertSecureCoding(sourceKittenCrashedError)
        switch decodedSourceKittenCrashedError.bridge {
        case .sourceKittenCrashed: ()
        default: XCTFail(failMessage)
        }
    }
    #endif

    func testSKXPCErrorUnknownBridge() throws {
        let errorDescription = "This is a description."
        let cocoaError = CocoaError(CocoaError.Code.coderValueNotFound,
                                    userInfo: [NSLocalizedDescriptionKey: errorDescription])
        let cocoaErrorDescription = (cocoaError as NSError).description
        let unknownError = SKXPCError.unknown(cocoaError)
        let decodedUnknownError: SKXPCError = AssertSecureCoding(unknownError)
        switch decodedUnknownError.bridge {
        case .unknown(let string):
            XCTAssertEqual(string, cocoaErrorDescription)
        default: XCTFail(failMessage)
        }

        let unknownSKError = SKError.unknown(error: cocoaError)
        switch unknownSKError {
        case .unknown(let description):
            XCTAssertEqual(description, cocoaErrorDescription)
        default: XCTFail(failMessage)
        }
    }

}
