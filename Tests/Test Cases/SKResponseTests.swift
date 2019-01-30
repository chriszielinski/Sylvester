//
//  SKResponseTests.swift
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

class SKResponseTests: SylvesterTestCase {

    // MARK: - Stored Properties

    let length = 15
    let offset = 20

    // MARK: - Test Methods

    func testAttribute() {
        let attribute = SKAttribute(kind: .available, offset: offset, length: length)
        XCTAssertEqual(attribute.kind, .available)
        XCTAssertEqual(attribute.length, length)
        XCTAssertEqual(attribute.offset, offset)
        XCTAssertEqual(attribute.debugDescription,
                       """
                       {
                         "key.length" : 15,
                         "key.attribute" : "source.decl.attribute.available",
                         "key.offset" : 20
                       }
                       """)
    }

    func testElement() {
        let element = SKElement(kind: .id, offset: offset, length: length)
        XCTAssertEqual(element.kind, .id)
        XCTAssertEqual(element.length, length)
        XCTAssertEqual(element.offset, offset)
        XCTAssertEqual(element.debugDescription,
                       """
                       {
                         "key.length" : 15,
                         "key.kind" : "source.lang.swift.structure.elem.id",
                         "key.offset" : 20
                       }
                       """)
    }

    func testInheritedType() {
        let inheritedTypeName = "UIViewController"
        let inheritedType = SKInheritedType(name: inheritedTypeName)
        XCTAssertEqual(inheritedType.name, inheritedTypeName)
        XCTAssertEqual(inheritedType.debugDescription,
                       """
                       {
                         "key.name" : "UIViewController"
                       }
                       """)

        let differentInheritedType = SKInheritedType(name: "UIView")
        XCTAssertNotEqual(inheritedType, differentInheritedType)
        XCTAssertEqual(differentInheritedType, differentInheritedType)
    }

    func testOverride() {
        let usr = "usr"
        let override = SKOverride(usr: usr)
        XCTAssertEqual(override.usr, usr)
        XCTAssertEqual(override.debugDescription,
                       """
                       {
                         "key.usr" : "usr"
                       }
                       """)

        let differentOverride = SKOverride(usr: "different-usr")
        XCTAssertNotEqual(override, differentOverride)
        XCTAssertEqual(differentOverride, differentOverride)
    }

    func testParameter() {
        let parameterName = "testParameter"
        let firstParagraph = SKDocumentationParameter.Paragraph(paragraph: "A paragraph.")
        let secondParagraph = SKDocumentationParameter.Paragraph(paragraph: "A second paragraph.")
        let parameter = SKDocumentationParameter(name: parameterName, discussion: [firstParagraph, secondParagraph])
        XCTAssertEqual(parameter.name, parameterName)
        XCTAssertEqual(parameter.discussion.count, 2)
        XCTAssertEqual(parameter.discussion[0].paragraph, firstParagraph.paragraph)
        XCTAssertEqual(parameter.discussion[1].paragraph, secondParagraph.paragraph)
        XCTAssertEqual(parameter.description, """
                                              A paragraph.
                                              A second paragraph.
                                              """)

        let differentParameter = SKDocumentationParameter(name: "testOtherParameter", discussion: [firstParagraph])
        XCTAssertNotEqual(parameter, differentParameter)
        XCTAssertEqual(parameter, parameter)
    }

    func testInit() {
        let diagnosticStage: SKBaseResponse.DiagnosticStage = .parse
        let response = SKBaseResponse(diagnosticStage: diagnosticStage,
                                      length: length,
                                      offset: offset,
                                      substructureChildren: SKChildren(elements: []),
                                      syntaxMap: nil)
        XCTAssertEqual(response.diagnosticStage, diagnosticStage)
        XCTAssertEqual(response.length, length)
        XCTAssertEqual(response.offset, offset)
        XCTAssertEqual(response.topLevelSubstructures.count, 0)
        XCTAssertNil(response.syntaxMap)
    }

}
