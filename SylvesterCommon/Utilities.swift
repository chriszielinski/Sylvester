//
//  Utilities.swift
//  SylvesterCommon 😼
//
//  Created by Chris Zielinski on 12/21/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

public struct Utilities {

    public static func print(error: Error) {
        Swift.print(errorMessage(with: "\(error)"))
    }

    public static func errorMessage(with string: String) -> String {
        return "[Sylvester Error 😼] \(string)"
    }

}
