//
//  SKRequestErrorWrapper.swift
//  SylvesterCommon 😼
//
//  Created by Chris Zielinski on 12/12/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

import SourceKittenFramework

@objc
public class SKRequestErrorWrapper: NSObject, NSSecureCoding {

    // MARK: - Internal Declarations

    enum CodingKeys: String, CodingKey {
        case errorCode
        case description
    }

    // MARK: - Public Static Computed Properties

    public class var supportsSecureCoding: Bool {
        return true
    }

    // MARK: - Public Stored Properties

    public let error: Request.Error

    // MARK: - Public Initializers

    public init(error: Request.Error) {
        self.error = error
    }

    public required init?(coder aDecoder: NSCoder) {
        let code = aDecoder.decodeInteger(forKey: CodingKeys.errorCode.rawValue)
        let description = aDecoder.decodeObject(of: NSString.self, forKey: CodingKeys.description.rawValue) as String?

        switch code {
        case 0:
            self.error = .connectionInterrupted(description)
        case 1:
            self.error = .invalid(description)
        case 2:
            self.error = .failed(description)
        case 3:
            self.error = .cancelled(description)
        default:
            self.error = .unknown(description)
        }
    }

    // MARK: - Coding Protocol

    public func encode(with aCoder: NSCoder) {
        let errorCode = (error as NSError).code
        aCoder.encode(errorCode, forKey: CodingKeys.errorCode.rawValue)
        aCoder.encode(error.description, forKey: CodingKeys.description.rawValue)
    }

}
