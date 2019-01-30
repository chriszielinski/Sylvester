//
//  File.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 12/8/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

import SourceKittenFramework

enum FileCodingKeys: String, CodingKey {
    case filePath
    case contents
}

public extension File {

    var name: String {
        if let filePath = path {
            return filePath
        }

        return String(abs(contents.hash))
    }

    /// A path to this file that can be used in SourceKit requests.
    ///
    /// Returns the file's path, if it has one. Otherwise, returns a unique filename.
    ///
    /// - Warning: The value returned will not be consistent for content-only `File`s (i.e. a new value is
    ///            generated each call).
    var sourceKitPath: String {
        return path ?? "\(UUID().uuidString).swift"
    }

}

extension File: Codable {

    public convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: FileCodingKeys.self)

        if container.contains(.filePath) {
            self.init(pathDeferringReading: try container.decode(forKey: .filePath))
        } else {
            self.init(contents: try container.decode(forKey: .contents))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: FileCodingKeys.self)

        if let filePath = path {
            try container.encode(filePath, forKey: .filePath)
        } else {
            try container.encode(contents, forKey: .contents)
        }
    }

}
