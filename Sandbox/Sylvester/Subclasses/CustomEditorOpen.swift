//
//  CustomEditorOpen.swift
//  Sandbox
//
//  Created by Chris Zielinski on 1/3/19.
//  Copyright © 2019 Big Z Labs. All rights reserved.
//

import SylvesterXPC

public class CustomEditorOpen: SKGenericEditorOpen<CustomSubstructure> {

    // Public Stored Properties

    public var overriddenResolveCalled: Bool = false

    // Public Overridden Methods

    override public func resolve(from filePath: String?) {
        overriddenResolveCalled = true

        super.resolve(from: filePath)
    }

}
