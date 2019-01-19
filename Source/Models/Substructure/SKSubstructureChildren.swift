//
//  SKSubstructureChildren.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 8/16/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

open class SKSubstructureChildren<Substructure: SKBaseSubstructure>: Sequence {

    // MARK: - Public Stored Properties

    public var substructures: [Substructure]

    // MARK: - Public Computed Properties

    public var first: Substructure? {
        return substructures.first
    }

    public var last: Substructure? {
        return substructures.last
    }

    public var count: Int {
        return substructures.count
    }

    // MARK: - Public Initializers

    public init(substructures: [Substructure]) {
        self.substructures = substructures
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.substructures = try container.decode()
    }

    // MARK: - Internal Helper Methods

    @discardableResult
    func resolve(parent: Substructure? = nil, index: Int, filePath: String?) -> Int {
        return substructures.resolve(parent: parent, index: index, filePath: filePath)
    }

    // MARK: - Sequence Protocol

    open func makeIterator() -> SKSubstructureIterator<Substructure> {
        return Substructure.iteratorClass().init(substructures)
    }

    public func index(of substructure: Substructure) -> Int? {
        return substructures.index(of: substructure)
    }

    @discardableResult
    public func remove(substructure: Substructure) -> Bool {
        guard let index = substructures.index(of: substructure)
            else { return false }
        substructures.remove(at: index)
        return true
    }

    public subscript(index: Int) -> Substructure {
        get { return substructures[index] }
        set { substructures[index] = newValue }
    }

}

// MARK: - Codable Protocol

extension SKSubstructureChildren: Codable {

    open func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(contentsOf: substructures)
    }

}

// MARK: - Equatable Protocol

extension SKSubstructureChildren: Equatable {

    public static func == (lhs: SKSubstructureChildren, rhs: SKSubstructureChildren) -> Bool {
        return lhs.substructures == rhs.substructures
    }

}

// MARK: - Custom Debug String Convertible Protocol

extension SKSubstructureChildren: CustomDebugStringConvertible {

    public var debugDescription: String {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(substructures)
            return String(data: data, encoding: .utf8) ?? "Error: Failed to convert data into Unicode characters."
        } catch {
            return (error as NSError).description
        }
    }

}
