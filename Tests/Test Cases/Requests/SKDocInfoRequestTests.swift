//
//  SKDocInfoRequestTests.swift
//  Sylvester Tests 😼
//
//  Created by Chris Zielinski on 1/28/19.
//  Copyright © 2019 Big Z Labs. All rights reserved.
//

import XCTest
import SourceKittenFramework
#if XPC
@testable import SylvesterXPC
#else
@testable import Sylvester
#endif

class SKDocInfoRequestTests: SylvesterTestCase {

    // MARK: - Test Declarations

    class MethodIterator<Entity: CustomEntity>: SKPreOrderDFSIterator<Entity> {

        override func next() -> Entity? {
            guard let nextSubstructure = super.next()
                else { return nil }
            if nextSubstructure.kind == .functionMethodInstance {
                return nextSubstructure
            } else {
                return next()
            }
        }

    }

    final class CustomEntity: SKBaseEntity, SKFinalSubclass {

        override class func iteratorClass<Entity: CustomEntity>() -> SKPreOrderDFSIterator<Entity>.Type {
                return MethodIterator.self
        }

        override func decodeChildren(from container: SKBaseEntity.DecodingContainer) throws -> [SKBaseEntity]? {
            return try decodeChildren(CustomEntity.self, from: container)
        }

    }

    class CustomDocInfo: SKGenericDocInfo<CustomEntity> {}

    // MARK: - Static Stored Properties

    static let testSourceContents = """
                                    import UIKit

                                    open class View: UIView {
                                       let property: String = "Property"
                                    }
                                    """

    // MARK: - Stored Properties

    let missingCompilerArgumentsMessage = "the test module's SDK path or target is nil"

    // MARK: - Test Methods

    func testSourceContentsDocInfoRequest() throws {
        let file = File(contents: SKDocInfoRequestTests.testSourceContents)

        continueAfterFailure = false

        guard let sdkPath = testModule.sdkPath, let target = testModule.target
            else { return XCTFail(missingCompilerArgumentsMessage) }

        let response = try SKDocInfo(file: file, sdkPath: sdkPath, target: target)

        XCTAssertNil(response.sourceText)
        XCTAssertGreaterThan(response.annotations.count, 0)
        XCTAssertNotNil(response.topLevelEntities)
        XCTAssertGreaterThan(response.topLevelEntities!.count, 0)
        XCTAssertNil(response.diagnostics)

        let classEntity = response.topLevelEntities!.first!
        let propertyEntity = classEntity.children?.first
        XCTAssertEqual(classEntity, classEntity)
        XCTAssertTrue(classEntity == classEntity)
        XCTAssertNotEqual(classEntity, propertyEntity)
        XCTAssertTrue(classEntity != propertyEntity)
    }

    /// - Warning: This test method may take a long time.
    func testModuleDocInfoRequest() throws {
        continueAfterFailure = false

        guard let sdkPath = testModule.sdkPath, let target = testModule.target
            else { return XCTFail(missingCompilerArgumentsMessage) }

        let response = try SKDocInfo(moduleName: "Foundation", sdkPath: sdkPath, target: target)

        XCTAssertNotNil(response.sourceText)
        XCTAssertGreaterThan(response.annotations.count, 0)
        XCTAssertNotNil(response.topLevelEntities)
        XCTAssertGreaterThan(response.topLevelEntities!.count, 0)
        XCTAssertNil(response.diagnostics)
    }

    func testAppDelegateDocInfoRequest() throws {
        continueAfterFailure = false

        guard let sdkPath = testModule.sdkPath, let target = testModule.target
            else { return XCTFail(missingCompilerArgumentsMessage) }

        let path = filePath(for: .appDelegate)
        let file = File(pathDeferringReading: path)
        let response = try SKDocInfo(file: file, sdkPath: sdkPath, target: target)

        try SylvesterAssert(response, equalsTestFixture: .appDelegateDocInfoMustache, filePath: path)
    }

    func testViewControllerDocInfoRequest() throws {
        continueAfterFailure = false

        guard let sdkPath = testModule.sdkPath, let target = testModule.target
            else { return XCTFail(missingCompilerArgumentsMessage) }

        let path = filePath(for: .viewController)
        let file = File(pathDeferringReading: path)
        let response = try CustomDocInfo(file: file, sdkPath: sdkPath, target: target)

        try SylvesterAssert(response, equalsTestFixture: .viewControllerDocInfoMustache, filePath: path)
    }

    func testViewControllerCustomDocInfoRequest() throws {
        continueAfterFailure = false

        guard let sdkPath = testModule.sdkPath, let target = testModule.target
            else { return XCTFail(missingCompilerArgumentsMessage) }

        let path = filePath(for: .viewController)
        let file = File(pathDeferringReading: path)
        let response = try CustomDocInfo(file: file, sdkPath: sdkPath, target: target)

        XCTAssertNotNil(response.topLevelEntities)

        var count = 0
        let classEntity = response.topLevelEntities!.first
        for entity in response.topLevelEntities! {
            XCTAssertTrue(type(of: entity) == CustomEntity.self)
            XCTAssertEqual(entity.parent, classEntity)
            count += 1
        }

        XCTAssertEqual(count, 2)
        try SylvesterAssert(response, equalsTestFixture: .viewControllerDocInfoMustache, filePath: path)

        XCTAssertNotEqual(classEntity?.parent, classEntity)
        classEntity?.parent = classEntity
        XCTAssertEqual(classEntity?.parent, classEntity)

        XCTAssertNotNil(classEntity?.children)
        classEntity?.children = nil
        XCTAssertNil(classEntity?.children)

        let byteRange = classEntity?.byteRange
        XCTAssertNotNil(byteRange)
        XCTAssertEqual(byteRange!.location, classEntity?.offset)
        XCTAssertEqual(byteRange!.length, classEntity?.length)
    }

    func testPlaceholdersDocInfoRequest() throws {
        continueAfterFailure = false

        guard let sdkPath = testModule.sdkPath, let target = testModule.target
            else { return XCTFail(missingCompilerArgumentsMessage) }

        let path = filePath(for: .placeholders)
        let file = File(pathDeferringReading: path)
        let response = try SKDocInfo(file: file, sdkPath: sdkPath, target: target)

        try SylvesterAssert(response, equalsTestFixture: .placeholdersDocInfoMustache, filePath: path)
    }

    func testAProtocolDocInfoRequest() throws {
        continueAfterFailure = false

        guard let sdkPath = testModule.sdkPath, let target = testModule.target
            else { return XCTFail(missingCompilerArgumentsMessage) }

        let path = filePath(for: .aProtocol)
        let file = File(pathDeferringReading: path)
        let response = try SKDocInfo(file: file, sdkPath: sdkPath, target: target)

        try SylvesterAssert(response, equalsTestFixture: .aProtocolDocInfoMustache, filePath: path)
    }

    func testDocSupportInputsMainDocInfoRequest() throws {
        continueAfterFailure = false

        guard let sdkPath = testModule.sdkPath, let target = testModule.target
            else { return XCTFail(missingCompilerArgumentsMessage) }

        let path = filePath(for: .docSupportInputsMain)
        let file = File(pathDeferringReading: path)
        let response = try SKDocInfo(file: file, sdkPath: sdkPath, target: target)

        try SylvesterAssert(response, equalsTestFixture: .docSupportInputsMainDocInfoMustache, filePath: path)
    }

}
