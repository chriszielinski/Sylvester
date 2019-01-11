//
//  SKSyntaxMapWrapper.swift
//  SylvesterCommon 😼
//
//  Created by Chris Zielinski on 12/11/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

import SourceKittenFramework

@objc
public class SKSyntaxMapWrapper: NSObject, NSSecureCoding {

    // MARK: - Internal Declarations

    enum CodingKeys: String, CodingKey {
        case syntaxMap
    }

    // MARK: - Public Static Computed Properties

    public class var supportsSecureCoding: Bool {
        return true
    }

    // MARK: - Public Stored Properties

    public let syntaxMap: SyntaxMap

    // MARK: - Public Initializers

    public init(syntaxMap: SyntaxMap) {
        self.syntaxMap = syntaxMap
    }

    public required convenience init?(coder aDecoder: NSCoder) {
        guard aDecoder.containsValue(forKey: CodingKeys.syntaxMap.rawValue)
            else { return nil }

        guard let data = aDecoder.decodeObject(of: NSData.self, forKey: CodingKeys.syntaxMap.rawValue)
            else { return nil }

        do {
            self.init(syntaxMap: try JSONDecoder().decode(SyntaxMap.self, from: data as Data))
        } catch {
            print(error)
            return nil
        }
    }

    // MARK: - Coding Protocol

    public func encode(with aCoder: NSCoder) {
        do {
            let jsonEncodedData = try JSONEncoder().encode(syntaxMap)
            aCoder.encode(jsonEncodedData, forKey: CodingKeys.syntaxMap.rawValue)
        } catch {
            print(error)
        }
    }

}
