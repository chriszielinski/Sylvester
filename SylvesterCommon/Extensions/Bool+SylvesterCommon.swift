//
//  Bool.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 11/30/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

public extension Bool {

    /// Returns the integer value of the boolean (i.e. `1` if `true`, otherwise `0`).
    var toInt: Int {
        return self ? 1 : 0
    }

}
