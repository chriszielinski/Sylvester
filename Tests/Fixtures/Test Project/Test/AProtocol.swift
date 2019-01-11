//
//  AProtocol.swift
//  Test
//
//  Created by Chris Zielinski on 11/30/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

import UIKit

/// This is a `AProtocol`'s documentation.
@objc(AProtocol)
public protocol AProtocol {

    var aVariable: Bool { get set }

    var aClosure: (Int) -> Void { get set }

    func aFunction() -> () -> String

}

extension AProtocol {

    var aClosure: (Int) -> Void {
        return { (int) in print(int) }
    }

}
