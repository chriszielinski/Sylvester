//
//  Requests.swift
//  SylvesterCommon 😼
//
//  Created by Chris Zielinski on 12/11/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

import SourceKittenFramework

public extension Request {

    static func codeCompletion(file: File,
                               offset: Int,
                               compilerArguments: [String]) -> SourceKitObject {
        let path = file.sourceKitPath
        var arguments = compilerArguments

        if !compilerArguments.contains("-c") {
            arguments.insert(contentsOf: ["-c", path], at: 0)
        }

        let request: SourceKitObject = [
            "key.request": UID("source.request.codecomplete"),
            "key.sourcefile": path,
            "key.compilerargs": arguments,
            "key.offset": Int64(offset),
            "key.name": file.name,
            "key.toolchains": [
                "com.apple.dt.toolchain.XcodeDefault"
            ]
        ]

        if file.path == nil {
            request.updateValue(file.contents, forKey: "key.sourcetext")
        }

        return request
    }

    static func codeCompletionOpen(file: File,
                                   offset: Int,
                                   options: SKCodeCompletionSessionOptions?,
                                   compilerArguments: [String]) -> SourceKitObject {
        let path = file.sourceKitPath
        var arguments = compilerArguments

        if !compilerArguments.contains("-c") {
            arguments.insert(contentsOf: ["-c", path], at: 0)
        }

        let request: SourceKitObject = [
            "key.request": UID("source.request.codecomplete.open"),
            "key.sourcefile": path,
            "key.compilerargs": arguments,
            "key.offset": Int64(offset),
            "key.name": file.name,
            "key.toolchains": [
                "com.apple.dt.toolchain.XcodeDefault"
            ]
        ]

        if file.path == nil {
            request.updateValue(file.contents, forKey: "key.sourcetext")
        }

        if let options = options {
            request.updateValue(options, forKey: "key.codecomplete.options")
        }

        return request
    }

    static func codeCompletionUpdate(name: String,
                                     offset: Int,
                                     options: SKCodeCompletionSessionOptions?) -> SourceKitObject {
        let request: SourceKitObject = [
            "key.request": UID("source.request.codecomplete.update"),
            "key.offset": Int64(offset),
            "key.name": name
        ]

        if let options = options {
            request.updateValue(options, forKey: "key.codecomplete.options")
        }

        return request
    }

    static func codeCompletionClose(name: String, offset: Int) -> SourceKitObject {
        return [
            "key.request": UID("source.request.codecomplete.close"),
            "key.offset": Int64(offset),
            "key.name": name
        ]
    }

}
