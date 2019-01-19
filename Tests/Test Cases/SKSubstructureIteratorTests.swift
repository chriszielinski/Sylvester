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

        for (index, substructure) in viewControllerEditorOpenResponse.topLevelSubstructures.enumerated() {
            XCTAssertEqual(index, substructure.index,
                           "Substructure has incorrect index.")
            XCTAssertLessThan(index, preOrderDFSViewControllerNames.count,
                              "Response contains more substructures than the test expects.")
            XCTAssertEqual(substructure.name, preOrderDFSViewControllerNames[index],
                           "`SKSubstructureIterator` is not pre-order DFS.")
        }
    }

    func testFilterPredicate() {
        SKBaseSubstructure.iteratorFilterPredicate = { $0.isFunction }
        let functionCount = viewControllerEditorOpenResponse.topLevelSubstructures.reduce(0) { (count, _) in
            return count + 1
        }
        SKBaseSubstructure.iteratorFilterPredicate = nil

        XCTAssertEqual(functionCount, 2)
    }

}
