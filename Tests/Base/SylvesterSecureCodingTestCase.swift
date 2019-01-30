//
//  SylvesterSecureCodingTestCase.swift
//  Sylvester Tests 😼
//
//  Created by Chris Zielinski on 12/22/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

import XCTest

class SylvesterSecureCodingTestCase: SylvesterMockEditorOpenTestCase {

    // MARK: - Test Assertion Methods

    // swiftlint:disable:next identifier_name
    func AssertSecureCoding<T: NSSecureCoding>(_ object: T,
                                               file: StaticString = #file,
                                               line: UInt = #line) -> T {
        let coder = NSKeyedArchiver(requiringSecureCoding: true)
        object.encode(with: coder)

        do {
            let decoder = try NSKeyedUnarchiver(forReadingFrom: coder.encodedData)
            let decodedObject = T(coder: decoder)

            XCTAssertNotNil(decodedObject, file: file, line: line)

            return decodedObject!
        } catch {
            XCTFail((error as NSError).description)
            fatalError()
        }
    }

}
