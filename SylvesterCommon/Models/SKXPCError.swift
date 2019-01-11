//
//  SKXPCError.swift
//  SylvesterCommon 😼
//
//  Created by Chris Zielinski on 12/12/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

import SourceKittenFramework

@objc
public class SKXPCError: NSError {

    // MARK: - Internal Declarations

    enum Kind: Int, Codable {
        case sourceKitRequestFailed
        case jsonDecodingFailed
        case jsonEncodingFailed
        /// Thrown when encoding a JSON string to `Data` fails.
        case jsonDataEncodingFailed
        #if XPC
        case sourceKittenCrashed
        #endif
        case unknown
    }

    enum CodingKeys: String, CodingKey {
        case kind
        case errorDescription
        case sourceKittenError
    }

    // MARK: - Public Static Computed Properties

    public static override var supportsSecureCoding: Bool {
        return true
    }

    // MARK: - Internal Stored Properties

    let kind: Kind
    let errorDescription: String?
    let sourceKittenError: SKRequestErrorWrapper?

    // MARK: - Public Computed Properties

    public var bridge: SKError {
        switch kind {
        case .sourceKitRequestFailed:
            assert(sourceKittenError != nil,
                   "`sourceKittenError` should not be nil.")
            return SKError.sourceKitRequestFailed(sourceKittenError?.error ?? Request.Error.unknown(nil))
        case .jsonDecodingFailed:
            assert(errorDescription != nil,
                   "The error description should not be nil.")
            return SKError.jsonDecodingFailed(errorDescription ?? "")
        case .jsonEncodingFailed:
            assert(errorDescription != nil,
                   "The error description should not be nil.")
            return SKError.jsonEncodingFailed(errorDescription ?? "")
        case .jsonDataEncodingFailed:
            return SKError.jsonDataEncodingFailed
        #if XPC
        case .sourceKittenCrashed:
            return SKError.sourceKittenCrashed
        #endif
        case .unknown:
            assert(errorDescription != nil,
                   "The error description should not be nil.")
            return SKError.unknown(errorDescription ?? "")
        }
    }

    // MARK: - Internal Initializers

    init(_ kind: Kind, errorDescription: String? = nil) {
        self.kind = kind
        self.errorDescription = errorDescription
        self.sourceKittenError = nil

        super.init(domain: "com.bigzlabs.sylvester", code: 0)
    }

    init(sourceKittenError: SKRequestErrorWrapper) {
        self.kind = .sourceKitRequestFailed
        self.errorDescription = nil
        self.sourceKittenError = sourceKittenError

        super.init(domain: "com.bigzlabs.sylvester", code: 0)
    }

    required convenience init?(coder aDecoder: NSCoder) {
        guard let kind = Kind(rawValue: aDecoder.decodeInteger(forKey: CodingKeys.kind.rawValue)) else {
            print("Failed to create `Kind` from raw value.")
            return nil
        }

        if aDecoder.containsValue(forKey: CodingKeys.sourceKittenError.rawValue) {
            guard let error = aDecoder.decodeObject(of: SKRequestErrorWrapper.self,
                                                    forKey: CodingKeys.sourceKittenError.rawValue)
                else { return nil }

            self.init(sourceKittenError: error)
        } else {
            let description = aDecoder.decodeObject(of: NSString.self,
                                                    forKey: CodingKeys.errorDescription.rawValue)
            self.init(kind, errorDescription: description as String?)
        }
    }

    // MARK: - Public Initializers

    public convenience init(error: SKError) {
        switch error {
        case .sourceKitRequestFailed(let error):
            self.init(sourceKittenError: SKRequestErrorWrapper(error: error))
        case .jsonDecodingFailed(let errorDescription):
            self.init(.jsonDecodingFailed, errorDescription: errorDescription)
        case .jsonEncodingFailed(let errorDescription):
            self.init(.jsonEncodingFailed, errorDescription: errorDescription)
        case .jsonDataEncodingFailed:
            self.init(.jsonDataEncodingFailed)
            #if XPC
        case .sourceKittenCrashed:
            self.init(.sourceKittenCrashed)
            #endif
        case .unknown(let errorDescription):
            self.init(.unknown, errorDescription: errorDescription)
        }
    }

    // MARK: - Coding Protocol

    override public func encode(with aCoder: NSCoder) {
        aCoder.encode(kind.rawValue, forKey: CodingKeys.kind.rawValue)

        if let requestError = sourceKittenError {
            aCoder.encode(requestError, forKey: CodingKeys.sourceKittenError.rawValue)
        } else if let description = errorDescription {
            aCoder.encode(description as NSString, forKey: CodingKeys.errorDescription.rawValue)
        }
    }

    // MARK: - Public Static Convenience Initializers

    static public func sourceKitRequestFailed(_ error: Request.Error) -> SKXPCError {
        return SKXPCError(sourceKittenError: SKRequestErrorWrapper(error: error))
    }

    static public func jsonDecodingFailed(_ error: DecodingError) -> SKXPCError {
        return SKXPCError(.jsonDecodingFailed, errorDescription: (error as NSError).description)
    }

    static public func jsonEncodingFailed(_ error: EncodingError) -> SKXPCError {
        return SKXPCError(.jsonEncodingFailed, errorDescription: (error as NSError).description)
    }

    static public func jsonDataEncodingFailed() -> SKXPCError {
        return SKXPCError(.jsonDataEncodingFailed)
    }

    #if XPC
    static public func sourceKittenCrashed() -> SKXPCError {
        return SKXPCError(.sourceKittenCrashed)
    }
    #endif

    static public func unknown(_ error: Error) -> SKXPCError {
        return SKXPCError(.unknown, errorDescription: (error as NSError).description)
    }

}
