//
//  SKEntityTests.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 12/7/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

import XCTest
#if XPC
@testable import SylvesterXPC
#else
@testable import Sylvester
#endif

class SKEntityTests: SylvesterTestCase {

    // MARK: - Stored Properties

    let offset = 10
    let length = 15

    // MARK: - Test Methods

    func testInit() {
        let firstAttribute = SKAttribute(kind: .available, offset: offset, length: length)
        let secondAttribute = SKAttribute(kind: .convenience, offset: offset + 1, length: length)
        let otherAttribute = SKAttribute(kind: .discardableResult, offset: offset, length: length)
        let outOfOrderEntities = [secondAttribute, firstAttribute]
        let entities = SKEntities(entities: outOfOrderEntities)

        XCTAssertEqual(entities[0], firstAttribute, "`SKEntities` subscript returns incorrect entity.")
        XCTAssertEqual(entities.index(of: firstAttribute), 0, "`SKEntities.index(of:)` returns incorrect index.")
        XCTAssertEqual(entities.index(of: secondAttribute), 1, "`SKEntities.index(of:)` returns incorrect index.")
        XCTAssertNil(entities.index(of: otherAttribute),
                     "`SKEntities.index(of:)` returns index for a non-member entity.")

        var entityIterator = entities.makeIterator()
        XCTAssertTrue(entityIterator.next() == firstAttribute && entityIterator.next() == secondAttribute,
                      "`SKEntities` iterator is not sorted.")
    }

    func testEntityEquatable() {
        let attributeKind: SKAttribute.Kind = .available
        let attribute = SKAttribute(kind: attributeKind, offset: offset, length: length)
        let sameAttribute = SKAttribute(kind: attributeKind, offset: offset, length: length)
        let failureMessage = "`SKAttribute`'s `Equatable` conformance is incorrect "

        XCTAssertTrue(attribute == sameAttribute,
                      failureMessage + "(attribute == sameAttribute).")

        let differentOffsetAttribute = SKAttribute(kind: attributeKind, offset: 0, length: length)
        XCTAssertTrue(attribute != differentOffsetAttribute,
                      failureMessage + "(attribute != differentOffsetAttribute).")

        let differentKindAttribute = SKAttribute(kind: .discardableResult, offset: offset, length: length)
        XCTAssertFalse(attribute == differentKindAttribute,
                      failureMessage + "(differentKindAttribute == differentKindAttribute).")
    }

    func testEntitiesEquatable() {
        let availableAttribute = SKAttribute(kind: .available, offset: offset, length: length)
        let ibInspectableAttribute = SKAttribute(kind: .ibinspectable, offset: offset, length: length)
        let nonMutatingAttribute = SKAttribute(kind: .nonmutating, offset: offset, length: length)
        let availableIBInspectableAttributes = [availableAttribute, ibInspectableAttribute]
        let availableNonMutatingAttributes = [availableAttribute, nonMutatingAttribute]

        let availableIBInspectableEntities = SKEntities(entities: availableIBInspectableAttributes)
        let availableNonMutatingEntities = SKEntities(entities: availableNonMutatingAttributes)

        XCTAssertEqual(availableIBInspectableEntities, availableIBInspectableEntities)
        XCTAssertNotEqual(availableIBInspectableEntities, availableNonMutatingEntities)
    }

    func testElementEquatable() {
        let elementKind: SKElement.Kind = .typeref
        let element = SKElement(kind: elementKind, offset: offset, length: length)
        let sameElement = SKElement(kind: elementKind, offset: offset, length: length)

        XCTAssertTrue(element == sameElement,
                       "`SKElement`'s `Equatable` conformance is incorrect (==).")

        let differentElementKind: SKElement.Kind = .pattern
        let differentElement = SKElement(kind: differentElementKind, offset: 0, length: length)
        XCTAssertTrue(element != differentElement,
                      "`SKElement`'s `Equatable` conformance is incorrect (!=).")

        let entities = SKEntities<SKElement>(entities: [element, differentElement])
        XCTAssertTrue(entities.containsElement(with: differentElementKind),
                      "`SKEntities.containsElement(with:)` returns false for a member element kind.")
        XCTAssertFalse(entities.containsElement(with: .conditionExpr),
                      "`SKEntities.containsElement(with:)` returns false for a member element kind.")
    }

}
