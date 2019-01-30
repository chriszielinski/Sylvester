//
//  SwiftDocs.swift
//  SylvesterCommon
//
//  Created by Chris Zielinski on 1/14/19.
//  Copyright © 2019 Big Z Labs. All rights reserved.
//

import SourceKittenFramework

public enum SwiftDocsCodingKey: String, CodingKey {
    case file
    case response
}

extension SwiftDocs: Encodable {

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: SwiftDocsCodingKey.self)
        try container.encode(file, forKey: .file)

        guard JSONSerialization.isValidJSONObject(docsDictionary),
            let data = try? JSONSerialization.data(withJSONObject: docsDictionary)
            else { throw SKError.jsonDataEncodingFailed }
        try container.encode(data, forKey: .response)
    }

}
