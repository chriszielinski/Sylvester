//
//  JSONDebugStringConvertable.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 1/4/19.
//  Copyright © 2019 Big Z Labs. All rights reserved.
//

import Foundation

protocol JSONDebugStringConvertable: Encodable, CustomDebugStringConvertible {

    var jsonDebugDescription: String { get }

}

extension JSONDebugStringConvertable {

    var jsonDebugDescription: String {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            return String(data: try encoder.encode(self), encoding: .utf8)
                ?? "`Data` to UTF-8 encoding failed"
        } catch {
            return (error as NSError).description
        }
    }

}

// MARK: - Custom Debug String Convertible Protocol

extension JSONDebugStringConvertable {

    public var debugDescription: String {
        return jsonDebugDescription
    }

}
