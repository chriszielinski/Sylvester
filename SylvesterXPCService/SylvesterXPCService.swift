//
//  SylvesterXPCService.swift
//  SylvesterXPCService 😼
//
//  Created by Chris Zielinski on 9/15/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

import SourceKittenFramework
#if !COCOAPODS
import SylvesterCommon
#endif

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

    func moduleDocs(module: SKModuleWrapper, with reply: (SKDataWrapper?, SKXPCError?) -> Void) {
        do {
            reply(try SourceKittenAdapter.moduleDocs(module: module.xpcModule()), nil)
        } catch {
            return reply(nil, error.toSKXPCError())
        }
    }

    // MARK: - Editor Methods

    func editorOpen(file: SKFileWrapper, with reply: (SKDataWrapper?, SKXPCError?) -> Void) {
        do {
            reply(try SourceKittenAdapter.editorOpen(file: file.file), nil)
        } catch {
            reply(nil, error.toSKXPCError())
        }
    }

    func editorExtractTextFromComment(sourceText: String, with reply: (SKDataWrapper?, SKXPCError?) -> Void) {
        do {
            reply(try SourceKittenAdapter.editorExtractTextFromComment(sourceText: sourceText), nil)
        } catch {
            reply(nil, error.toSKXPCError())
        }
    }

    // MARK: - Syntax Methods

    func syntaxMap(file: SKFileWrapper, with reply: (SKSyntaxMapWrapper?, SKXPCError?) -> Void) {
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

    func docInfo(file: SKFileWrapper?,
                 moduleName: String?,
                 compilerArguments: [String],
                 with reply: (SKDataWrapper?, SKXPCError?) -> Void) {
        do {
            reply(try SourceKittenAdapter.docInfo(file: file?.file,
                                                  moduleName: moduleName,
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
            reply(try SourceKittenAdapter.codeCompletionOpen(file: file.file,
                                                             offset: offset,
                                                             options: try options?.xpcDecodeData(),
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
            reply(try SourceKittenAdapter.codeCompletionUpdate(name: name,
                                                               offset: offset,
                                                               options: try options.xpcDecodeData()), nil)
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

    // MARK: - Cursor Methods

    // swiftlint:disable:next function_parameter_count
    func cursorInfo(file: SKFileWrapper,
                    offset: Int,
                    usr: String,
                    compilerArguments: [String],
                    cancelOnSubsequentRequest: Bool,
                    with reply: (SKDataWrapper?, SKXPCError?) -> Void) {
        do {
            reply(try SourceKittenAdapter.cursorInfo(file: file.file,
                                                     offset: offset == -1 ? nil : offset,
                                                     usr: usr.isEmpty ? nil : usr,
                                                     compilerArguments: compilerArguments,
                                                     cancelOnSubsequentRequest: cancelOnSubsequentRequest), nil)
        } catch {
            reply(nil, error.toSKXPCError())
        }
    }

    // MARK: - Markup Methods

    func convertMarkupToXML(sourceText: String, with reply: (SKDataWrapper?, SKXPCError?) -> Void) {
        do {
            reply(try SourceKittenAdapter.convertMarkupToXML(sourceText: sourceText), nil)
        } catch {
            reply(nil, error.toSKXPCError())
        }
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

    // MARK: - Subprocess Methods

    func xcRun(arguments: [String],
               with reply: (String?) -> Void) {
        reply(SourceKittenAdapter.xcRun(arguments: arguments))
    }

    func xcodeBuild(arguments: [String],
                    currentDirectoryURL: URL,
                    with reply: (String?) -> Void) {
        reply(SourceKittenAdapter.xcodeBuild(arguments: arguments, currentDirectoryURL: currentDirectoryURL))
    }

    func executeBash(_ command: String,
                     currentDirectoryURL: URL?,
                     with reply: (String?) -> Void) {
        reply(SourceKittenAdapter.executeBash(command, currentDirectoryURL: currentDirectoryURL))
    }

    func launch(subprocess: SKDataWrapper, with reply: (String?, SKXPCError?) -> Void) {
        do {
            reply(SourceKittenAdapter.launch(subprocess: try subprocess.xpcDecodeData()), nil)
        } catch {
            reply(nil, error.toSKXPCError())
        }
    }

}
