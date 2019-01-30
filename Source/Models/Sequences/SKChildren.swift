//
//  SKChildren.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 8/16/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

open class SKChildren<Child: SKSequence>: Sequence {

    // MARK: - Public Stored Properties

    public var elements: [Child]

    // MARK: - Public Computed Properties

    public var first: Child? {
        return elements.first
    }

    public var last: Child? {
        return elements.last
    }

    public var count: Int {
        return elements.count
    }

    // MARK: - Public Initializers

    public init(elements: [Child]) {
        self.elements = elements
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        elements = try container.decode()
    }

    // MARK: - Internal Helper Methods

    @discardableResult
    func resolve(parent: Child? = nil, index: Int, filePath: String?) -> Int {
        return elements.resolve(parent: parent, index: index, filePath: filePath)
    }

    // MARK: - Sequence Protocol

    open func makeIterator() -> SKPreOrderDFSIterator<Child> {
        return Child.iteratorClass().init(elements)
    }

    public func index(of substructure: Child) -> Int? {
        return elements.index(of: substructure)
    }

    @discardableResult
    public func remove(substructure: Child) -> Bool {
        guard let index = elements.index(of: substructure)
            else { return false }
        elements.remove(at: index)
        return true
    }

    public subscript(index: Int) -> Child {
        get { return elements[index] }
        set { elements[index] = newValue }
    }

}

// MARK: - Codable Protocol

extension SKChildren: Codable {

    open func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(contentsOf: elements)
    }

}

// MARK: - Equatable Protocol

extension SKChildren: Equatable {

    public static func == (lhs: SKChildren, rhs: SKChildren) -> Bool {
        return lhs.elements == rhs.elements
    }

}

// MARK: - Custom Debug String Convertible Protocol

extension SKChildren: CustomDebugStringConvertible {

    public var debugDescription: String {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(elements)
            return String(data: data, encoding: .utf8) ?? "Error: Failed to convert data into Unicode characters."
        } catch {
            return (error as NSError).description
        }
    }

}
