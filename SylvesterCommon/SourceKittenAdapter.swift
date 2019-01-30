//
//  SourceKittenAdapter.swift
//  SylvesterCommon 😼
//
//  Created by Chris Zielinski on 12/15/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

import SourceKittenFramework

public class SourceKittenAdapter {

    // MARK: - Module Methods

    public static func moduleInfo(xcodeBuildArguments: [String],
                                  name: String? = nil,
                                  in path: String) throws -> Module {
        guard let module = Module(xcodeBuildArguments: xcodeBuildArguments, name: name, inPath: path)
            else { throw SKError.sourceKitRequestFailed(.unknown("`Module` initialization failed.")) }
        return module
    }

    public static func moduleDocs(module: Module) throws -> SKDataWrapper {
        do {
            return try SKDataWrapper(object: module.docs)
        } catch {
            throw error.toSKError()
        }
    }

    // MARK: - Editor Methods

    public static func editorOpen(file: File) throws -> SKDataWrapper {
        let responseDictionary: [String: SourceKitRepresentable]

        do {
            responseDictionary = try Request.editorOpen(file: file).send()
        } catch let error as Request.Error {
            throw SKError.sourceKitRequestFailed(error)
        } catch {
            throw SKError.unknown(error: error)
        }

        return try SKDataWrapper(responseDictionary)
    }

    // MARK: - Syntax Methods

    public static func syntaxMap(file: File) throws -> SyntaxMap {
        do {
            return try SyntaxMap(file: file)
        } catch let error as Request.Error {
            throw SKError.sourceKitRequestFailed(error)
        } catch {
            throw SKError.unknown(error: error)
        }
    }

    // MARK: - Documentation Methods

    public static func swiftDocs(file: File, compilerArguments: [String]) throws -> SKDataWrapper {
        guard let swiftDocs = SwiftDocs(file: file, arguments: compilerArguments)
            else { throw SKError.sourceKitRequestFailed(Request.Error.unknown(nil)) }

        return try SKDataWrapper(object: swiftDocs)
    }

    public static func docInfo(file: File?, moduleName: String?, compilerArguments: [String]) throws -> SKDataWrapper {
        let request = Request.docInfo(file: file, moduleName: moduleName, compilerArguments: compilerArguments)
        let responseDictionary: [String: SourceKitRepresentable]

        do {
            responseDictionary = try Request.customRequest(request: request).send()
        } catch let error as Request.Error {
            throw SKError.sourceKitRequestFailed(error)
        } catch {
            throw SKError.unknown(error: error)
        }

        return try SKDataWrapper(responseDictionary)
    }

    // MARK: - Code Completion Methods

    public static func codeCompletion(file: File,
                                      offset: Int,
                                      compilerArguments: [String]) throws -> SKDataWrapper {
        let request = Request.codeCompletion(file: file, offset: offset, compilerArguments: compilerArguments)
        return try SKDataWrapper(customRequest(object: request))
    }

    public static func codeCompletionOpen(file: File,
                                          offset: Int,
                                          options: SKCodeCompletionSessionOptions?,
                                          compilerArguments: [String]) throws -> SKDataWrapper {
        let openRequest = Request.codeCompletionOpen(file: file,
                                                     offset: offset,
                                                     options: options,
                                                     compilerArguments: compilerArguments)
        return try SKDataWrapper(customRequest(object: openRequest))
    }

    public static func codeCompletionUpdate(name: String,
                                            offset: Int,
                                            options: SKCodeCompletionSessionOptions?) throws -> SKDataWrapper {
        let updateRequest = Request.codeCompletionUpdate(name: name, offset: offset, options: options)
        return try SKDataWrapper(customRequest(object: updateRequest))
    }

    public static func codeCompletionClose(name: String, offset: Int) throws {
        let closeRequest = Request.codeCompletionClose(name: name, offset: offset)
        _ = try customRequest(object: closeRequest)
    }

    // MARK: - Custom Request Methods

    public static func customYAML(yaml: String) throws -> SKDataWrapper {
        let responseDictionary: [String: SourceKitRepresentable]

        do {
            responseDictionary = try Request.yamlRequest(yaml: yaml).send()
        } catch let error as Request.Error {
            throw SKError.sourceKitRequestFailed(error)
        } catch {
            throw SKError.unknown(error: error)
        }

        return try SKDataWrapper(responseDictionary)
    }

    static func customRequest(object: SourceKitObject) throws -> [String: SourceKitRepresentable] {
        do {
            return try Request.customRequest(request: object).send()
        } catch let error as Request.Error {
            throw SKError.sourceKitRequestFailed(error)
        } catch {
            throw SKError.unknown(error: error)
        }
    }

    // MARK: - Subprocess Methods

    public static func xcRun(arguments: [String]) -> String? {
        var subprocess = SKSubprocess(executableURL: URL(fileURLWithPath: "/usr/bin/xcrun", isDirectory: false))
        subprocess.arguments = arguments
        return launch(subprocess: subprocess)
    }

    public static func xcodeBuild(arguments: [String], currentDirectoryURL: URL) -> String? {
        var subprocess = SKSubprocess(executableURL: URL(fileURLWithPath: "/usr/bin/xcodebuild", isDirectory: false))
        subprocess.arguments = arguments + [
            "clean",
            "build",
            "CODE_SIGN_IDENTITY=",
            "CODE_SIGNING_REQUIRED=NO"
        ]
        subprocess.currentDirectoryURL = currentDirectoryURL
        subprocess.shouldPipeStandardError = true
        return launch(subprocess: subprocess)
    }

    public static func executeBash(_ command: String, currentDirectoryURL: URL? = nil) -> String? {
        var subprocess = SKSubprocess(executableURL: URL(fileURLWithPath: "/bin/bash", isDirectory: false))
        subprocess.arguments = ["-c", command]
        subprocess.currentDirectoryURL = currentDirectoryURL
        return launch(subprocess: subprocess)
    }

    public static func launch(subprocess: SKSubprocess) -> String? {
        let process = subprocess.process

        let pipe = Pipe()
        process.standardOutput = pipe
        if subprocess.shouldPipeStandardError {
            process.standardError = pipe
        }

        process.launch()

        let file = pipe.fileHandleForReading
        defer { file.closeFile() }

        let data = file.readDataToEndOfFile()
        return String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines)
    }

}
