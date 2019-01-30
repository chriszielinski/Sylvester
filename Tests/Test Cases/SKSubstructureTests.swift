//
//  SKSubstructureTests.swift
//  Sylvester Tests 😼
//
//  Created by Chris Zielinski on 12/5/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

import XCTest
#if XPC
@testable import SylvesterXPC
#else
@testable import Sylvester
#endif

import SourceKittenFramework

class SKSubstructureTests: SylvesterMockEditorOpenTestCase {

    // MARK: - Test Methods

    func testEquatable() {
        let viewControllerSubstructure = viewControllerClassSubstructure
        let aProtocolSubstructure = aProtocolProtocolSubstructure

        XCTAssertFalse(viewControllerSubstructure == aProtocolSubstructure)
        XCTAssertFalse(viewControllerSubstructure === aProtocolSubstructure)
        XCTAssertTrue(viewControllerSubstructure == viewControllerSubstructure)
        XCTAssertTrue(viewControllerSubstructure === viewControllerSubstructure)

        guard let encodedSubstructure = try? JSONEncoder().encode(viewControllerSubstructure)
            else { return XCTFail("failed to encode `SKSubstructure`") }
        guard let decodedSubstructure = try? JSONDecoder().decode(SKSubstructure.self,
                                                                  from: encodedSubstructure)
            else { return XCTFail("failed to decode `SKSubstructure`") }

        XCTAssertEqual(decodedSubstructure, viewControllerSubstructure)
    }

    func testAppDelegateElements() {
        guard let elements = appDelegateClassSubstructure.elements
            else { return XCTFail("AppDelegate substructure has no `elements`.") }

        XCTAssertEqual(elements.count, 2,
                       "`SKSortedEntities` `count` property is incorrect.")
        XCTAssertEqual(elements.first, elements.entities.first,
                       "`SKSortedEntities` `first` property is incorrect.")
        XCTAssertEqual(elements.last, elements.entities.last,
                       "`SKSortedEntities` `last` property is incorrect.")

        var lastElementOffset: Offset = 0
        for element in elements {
            XCTAssertLessThan(lastElementOffset, element.offset)
            lastElementOffset = element.offset
        }
    }

    func testAppDelegateSubstructure() {
        let funcSubstructure = appDelegateClassSubstructure.children!.last!

        XCTAssertTrue(funcSubstructure.isFunction,
                      "`isFunction` returns incorrect value.")
        XCTAssertFalse(funcSubstructure.isReturningFunction,
                       "`isReturningFunction` returns incorrect value.")
        XCTAssertNil(funcSubstructure.functionReturnType,
                     "`functionReturnType` returns non-nil value.")
    }

    func testAppDelegateSetterAccessLevel() {
        let windowVarSubstructure = appDelegateClassSubstructure.children?.first(where: { $0.name == "window" })
        XCTAssertEqual(windowVarSubstructure?.setterAccessibility,
                       SKSubstructure.AccessLevel.private)
    }

    func testViewControllerHasBody() {
        XCTAssertTrue(viewControllerClassSubstructure.hasBody)
    }

    func testViewControllerSubstructure() {
        AssertByteRange(viewControllerClassSubstructure.contentByteRange,
                        in: viewControllerSource,
                        // swiftlint:disable line_length
                        equals: """
                                class ViewController: UIViewController {

                                    /// This has some documentation also.
                                    override func viewDidLoad() {
                                        super.viewDidLoad()
                                        // Do any additional setup after loading the view, typically from a nib.

                                        try String(contentsOf: URL(fileURLWithPath: ""))
                                    }

                                    func genericFunction<T: RawRepresentable>(with parameter: T) -> ((T) -> String)? where T.RawValue == String {
                                        return nil
                                    }

                                }
                                """)
                        // swiftlint:enable line_length

        XCTAssertFalse(viewControllerClassSubstructure.isReturningFunction,
                      "`isReturningFunction` returns incorrect value.")
        XCTAssertNil(viewControllerClassSubstructure.functionReturnType,
                     "`ViewController` should not have a `functionReturnType` value.")
        XCTAssertTrue(viewControllerClassSubstructure.isClass,
                      "Substructure returns incorrect `isClass` value.")
        XCTAssertFalse(viewControllerClassSubstructure.isVariable,
                      "Substructure returns incorrect `isVariable` value.")
    }

    func testViewControllerOverriddenFunc() {
        let funcSubstructure = viewControllerClassSubstructure.children![0]
        XCTAssertEqual(funcSubstructure.name, "viewDidLoad()")
        XCTAssertTrue(funcSubstructure.isOverride,
                      "Substructure returns incorrect `isOverride` value.")
    }

    func testViewControllerGenericFunc() {
        let viewControllerClass = viewControllerClassSubstructure
        let genericFuncSubstructure = viewControllerClass.children![1]

        AssertByteRange(genericFuncSubstructure.nameByteRange,
                        in: viewControllerSource,
                        equals: "genericFunction<T: RawRepresentable>(with parameter: T)")

        AssertByteRange(genericFuncSubstructure.contentByteRange,
                        in: viewControllerSource,
                        // swiftlint:disable line_length
                        equals: """
                                func genericFunction<T: RawRepresentable>(with parameter: T) -> ((T) -> String)? where T.RawValue == String {
                                        return nil
                                    }
                                """)
                        // swiftlint:enable line_length

        XCTAssertTrue(genericFuncSubstructure.isReturningFunction,
                      "`isReturningFunction` returns incorrect value.")
        SylvesterAssertEqual(genericFuncSubstructure.functionReturnType,
                             expected: "((T) -> String)?")
        XCTAssertFalse(genericFuncSubstructure.isClass,
                      "`isClass` returns incorrect value.")
        XCTAssertFalse(genericFuncSubstructure.isProtocol,
                       "`isProtocol` returns incorrect value.")
        XCTAssertFalse(genericFuncSubstructure.isOverride,
                       "Substructure returns incorrect `isOverride` value.")
    }

    func testAProtocolAttributesAreSorted() {
        guard let attributes = aProtocolProtocolSubstructure.attributes
            else { return XCTFail("Protocol substructure has no `attributes`.") }

        var lastAttributeOffset: Offset = 0
        for attribute in attributes {
            XCTAssertLessThan(lastAttributeOffset, attribute.offset)
            lastAttributeOffset = attribute.offset
        }
    }

    func testAProtocolProtocolSubstructure() {
        XCTAssertTrue(aProtocolProtocolSubstructure.isProtocol,
                      "Substructure returns incorrect `isProtocol` value.")

        AssertByteRange(aProtocolProtocolSubstructure.nameByteRange,
                        in: aProtocolSource,
                        equals: "AProtocol")

        AssertByteRange(aProtocolProtocolSubstructure.contentByteRange,
                        in: aProtocolSource,
                        equals: """
                                @objc(AProtocol)
                                public protocol AProtocol {

                                    var aVariable: Bool { get set }

                                    var aClosure: (Int) -> Void { get set }

                                    func aFunction() -> () -> String

                                }
                                """)

        XCTAssertFalse(aProtocolProtocolSubstructure.isExtension,
                       "`isExtension` returns incorrect value.")
    }

    func testAProtocolVar() {
        let protocolSubstructure = aProtocolProtocolSubstructure
        let varSubstructure = protocolSubstructure.children![0]
        let contentByteRange = varSubstructure.contentByteRange

        AssertByteRange(varSubstructure.nameByteRange,
                        in: aProtocolSource,
                        equals: "aVariable")

        AssertByteRange(contentByteRange,
                        in: aProtocolSource,
                        equals: "var aVariable: Bool { get set }")

        XCTAssertTrue(varSubstructure.isVariable, "Substructure returns incorrect `isVariable` value.")
        XCTAssertTrue(varSubstructure.isInsideProtocolDeclaration,
                      "Substructure returns incorrect `isInsideProtocolDeclaration` value.")
    }

    func testAProtocolClosure() {
        let protocolSubstructure = aProtocolProtocolSubstructure
        let closureSubstructure = protocolSubstructure.children![1]
        let contentByteRange = closureSubstructure.contentByteRange

        AssertByteRange(closureSubstructure.nameByteRange,
                        in: aProtocolSource,
                        equals: "aClosure")

        AssertByteRange(contentByteRange,
                        in: aProtocolSource,
                        equals: "var aClosure: (Int) -> Void { get set }")

        XCTAssertTrue(closureSubstructure.isInsideProtocolDeclaration,
                      "Substructure returns incorrect `isInsideProtocolDeclaration` value.")
    }

    func testAProtocolFunc() {
        let protocolSubstructure = aProtocolProtocolSubstructure
        let funcSubstructure = protocolSubstructure.children![2]
        let contentByteRange = funcSubstructure.contentByteRange

        AssertByteRange(funcSubstructure.nameByteRange,
                        in: aProtocolSource,
                        equals: "aFunction()")

        AssertByteRange(contentByteRange,
                        in: aProtocolSource,
                        equals: "func aFunction() -> () -> String")

        XCTAssertTrue(funcSubstructure.isReturningFunction,
                      "`isReturningFunction` returns incorrect value.")
        SylvesterAssertEqual(funcSubstructure.functionReturnType,
                             expected: "() -> String")
    }

    func testAProtocolExtension() {
        let extensionSubstructure = aProtocolEditorOpenResponse.topLevelSubstructures.first(where: { $0.isExtension })
        XCTAssertNotNil(extensionSubstructure,
                        "`isExtension` returns incorrect value.")
    }

    func testPlaceholdersMark() {
        let markSubstructure = placeholdersSubstructureChildren.first(where: { $0.isMark })
        XCTAssertNotNil(markSubstructure,
                        "Could not find mark substructure.")
        XCTAssertNil(markSubstructure?.nameByteRange,
                     "Mark substructure should not have a `nameByteRange` (because it's zero).")
        XCTAssertNil(markSubstructure?.bodyByteRange,
                     "Mark substructure should not have a `bodyByteRange`.")
    }

    // MARK: - Test Assertion Methods

    // swiftlint:disable identifier_name
    func AssertByteRange(_ byteRange: NSRange?,
                         in string: String,
                         equals expectedString: String,
                         file: StaticString = #file,
                         line: UInt = #line) {
        guard let byteRange = byteRange
            else { return XCTFail("Byte range is nil.", file: file, line: line) }

        guard let range = string.range(from: byteRange)
            else { return XCTFail("Failed to get substring from byte range.", file: file, line: line) }

        AssertRange(range, in: string, equals: expectedString, file: file, line: line)
    }

    func AssertRange(_ range: Range<String.Index>?,
                     in string: String,
                     equals expectedString: String,
                     file: StaticString = #file,
                     line: UInt = #line) {
        guard let range = range
            else { return XCTFail("Range is nil.", file: file, line: line) }
        SylvesterAssertEqual(String(string[range]), expected: expectedString, file: file, line: line)
    }

    func AssertEqual(byteRange: NSRange,
                     range: Range<String.Index>?,
                     in string: String,
                     file: StaticString = #file,
                     line: UInt = #line) {
        guard let convertedRange = string.range(from: byteRange)
            else { return XCTFail("Failed to convert `NSRange` to `Range<String.Index>`", file: file, line: line) }
        XCTAssertEqual(convertedRange, range, file: file, line: line)
    }
    // swiftlint:enable identifier_name

}
