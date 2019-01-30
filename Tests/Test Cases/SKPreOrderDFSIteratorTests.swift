//
//  SKPreOrderDFSIteratorTests.swift
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

class SKPreOrderDFSIteratorTests: SylvesterMockEditorOpenTestCase {

    // MARK: - Test Declarations

    class FunctionIterator<Substructure: CustomSubstructure>: SKPreOrderDFSIterator<Substructure> {

        override func next() -> Substructure? {
            guard let nextSubstructure = super.next()
                else { return nil }
            if nextSubstructure.isFunction {
                return nextSubstructure
            } else {
                return next()
            }
        }

    }

    final class CustomSubstructure: SKBaseSubstructure, SKFinalSubclass {

        override class func iteratorClass<Substructure: CustomSubstructure>()
                                         -> SKPreOrderDFSIterator<Substructure>.Type {
            return FunctionIterator.self
        }

        override func decodeChildren(from container: DecodingContainer) throws -> [SKBaseSubstructure]? {
            return try decodeChildren(CustomSubstructure.self, from: container)
        }

    }

    // MARK: - Stored Properties

    let preOrderDFSViewControllerEditorOpenNames = [
        "ViewController",
        "viewDidLoad()",
        "super.viewDidLoad",
        "String",
        "contentsOf",
        "URL",
        "fileURLWithPath",
        "genericFunction(with:)",
        "T",
        "parameter"
    ]
    let preOrderDFSViewControllerDocInfoNames = [
        "ViewController",
        "viewDidLoad()",
        "genericFunction(with:)",
        "parameter"
    ]

    // MARK: - Test Methods

    func testViewControllerEditorOpenOrder() {
        continueAfterFailure = false

        var count = 0
        for (index, substructure) in viewControllerEditorOpenResponse.topLevelSubstructures.enumerated() {
            XCTAssertEqual(index, count,
                           "the enumerated index is not equal to the count")
            XCTAssertEqual(index, substructure.index,
                           "substructure has incorrect index")
            XCTAssertLessThan(index, preOrderDFSViewControllerEditorOpenNames.count,
                              "response contains more substructures than the test expects")
            XCTAssertEqual(substructure.name, preOrderDFSViewControllerEditorOpenNames[index],
                           "`SKPreOrderDFSIterator` is not pre-order DFS")
            count += 1
        }

        XCTAssertEqual(count, preOrderDFSViewControllerEditorOpenNames.count)
    }

    func testViewControllerDocInfoOrder() {
        continueAfterFailure = false

        var count = 0
        for (index, entity) in viewControllerDocInfoResponse.topLevelEntities!.enumerated() {
            XCTAssertEqual(index, count,
                           "the enumerated index is not equal to the count")
            XCTAssertEqual(index, entity.index,
                           "the entity has incorrect index")
            XCTAssertLessThan(index, preOrderDFSViewControllerDocInfoNames.count,
                              "the response contains more entities than the test expects")
            XCTAssertEqual(entity.name, preOrderDFSViewControllerDocInfoNames[index],
                           "`SKPreOrderDFSIterator` is not pre-order DFS")
            count += 1
        }

        XCTAssertEqual(count, preOrderDFSViewControllerDocInfoNames.count)
    }

    func testSubstructureSubclassIterator() throws {
        let customEditorOpen = try SKGenericEditorOpen<CustomSubstructure>(file: viewControllerFile)
        let functionCount = customEditorOpen.topLevelSubstructures.reduce(0) { (count, _) in return count + 1 }
        XCTAssertEqual(functionCount, 2)
    }

}
