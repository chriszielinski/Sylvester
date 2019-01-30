//
//  SKModule.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 12/12/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

#if !COCOAPODS
import SylvesterCommon
#endif

/// Represents a _SourceKitten_ documentation request for a given module.
open class SKModule: SKGenericModule<SKSubstructure, SKSwiftDocs> {}
