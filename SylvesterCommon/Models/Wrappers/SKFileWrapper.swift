//
//  SKFileWrapper.swift
//  SylvesterCommon 😼
//
//  Created by Chris Zielinski on 12/11/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

import SourceKittenFramework

@objc
public class SKFileWrapper: NSObject, NSSecureCoding {

    // MARK: - Internal Declarations

    enum CodingKeys: String, CodingKey {
        case data
    }

    // MARK: - Public Static Computed Properties

    public class var supportsSecureCoding: Bool {
        return true
    }

    // MARK: - Public Stored Properties

    public let file: File

    // MARK: - Public Initializers

    public init(file: File) {
        self.file = file
    }

    required public convenience init?(coder aDecoder: NSCoder) {
        guard let jsonEncodedData = aDecoder.decodeObject(of: NSData.self, forKey: CodingKeys.data.rawValue)
            else { return nil }

        do {
            self.init(file: try JSONDecoder().decode(File.self, from: jsonEncodedData as Data))
        } catch {
            print(error)
            return nil
        }
    }

    // MARK: - Coding Protocol

    public func encode(with aCoder: NSCoder) {
        do {
            let data = try JSONEncoder().encode(file)
            aCoder.encode(data as NSData, forKey: CodingKeys.data.rawValue)
        } catch {
            print(error)
        }
    }

}
