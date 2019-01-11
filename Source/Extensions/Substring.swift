//
//  Substring.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 12/28/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

import Foundation

extension Substring {

    // FIXME: Remove?
    func rangeAfterTrimmingCharacters(in characterSet: CharacterSet) -> Range<Substring.Index> {
        return range(of: trimmingCharacters(in: characterSet))!
    }

}
