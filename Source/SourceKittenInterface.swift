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
    private static func handleXPC(error: Error) {
        Utilities.print(error: error)
        shared.xpcError = error
    }
    #endif

    // MARK: - Private Stored Properties

    #if XPC
    private let xpcConnection: NSXPCConnection
    private let synchronousProxy: SylvesterXPCProtocol
    private var xpcError: Error?
    #endif

    // MARK: - Private Initializers

    private init() {
        #if XPC
        xpcConnection = NSXPCConnection(serviceName: "com.bigzlabs.SylvesterXPCService")
        xpcConnection.remoteObjectInterface = NSXPCInterface(with: SylvesterXPCProtocol.self)
        xpcConnection.resume()

        synchronousProxy = xpcConnection
            .synchronousRemoteObjectProxyWithErrorHandler(SourceKittenInterface.handleXPC(error:))
            // swiftlint:disable:next force_cast
            as! SylvesterXPCProtocol
        #endif
    }

    // MARK: - Public SourceKitten Interface Methods
    // MARK: Module Methods

    /// A _SourceKitten_ module info request.
    ///
    /// - Parameters:
    ///   - xcodeBuildArguments: The arguments necessary pass in to `xcodebuild` to build this module.
    ///   - name: The module name. Will be parsed from `xcodebuild` output if nil.
    ///   - path: The path to run `xcodebuild` from. Uses current path by default.
    /// - Returns: The resulting `Module`.
    /// - Throws: A `SKError`, if an error occurs.
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

    /// A _SourceKitten_ module docs request.
    ///
    /// - Parameter module: The `Module` to get the module docs for.
    /// - Returns: An array of the specified `SwiftDocs` type.
    /// - Throws: A `SKError`, if an error occurs.
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

    // MARK: Editor Methods

    /// A _SourceKit_ editor open request.
    ///
    /// - Parameter file: The source file to open.
    /// - Returns: The resulting `SKEditorOpen`.
    /// - Throws: A `SKError`, if an error occurs.
    public func editorOpen<Substructure: SKSubstructure>(file: File) throws -> SKGenericEditorOpen<Substructure> {
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

    // MARK: Syntax Methods

    /// A _SourceKitten_ syntax map request.
    ///
    /// - Parameter file: The source file to get a syntax map for.
    /// - Returns: The resulting `SyntaxMap`.
    /// - Throws: A `SKError`, if an error occurs.
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

    // MARK: Documentation Methods

    /// A _SourceKitten_ swift documentation request.
    ///
    /// - Parameters:
    ///   - file: The source file to gather documentation for.
    ///   - compilerArguments: The compiler arguments used to build the module (e.g `["-sdk", "/path/to/sdk"]`).
    /// - Returns: The resulting `SKSwiftDocs`.
    /// - Throws: A `SKError`, if an error occurs.
    public func swiftDocs<Substructure: SKSubstructure>(file: File, compilerArguments: [String]) throws -> SKGenericSwiftDocs<Substructure> {
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

    // MARK: Code Completion Methods

    /// A _SourceKit_ code completion request.
    ///
    /// - Parameters:
    ///   - file: The `File` of the code completion.
    ///   - offset: The byte offset of the code completion point inside the source contents.
    ///   - compilerArguments: The compiler arguments used to build the module (e.g `["-sdk", "/path/to/sdk"]`).
    /// - Returns: The resulting `SKCodeCompletion`.
    /// - Throws: A `SKError`, if an error occurs.
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

    /// A _SourceKit_ code completion open request.
    ///
    /// - Parameters:
    ///   - file: The `File` of the code completion session.
    ///   - offset: The byte offset of the code completion point inside the session's source contents.
    ///   - options: The `SKCodeCompletionSession.Options` of the open request.
    ///   - compilerArguments: The compiler arguments used to build the module (e.g `["-sdk", "/path/to/sdk"]`).
    /// - Returns: The request's `SKCodeCompletionSession.Response`.
    /// - Throws: A `SKError`, if an error occurs.
    public func codeCompletionOpen(file: File,
                                   offset: Offset,
                                   options: SKCodeCompletionSession.Options?,
                                   compilerArguments: [String]) throws -> SKCodeCompletionSession.Response {
        #if XPC
        var encodedOptions: SKDataWrapper?
        var response: SKDataWrapper?
        var responseError: SKXPCError?

        if let options = options {
            encodedOptions = try SKDataWrapper(object: options)
        }

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

        return SKCodeCompletionSession.Response(kind: .open,
                                               options: options,
                                               codeCompletion: try dataWrapper.decodeData())
    }

    /// A _SourceKit_ code completion update request.
    ///
    /// - Parameters:
    ///   - file: The `File` of the open code completion session.
    ///   - offset: The byte offset of the code completion point inside the session's source contents.
    ///   - options: The `SKCodeCompletionSession.Options` of the update request.
    /// - Returns: The request's `SKCodeCompletionSession.Response`.
    /// - Throws: A `SKError`, if an error occurs.
    public func codeCompletionUpdate(file: File,
                                     offset: Int,
                                     options: SKCodeCompletionSession.Options?)
                                     throws -> SKCodeCompletionSession.Response {
        #if XPC
        var response: SKDataWrapper?
        var responseError: SKXPCError?

        synchronousProxy.codeCompletionUpdate(name: file.name,
                                              offset: offset,
                                              options: try SKDataWrapper(object: options)) { (dataWrapper, error) in
                                                response = dataWrapper
                                                responseError = error
        }

        let dataWrapper = try handleXPC(response: response, error: responseError)
        #else
        let dataWrapper = try SourceKittenAdapter.codeCompletionUpdate(name: file.name,
                                                                       offset: offset,
                                                                       options: options)
        #endif

        return SKCodeCompletionSession.Response(kind: .update,
                                                options: options,
                                                codeCompletion: try dataWrapper.decodeData())
    }

    /// A _SourceKit_ code completion close request.
    ///
    /// - Parameters:
    ///   - name: The name of the open code completion session.
    ///   - offset: The byte offset of the code completion point inside the session's source contents.
    /// - Returns: The request's `SKCodeCompletionSession.Response`.
    /// - Throws: A `SKError`, if an error occurs.
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

    // MARK: Custom Request Methods

    /// A custom YAML _SourceKit_ request.
    ///
    /// - Parameter yaml: The _SourceKit_ request in YAML representation.
    /// - Returns: The decoded response as the specified type.
    /// - Throws: A `SKError`, if an error occurs.
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

    // MARK: Subprocess Methods

    /// Run `xcrun` with the specified arguments.
    ///
    /// - Parameter arguments: The arguments to pass to `xcrun`.
    /// - Returns: The `xcrun`'s standard out output.
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
    ///
    /// - Parameters:
    ///   - arguments: The arguments to pass to `xcodebuild`.
    ///   - currentDirectoryPath: The path to run `xcodebuild` from.
    /// - Returns: The `xcodebuild`'s combined standard error and standard out output.
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

    /// Executes a Bash command.
    ///
    /// - Parameters:
    ///   - command: The command to execute.
    ///   - currentDirectoryPath: The path to run the Bash command from.
    /// - Returns: The Bash command's standard out output.
    public func executeBash(command: String,
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

    /// Launches another program as a subprocess.
    ///
    /// - Parameters:
    ///   - launchPath: The path to the receiver’s executable.
    ///   - arguments: The command arguments that should be used to launch the executable.
    ///   - currentDirectoryPath: The current directory for the receiver. If `nil`, the current directory is
    ///                           inherited from the process that created the receiver.
    ///   - shouldPipeStandardError: Whether the standard error should also be piped to the output.
    /// - Returns: The executable's standard out (and standard error, if `shouldPipeStandardError` is true) output.
    public func launchSubprocess(launchPath: String,
                                 arguments: [String] = [],
                                 currentDirectoryPath: String? = nil,
                                 shouldPipeStandardError: Bool = false) -> String? {
        #if XPC
        var response: String?

        synchronousProxy.launchSubprocess(launchPath: launchPath,
                                          arguments: arguments,
                                          currentDirectoryPath: currentDirectoryPath,
                                          shouldPipeStandardError: shouldPipeStandardError) { (output) in
                                            response = output
        }

        return response
        #else
        return SourceKittenAdapter.launchSubprocess(launchPath: launchPath,
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
            if let xpcError = xpcError as NSError?, xpcError.code != 4097 {
                throw SKError.unknown(error: xpcError)
            }
            throw SKError.sourceKittenCrashed
        }
    }
    #endif

}
