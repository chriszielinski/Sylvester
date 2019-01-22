//
//  SylvesterXPCProtocol.swift
//  SylvesterXPCService 😼
//
//  Created by Chris Zielinski on 9/15/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

import SylvesterCommon

@objc
public protocol SylvesterXPCProtocol {

    // MARK: - Module Methods

    func moduleInfo(xcodeBuildArguments: [String],
                    name: String?,
                    in path: String,
                    with reply: (SKModuleWrapper?, SKXPCError?) -> Void)
    func moduleDocs(module: SKModuleWrapper, with reply: (SKDataWrapper?, SKXPCError?) -> Void)

    // MARK: - Editor Methods

    func editorOpen(file: SKFileWrapper, with reply: (SKDataWrapper?, SKXPCError?) -> Void)

    // MARK: - Syntax Methods

    func syntaxMap(file: SKFileWrapper, with reply: (SKSyntaxMapWrapper?, SKXPCError?) -> Void)

    // MARK: - Documentation Methods

    func swiftDocs(file: SKFileWrapper,
                   compilerArguments: [String],
                   with reply: (SKDataWrapper?, SKXPCError?) -> Void)

    // MARK: - Code Completion Methods

    func codeCompletion(file: SKFileWrapper,
                        offset: Int,
                        compilerArguments: [String],
                        with reply: (SKDataWrapper?, SKXPCError?) -> Void)
    func codeCompletionOpen(file: SKFileWrapper,
                            offset: Int,
                            options: SKDataWrapper?,
                            compilerArguments: [String],
                            with reply: (SKDataWrapper?, SKXPCError?) -> Void)
    func codeCompletionUpdate(name: String,
                              offset: Int,
                              options: SKDataWrapper,
                              with reply: (SKDataWrapper?, SKXPCError?) -> Void)
    func codeCompletionClose(name: String, offset: Int, with reply: (SKXPCError?) -> Void)

    // MARK: - Custom Request Methods

    func customYAML(_ yaml: String, with reply: (SKDataWrapper?, SKXPCError?) -> Void)

    // MARK: - Subprocess Methods

    func xcRun(arguments: [String], with reply: (String?) -> Void)
    func xcodeBuild(arguments: [String], currentDirectoryURL: URL, with reply: (String?) -> Void)
    func executeBash(_ command: String, currentDirectoryURL: URL?, with reply: (String?) -> Void)
    func launch(subprocess: SKDataWrapper, with reply: (String?, SKXPCError?) -> Void)

}
