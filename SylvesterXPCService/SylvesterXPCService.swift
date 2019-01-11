//
//  SylvesterXPCService.swift
//  SylvesterXPCService 😼
//
//  Created by Chris Zielinski on 9/15/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

import SourceKittenFramework
import SylvesterCommon

class SylvesterXPCService: NSObject {}

// MARK: - Sylvester XPC Protocol

extension SylvesterXPCService: SylvesterXPCProtocol {

    // MARK: - Module Methods

    func moduleInfo(xcodeBuildArguments: [String],
                    name: String?,
                    in path: String,
                    with reply: (SKModuleWrapper?, SKXPCError?) -> Void) {
        do {
            let module = try SourceKittenAdapter.moduleInfo(xcodeBuildArguments: xcodeBuildArguments,
                                                                   name: name,
                                                                   in: path)
            reply(try SKModuleWrapper(xpcModule: module), nil)
        } catch {
            return reply(nil, error.toSKXPCError())
        }
    }

    func moduleDocs(module: SKModuleWrapper,
                    with reply: (SKDataWrapper?, SKXPCError?) -> Void) {
        do {
            reply(try SourceKittenAdapter.moduleDocs(module: module.xpcModule()), nil)
        } catch {
            return reply(nil, error.toSKXPCError())
        }
    }

    // MARK: - Editor Methods

    func editorOpen(file: SKFileWrapper,
                    with reply: (SKDataWrapper?, SKXPCError?) -> Void) {
        do {
            reply(try SourceKittenAdapter.editorOpen(file: file.file), nil)
        } catch {
            reply(nil, error.toSKXPCError())
        }
    }

    // MARK: - Syntax Methods

    func syntaxMap(file: SKFileWrapper,
                   with reply: (SKSyntaxMapWrapper?, SKXPCError?) -> Void) {
        do {
            reply(SKSyntaxMapWrapper(syntaxMap: try SourceKittenAdapter.syntaxMap(file: file.file)), nil)
        } catch {
            reply(nil, error.toSKXPCError())
        }
    }

    // MARK: - Documentation Methods

    func swiftDocs(file: SKFileWrapper,
                   compilerArguments: [String],
                   with reply: (SKDataWrapper?, SKXPCError?) -> Void) {
        do {
            reply(try SourceKittenAdapter.swiftDocs(file: file.file,
                                                    compilerArguments: compilerArguments), nil)
        } catch {
            reply(nil, error.toSKXPCError())
        }
    }

    // MARK: - Code Completion Methods

    func codeCompletion(file: SKFileWrapper,
                        offset: Int,
                        compilerArguments: [String],
                        with reply: (SKDataWrapper?, SKXPCError?) -> Void) {
        do {
            reply(try SourceKittenAdapter.codeCompletion(file: file.file,
                                                         offset: offset,
                                                         compilerArguments: compilerArguments), nil)
        } catch {
            reply(nil, error.toSKXPCError())
        }
    }

    func codeCompletionOpen(file: SKFileWrapper,
                            offset: Int,
                            options: SKDataWrapper?,
                            compilerArguments: [String],
                            with reply: (SKDataWrapper?, SKXPCError?) -> Void) {
        do {
            var codeCompletionOptions: SKCodeCompletionSessionOptions?

            if let options = options {
                codeCompletionOptions = try decodeCodeCompletionOptions(from: options)
            }

            reply(try SourceKittenAdapter.codeCompletionOpen(file: file.file,
                                                             offset: offset,
                                                             options: codeCompletionOptions,
                                                             compilerArguments: compilerArguments), nil)
        } catch {
            reply(nil, error.toSKXPCError())
        }
    }

    func codeCompletionUpdate(name: String,
                              offset: Int,
                              options: SKDataWrapper,
                              with reply: (SKDataWrapper?, SKXPCError?) -> Void) {
        do {
            let codeCompletionOptions = try decodeCodeCompletionOptions(from: options)
            reply(try SourceKittenAdapter.codeCompletionUpdate(name: name,
                                                               offset: offset,
                                                               options: codeCompletionOptions), nil)
        } catch {
            reply(nil, error.toSKXPCError())
        }
    }

    func codeCompletionClose(name: String,
                             offset: Int,
                             with reply: (SKXPCError?) -> Void) {
        do {
            try SourceKittenAdapter.codeCompletionClose(name: name, offset: offset)
        } catch {
            return reply(error.toSKXPCError())
        }

        reply(nil)
    }

    // MARK: - Custom Request Methods

    func customYAML(_ yaml: String,
                    with reply: (SKDataWrapper?, SKXPCError?) -> Void) {
        do {
            reply(try SourceKittenAdapter.customYAML(yaml: yaml), nil)
        } catch {
            reply(nil, error.toSKXPCError())
        }
    }

    // MARK: - Process Methods

    func xcRun(arguments: [String],
               with reply: (String?) -> Void) {
        reply(SourceKittenAdapter.xcRun(arguments: arguments))
    }

    func xcodeBuild(arguments: [String],
                    currentDirectoryPath: String,
                    with reply: (String?) -> Void) {
        reply(SourceKittenAdapter.xcodeBuild(arguments: arguments, currentDirectoryPath: currentDirectoryPath))
    }

    func executeBash(_ command: String,
                     currentDirectoryPath: String?,
                     with reply: (String?) -> Void) {
        reply(SourceKittenAdapter.executeBash(command, currentDirectoryPath: currentDirectoryPath))
    }

    func executeShell(launchPath: String,
                      arguments: [String],
                      currentDirectoryPath: String?,
                      shouldPipeStandardError: Bool,
                      with reply: (String?) -> Void) {
        reply(SourceKittenAdapter.executeShell(launchPath: launchPath,
                                               arguments: arguments,
                                               currentDirectoryPath: currentDirectoryPath,
                                               shouldPipeStandardError: shouldPipeStandardError))
    }

    func decodeCodeCompletionOptions(from wrapper: SKDataWrapper) throws -> SKCodeCompletionSessionOptions {
        return try wrapper.xpcDecodeData()
    }

}
