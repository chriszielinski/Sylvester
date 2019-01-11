//
//  main.swift
//  SylvesterXPCService 😼
//
//  Created by Chris Zielinski on 9/15/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

import Foundation

let delegate = SylvesterXPCDelegate()
let listener = NSXPCListener.service()

listener.delegate = delegate
listener.resume()
