//
//  SourceKitUID.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 12/4/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

/// A protocol that all SourceKit UIDs conform to.
public protocol SourceKitUID: RawRepresentable, CustomStringConvertible, CustomDebugStringConvertible
                              where Self.RawValue == String {}

// MARK: - Custom String Convertible Protocol

extension SourceKitUID {

    public var description: String {
        return rawValue.components(separatedBy: ".").last!
    }

}

// MARK: - Custom Debug String Convertible Protocol

extension SourceKitUID {

    public var debugDescription: String {
        return rawValue
    }

}
