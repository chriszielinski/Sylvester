//
//  Module.swift
//  SylvesterCommon 😼
//
//  Created by Chris Zielinski on 12/12/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

import SourceKittenFramework

enum ModuleCodingKeys: String, CodingKey {
    case name
    case compilerArguments
}

public extension Module {

    var sdkPath: String? {
        return value(of: "-sdk")
    }

    var target: String? {
        return value(of: "-target")
    }

    func value(of compilerArgument: String) -> String? {
        guard let index = compilerArguments.firstIndex(of: compilerArgument),
            // Make sure the value exists.
            index + 1 < compilerArguments.count
            else { return nil }
        return compilerArguments[index + 1]
    }

}

extension Module: Codable {

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ModuleCodingKeys.self)

        let name: String = try container.decode(forKey: .name)
        let compilerArguments: [String] = try container.decode(forKey: .compilerArguments)

        self.init(name: name, compilerArguments: compilerArguments)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: ModuleCodingKeys.self)

        try container.encode(name, forKey: .name)
        try container.encode(compilerArguments, forKey: .compilerArguments)
    }

}

extension Module: Equatable {

    public static func == (lhs: Module, rhs: Module) -> Bool {
        return lhs.name == rhs.name
            && lhs.compilerArguments == rhs.compilerArguments
            && lhs.sourceFiles == rhs.sourceFiles
    }

}
