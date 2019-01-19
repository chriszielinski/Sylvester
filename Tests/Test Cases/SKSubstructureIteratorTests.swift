//
//  SKSubstructureIteratorTests.swift
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

class SKSubstructureIteratorTests: SylvesterMockEditorOpenTestCase {

    // MARK: - Declarations

    class FunctionIterator<T: SKBaseSubstructure>: SKSubstructureIterator<T> {
        override func next() -> T? {
            guard let nextSubstructure = super.next()
                else { return nil }
            if nextSubstructure.isFunction {
                return nextSubstructure
            } else {
                return next()
            }
        }
    }

    final class CustomSubstructure: SKBaseSubstructure, SKSubstructureSubclass {
        public override class func iteratorClass<T>() -> SKSubstructureIterator<T>.Type {
            return FunctionIterator.self
        }

        override func decodeChildren(from container: DecodingContainer) throws -> [SKBaseSubstructure]? {
            return try decodeChildren(CustomSubstructure.self, from: container)
        }
    }

    // MARK: - Stored Properties

    let preOrderDFSViewControllerNames = [
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

    // MARK: - Test Methods

    func testOrder() {
        continueAfterFailure = false

        var count = 0
        for (index, substructure) in viewControllerEditorOpenResponse.topLevelSubstructures.enumerated() {
            XCTAssertEqual(index, substructure.index,
                           "Substructure has incorrect index.")
            XCTAssertLessThan(index, preOrderDFSViewControllerNames.count,
                              "Response contains more substructures than the test expects.")
            XCTAssertEqual(substructure.name, preOrderDFSViewControllerNames[index],
                           "`SKSubstructureIterator` is not pre-order DFS.")
            count += 1
        }

        XCTAssertEqual(count, preOrderDFSViewControllerNames.count)
    }

    func testSubstructureSubclassIterator() throws {
        let customEditorOpen = try SKGenericEditorOpen<CustomSubstructure>(file: viewControllerFile)
        let functionCount = customEditorOpen.topLevelSubstructures.reduce(0) { (count, _) in return count + 1 }
        XCTAssertEqual(functionCount, 2)
    }

}
