//
//  SourceKittenInterface.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 12/8/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

import SourceKittenFramework
import SylvesterCommon

#if XPC
import SylvesterXPCService
#endif

open class SourceKittenInterface {

    // MARK: - Public Static Stored Properties

    public static let shared: SourceKittenInterface = SourceKittenInterface()

    // MARK: - Private Static Methods

    #if XPC
    private static func errorHandler(_ error: Error) {
        print("Received error:", error)
    }
    #endif

    // MARK: - Private Stored Properties

    #if XPC
    private let xpcConnection: NSXPCConnection
    private let synchronousProxy: SylvesterXPCProtocol
    #endif

    // MARK: - Private Initializers

    private init() {
        #if XPC
        xpcConnection = NSXPCConnection(serviceName: "com.bigzlabs.SylvesterXPCService")
        xpcConnection.remoteObjectInterface = NSXPCInterface(with: SylvesterXPCProtocol.self)
        xpcConnection.resume()

        synchronousProxy = xpcConnection
            .synchronousRemoteObjectProxyWithErrorHandler(SourceKittenInterface.errorHandler(_:))
            // swiftlint:disable:next force_cast
            as! SylvesterXPCProtocol
        #endif
    }

    // MARK: - Public SourceKitten Interface Methods

    public func moduleInfo(xcodeBuildArguments: [String],
                           name: String? = nil,
                           in path: String) throws -> Module {
        #if XPC
        var response: SKModuleWrapper?
        var responseError: SKXPCError?

        synchronousProxy.moduleInfo(xcodeBuildArguments: xcodeBuildArguments,
                                    name: name,
                                    in: path) { (moduleWrapper, error) in
                                        response = moduleWrapper
                                        responseError = error
        }

        return try handleXPC(response: response, error: responseError).module()
        #else
        return try SourceKittenAdapter.moduleInfo(xcodeBuildArguments: xcodeBuildArguments,
                                                  name: name,
                                                  in: path)
        #endif
    }

    public func moduleDocs<T: SKSwiftDocs>(module: Module) throws -> [T] {
        #if XPC
        var response: SKDataWrapper?
        var responseError: SKXPCError?

        synchronousProxy.moduleDocs(module: try SKModuleWrapper(module: module)) { (arrayWrapper, error) in
            response = arrayWrapper
            responseError = error
        }

        let dataWrapper = try handleXPC(response: response, error: responseError)
        #else
        let dataWrapper = try SourceKittenAdapter.moduleDocs(module: module)
        #endif

        return try dataWrapper.decodeData()
    }

    public func editorOpen(file: File) throws -> SKEditorOpen {
        #if XPC
        var response: SKDataWrapper?
        var responseError: SKXPCError?

        synchronousProxy.editorOpen(file: SKFileWrapper(file: file)) { (dataWrapper, error) in
            response = dataWrapper
            responseError = error
        }

        let dataWrapper = try handleXPC(response: response, error: responseError)
        #else
        let dataWrapper = try SourceKittenAdapter.editorOpen(file: file)
        #endif

        return try dataWrapper.decodeData()
    }

    public func syntaxMap(file: File) throws -> SyntaxMap {
        #if XPC
        var response: SKSyntaxMapWrapper?
        var responseError: SKXPCError?

        synchronousProxy.syntaxMap(file: SKFileWrapper(file: file)) { (syntaxMapWrapper, error) in
            response = syntaxMapWrapper
            responseError = error
        }

        return try handleXPC(response: response, error: responseError).syntaxMap
        #else
        return try SourceKittenAdapter.syntaxMap(file: file)
        #endif
    }

    public func swiftDocs(file: File, compilerArguments: [String]) throws -> SKSwiftDocs {
        #if XPC
        var response: SKDataWrapper?
        var responseError: SKXPCError?

        synchronousProxy.swiftDocs(file: SKFileWrapper(file: file),
                                   compilerArguments: compilerArguments) { (dataWrapper, error) in
                                    response = dataWrapper
                                    responseError = error
        }

        let dataWrapper = try handleXPC(response: response, error: responseError)
        #else
        let dataWrapper = try SourceKittenAdapter.swiftDocs(file: file, compilerArguments: compilerArguments)
        #endif

        return try dataWrapper.decodeData()
    }

    public func codeCompletion(file: File,
                               offset: Offset,
                               compilerArguments: [String]) throws -> SKCodeCompletion {
        #if XPC
        var response: SKDataWrapper?
        var responseError: SKXPCError?

        synchronousProxy.codeCompletion(file: SKFileWrapper(file: file),
                                        offset: offset,
                                        compilerArguments: compilerArguments) { (dataWrapper, error) in
                                            response = dataWrapper
                                            responseError = error
        }

        let dataWrapper = try handleXPC(response: response, error: responseError)
        #else
        let dataWrapper = try SourceKittenAdapter.codeCompletion(file: file,
                                                                 offset: offset,
                                                                 compilerArguments: compilerArguments)
        #endif

        return try dataWrapper.decodeData()
    }

    public func codeCompletionOpen(file: File,
                                   offset: Offset,
                                   options: SKCodeCompletionSession.Options?,
                                   compilerArguments: [String]) throws -> SKCodeCompletionSession.Response {
        #if XPC
        var encodedOptions: SKDataWrapper?

        if let options = options {
            encodedOptions = try SKDataWrapper(object: options)
        }

        var response: SKDataWrapper?
        var responseError: SKXPCError?

        synchronousProxy.codeCompletionOpen(file: SKFileWrapper(file: file),
                                            offset: offset,
                                            options: encodedOptions,
                                            compilerArguments: compilerArguments) { (dataWrapper, error) in
                                                response = dataWrapper
                                                responseError = error
        }

        let dataWrapper = try handleXPC(response: response, error: responseError)
        #else
        let dataWrapper = try SourceKittenAdapter.codeCompletionOpen(file: file,
                                                                     offset: offset,
                                                                     options: options,
                                                                     compilerArguments: compilerArguments)
        #endif

        let codeCompletion: SKCodeCompletion = try dataWrapper.decodeData()
        return SKCodeCompletionSession.Response(kind: .open,
                                               options: options,
                                               codeCompletion: codeCompletion)
    }

    public func codeCompletionUpdate(file: File,
                                     offset: Int,
                                     options: SKCodeCompletionSession.Options?)
                                     throws -> SKCodeCompletionSession.Response {
        #if XPC
        let encodedOptions = try SKDataWrapper(object: options)
        var response: SKDataWrapper?
        var responseError: SKXPCError?

        synchronousProxy.codeCompletionUpdate(name: file.name,
                                              offset: offset,
                                              options: encodedOptions) { (dataWrapper, error) in
                                                response = dataWrapper
                                                responseError = error
        }

        let dataWrapper = try handleXPC(response: response, error: responseError)
        #else
        let dataWrapper = try SourceKittenAdapter.codeCompletionUpdate(name: file.name,
                                                                       offset: offset,
                                                                       options: options)
        #endif

        let codeCompletion: SKCodeCompletion = try dataWrapper.decodeData()
        return SKCodeCompletionSession.Response(kind: .update,
                                               options: options,
                                               codeCompletion: codeCompletion)
    }

    public func codeCompletionClose(name: String, offset: Int) throws -> SKCodeCompletionSession.Response {
        #if XPC
        var responseError: SKXPCError?

        synchronousProxy.codeCompletionClose(name: name, offset: offset) { (error) in
            responseError = error
        }

        if let error = responseError {
            throw error.bridge
        }
        #else
        try SourceKittenAdapter.codeCompletionClose(name: name, offset: offset)
        #endif

        return SKCodeCompletionSession.Response(kind: .close, options: nil, codeCompletion: nil)
    }

    public func customYAML<T: Decodable>(_ yaml: String) throws -> T {
        #if XPC
        var response: SKDataWrapper?
        var responseError: SKXPCError?

        synchronousProxy.customYAML(yaml) { (dataWrapper, error) in
            response = dataWrapper
            responseError = error
        }

        let dataWrapper = try handleXPC(response: response, error: responseError)
        #else
        let dataWrapper = try SourceKittenAdapter.customYAML(yaml: yaml)
        #endif

        return try dataWrapper.decodeData()
    }

    public func xcRun(arguments: [String]) -> String? {
        #if XPC
        var response: String?

        synchronousProxy.xcRun(arguments: arguments) { (output) in
            response = output
        }

        return response
        #else
        return SourceKittenAdapter.xcRun(arguments: arguments)
        #endif
    }

    /// Run `xcodebuild clean build` along with any passed in build arguments.
    /// parameter arguments: Arguments to pass to `xcodebuild`.
    /// parameter path:      Path to run `xcodebuild` from.
    /// - returns: `xcodebuild`'s STDERR+STDOUT output combined.
    public func xcodeBuild(arguments: [String], currentDirectoryPath: String) -> String? {
        #if XPC
        var response: String?

        synchronousProxy.xcodeBuild(arguments: arguments, currentDirectoryPath: currentDirectoryPath) { (output) in
            response = output
        }

        return response
        #else
        return SourceKittenAdapter.xcodeBuild(arguments: arguments, currentDirectoryPath: currentDirectoryPath)
        #endif
    }

    public func executeBash(_ command: String,
                            currentDirectoryPath: String? = nil) -> String? {
        #if XPC
        var response: String?

        synchronousProxy.executeBash(command, currentDirectoryPath: currentDirectoryPath) { (output) in
                                        response = output
        }

        return response
        #else
        return SourceKittenAdapter.executeBash(command, currentDirectoryPath: currentDirectoryPath)
        #endif
    }

    public func executeShell(launchPath: String,
                             arguments: [String] = [],
                             currentDirectoryPath: String? = nil,
                             shouldPipeStandardError: Bool = false) -> String? {
        #if XPC
        var response: String?

        synchronousProxy.executeShell(launchPath: launchPath,
                                      arguments: arguments,
                                      currentDirectoryPath: currentDirectoryPath,
                                      shouldPipeStandardError: shouldPipeStandardError) { (output) in
                                        response = output
        }

        return response
        #else
        return SourceKittenAdapter.executeShell(launchPath: launchPath,
                                                arguments: arguments,
                                                currentDirectoryPath: currentDirectoryPath,
                                                shouldPipeStandardError: shouldPipeStandardError)
        #endif
    }

    // MARK: - Internal Helper Methods

    #if XPC
    func handleXPC<T>(response: T?, error: SKXPCError?) throws -> T {
        if let responseError = error {
            throw responseError.bridge
        } else if let response = response {
            return response
        } else {
            // No response nor error, so it crashed.
            throw SKError.sourceKittenCrashed
        }
    }
    #endif

}
