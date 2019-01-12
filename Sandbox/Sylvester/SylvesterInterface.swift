//
//  SylvesterInterface.swift
//  Sandbox
//
//  Created by Chris Zielinski on 12/15/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

import SylvesterXPC
import SourceKittenFramework

public class SylvesterInterface {

    public static func skModule(xcodeBuildArguments: [String] = [],
                                name: String? = nil,
                                in path: String) throws -> SKModule {
        return try SKModule(xcodeBuildArguments: xcodeBuildArguments, name: name, inPath: path)
    }

    public static func editorOpen(file: File) throws -> SKEditorOpen {
        return try SKEditorOpen(file: file)
    }

    public static func customEditorOpen(file: File) throws -> CustomEditorOpen {
        return try CustomEditorOpen(file: file)
    }

    public static func syntaxMap(file: File) throws -> SKSyntaxMap {
        return try SKSyntaxMap(file: file)
    }

    public static func swiftDocs(file: File, compilerArguments: [String]) throws -> SKSwiftDocs {
        return try SKSwiftDocs(file: file, compilerArguments: compilerArguments)
    }

    public static func customSwiftDocs(file: File, compilerArguments: [String]) throws -> CustomSwiftDocs {
        return try CustomSwiftDocs(file: file, compilerArguments: compilerArguments)
    }

    public static func codeCompletion(file: File,
                                      offset: Int,
                                      compilerArguments: [String]) throws -> SKCodeCompletion {
        return try SKCodeCompletion(file: file, offset: offset, compilerArguments: compilerArguments)
    }

    public static func codeCompletionSession(file: File,
                                             offset: Int,
                                             compilerArguments: [String]) -> SKCodeCompletionSession {
        return SKCodeCompletionSession(file: file, offset: offset, compilerArguments: compilerArguments)
    }

    public static func customYAML(yaml: String) throws -> String {
        return try SourceKittenInterface.shared.customYAML(yaml)
    }

    public static func xcRun(arguments: [String]) -> String? {
        return SourceKittenInterface.shared.xcRun(arguments: arguments)
    }

    public static func xcodeBuild(arguments: [String], currentDirectoryPath: String) -> String? {
        return SourceKittenInterface.shared.xcodeBuild(arguments: arguments,
                                                       currentDirectoryPath: currentDirectoryPath)
    }

    public static func executeBash(command: String, currentDirectoryPath: String? = nil) -> String? {
        return SourceKittenInterface.shared.executeBash(command: command, currentDirectoryPath: currentDirectoryPath)
    }

    public static func executeShell(launchPath: String,
                                    arguments: [String] = [],
                                    currentDirectoryPath: String? = nil,
                                    shouldPipeStandardError: Bool = false) -> String? {
        return SourceKittenInterface.shared.executeShell(launchPath: launchPath,
                                                         arguments: arguments,
                                                         currentDirectoryPath: currentDirectoryPath,
                                                         shouldPipeStandardError: shouldPipeStandardError)
    }

}
