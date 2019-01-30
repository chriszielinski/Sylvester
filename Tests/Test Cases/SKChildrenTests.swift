//
//  SKChildrenTests.swift
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

class SKChildrenTests: SylvesterMockEditorOpenTestCase {

    // MARK: - Computed Properties

    var mockViewControllerSubstructureChildren: SKChildren<SKSubstructure> {
        return viewControllerEditorOpenResponse.topLevelSubstructures
    }

    /// Returns a `SKChildren` with at least two substructures.
    var mockAtLeastTwoSubstructureChildren: SKChildren<SKSubstructure> {
        guard let substructureChildren = viewControllerClassSubstructure.children?.first?.children else {
            XCTFail("could not find a `SKChildren` with at least two substructures")
            fatalError()
        }
        XCTAssertTrue(substructureChildren.count >= 2,
                      "could not find a `SKChildren` with at least two substructures")
        return substructureChildren
    }

    // MARK: - Test Methods

    func testEquatable() {
        let substructureChildren = mockAtLeastTwoSubstructureChildren
        XCTAssertEqual(substructureChildren, substructureChildren)
        XCTAssertNotEqual(mockViewControllerSubstructureChildren, substructureChildren)

        guard let encodedSubstructureChildren = try? JSONEncoder().encode(substructureChildren)
            else { return XCTFail("failed to encode `SKChildren`") }
        guard let decodedSubstructureChildren = try? JSONDecoder().decode(SKChildren<SKSubstructure>.self,
                                                                          from: encodedSubstructureChildren)
            else { return XCTFail("failed to decode `SKChildren`") }

        XCTAssertEqual(substructureChildren, decodedSubstructureChildren)
    }

    func testCount() {
        XCTAssertEqual(mockViewControllerSubstructureChildren.count, 1,
                       "the mock ViewController top-level substructure has an incorrect count")
        XCTAssertEqual(mockViewControllerSubstructureChildren.first?.children?.count, 2,
                       "the mock ViewController substructure has an incorrect children count")
    }

    func testFirst() {
        XCTAssertEqual(mockViewControllerSubstructureChildren.first?.name, "ViewController",
                       "the mock ViewController substructure's first substructure has the incorrect name")
    }

    func testLast() {
        XCTAssertEqual(mockViewControllerSubstructureChildren.first?.children?.last?.name, "genericFunction(with:)",
                       "the mock ViewController's first substructure's last child has the incorrect name")
    }

    func testIndexOfSubstructure() {
        continueAfterFailure = false

        let innerInnerSubstructureChildren = mockAtLeastTwoSubstructureChildren
        XCTAssertTrue(innerInnerSubstructureChildren.count >= 2)
        XCTAssertEqual(innerInnerSubstructureChildren.index(of: innerInnerSubstructureChildren[1]), 1)
    }

    func testRemoveSubstructure() {
        continueAfterFailure = false

        let innerInnerSubstructureChildren = mockAtLeastTwoSubstructureChildren
        let substructureCount = innerInnerSubstructureChildren.count
        let firstSubstructure = innerInnerSubstructureChildren[0]
        let secondSubstructure = innerInnerSubstructureChildren[1]

        XCTAssertTrue(innerInnerSubstructureChildren.remove(substructure: firstSubstructure))
        XCTAssertEqual(innerInnerSubstructureChildren.count, substructureCount - 1)
        XCTAssertEqual(innerInnerSubstructureChildren.first, secondSubstructure)
        XCTAssertFalse(innerInnerSubstructureChildren.remove(substructure: firstSubstructure))
        XCTAssertEqual(innerInnerSubstructureChildren.count, substructureCount - 1)
    }

    func testSubstructureSetter() {
        continueAfterFailure = false

        let innerInnerSubstructureChildren = mockAtLeastTwoSubstructureChildren
        XCTAssertNotEqual(innerInnerSubstructureChildren[0], innerInnerSubstructureChildren[1])

        innerInnerSubstructureChildren[1] = innerInnerSubstructureChildren[0]
        XCTAssertEqual(innerInnerSubstructureChildren[0], innerInnerSubstructureChildren[1])
    }

}
