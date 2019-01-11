//
//  SKSubstructureChildrenTests.swift
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

class SKSubstructureChildrenTests: SylvesterMockEditorOpenTestCase {

    // MARK: - Computed Properties

    var mockViewControllerSubstructureChildren: SKSubstructureChildren {
        return viewControllerEditorOpenResponse.topLevelSubstructures
    }

    /// Returns a `SKSubstructureChildren` with at least two substructures.
    var mockAtLeastTwoSubstructureChildren: SKSubstructureChildren {
        guard let substructureChildren = viewControllerClassSubstructure.children?.first?.children else {
            XCTFail("could not find a `SKSubstructureChildren` with at least two substructures")
            fatalError()
        }
        XCTAssertTrue(substructureChildren.count >= 2,
                      "")
        return substructureChildren
    }

    // MARK: - Test Methods

    func testEquatable() {
        let substructureChildren = mockAtLeastTwoSubstructureChildren
        XCTAssertEqual(substructureChildren, substructureChildren)
        XCTAssertNotEqual(mockViewControllerSubstructureChildren, substructureChildren)

        guard let encodedSubstructureChildren = try? JSONEncoder().encode(substructureChildren)
            else { return XCTFail("failed to encode `SKSubstructureChildren`") }
        guard let decodedSubstructureChildren = try? JSONDecoder().decode(SKSubstructureChildren.self,
                                                                          from: encodedSubstructureChildren)
            else { return XCTFail("failed to decode `SKSubstructureChildren`") }

        XCTAssertEqual(substructureChildren, decodedSubstructureChildren)
    }

    // FIXME: Add failure message.
    func testCount() {
        XCTAssertEqual(mockViewControllerSubstructureChildren.count, 1,
                       "")
        XCTAssertEqual(mockViewControllerSubstructureChildren.substructures.first?.children?.count, 2,
                       "")
    }

    // FIXME: Add failure message.
    func testFirst() {
        XCTAssertEqual(mockViewControllerSubstructureChildren.first?.name, "ViewController",
                       "")
    }

    // FIXME: Add failure message.
    func testLast() {
        XCTAssertEqual(mockViewControllerSubstructureChildren.first?.children?.last?.name, "genericFunction(with:)",
                       "")
    }

    // FIXME: Add failure message.
    func testIndexOfSubstructure() {
        let innerInnerSubstructureChildren = mockAtLeastTwoSubstructureChildren
        XCTAssertTrue(innerInnerSubstructureChildren.count >= 2,
                      "")
        XCTAssertEqual(innerInnerSubstructureChildren.index(of: innerInnerSubstructureChildren[1]), 1)
    }

    // FIXME: Add failure message.
    func testRemoveSubstructure() {
        let innerInnerSubstructureChildren = mockAtLeastTwoSubstructureChildren
        let substructureCount = innerInnerSubstructureChildren.count
        let firstSubstructure = innerInnerSubstructureChildren[0]
        let secondSubstructure = innerInnerSubstructureChildren[1]

        XCTAssertTrue(innerInnerSubstructureChildren.remove(substructure: firstSubstructure),
                      "")
        XCTAssertEqual(innerInnerSubstructureChildren.count, substructureCount - 1,
                       "")
        XCTAssertEqual(innerInnerSubstructureChildren.first, secondSubstructure,
                       "")
        XCTAssertFalse(innerInnerSubstructureChildren.remove(substructure: firstSubstructure),
                       "")
        XCTAssertEqual(innerInnerSubstructureChildren.count, substructureCount - 1,
                       "")
    }

    // FIXME: Add failure message.
    func testSubstructureSetter() {
        let innerInnerSubstructureChildren = mockAtLeastTwoSubstructureChildren

        XCTAssertNotEqual(innerInnerSubstructureChildren[0], innerInnerSubstructureChildren[1],
                          "")

        innerInnerSubstructureChildren[1] = innerInnerSubstructureChildren[0]

        XCTAssertEqual(innerInnerSubstructureChildren[0], innerInnerSubstructureChildren[1],
                       "")
    }

}
