//
//  SKEntities.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 12/7/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

public struct SKEntities<Entity: SKEntity> where Entity: Equatable {

    // MARK: - Public Stored Properties

    public let entities: [Entity]

    // MARK: - Public Initializers

    public init(entities: [Entity]) {
        self.entities = entities.sorted(by: { $0.offset < $1.offset })
    }

}

// MARK: - Sequence Protocol

extension SKEntities: Sequence {

    public var first: Entity? {
        return entities.first
    }

    public var last: Entity? {
        return entities.last
    }

    public var count: Int {
        return entities.count
    }

    public func makeIterator() -> IndexingIterator<[Entity]> {
        return entities.makeIterator()
    }

    public func index(of entity: Entity) -> Int? {
        return entities.index(of: entity)
    }

    public subscript(index: Int) -> Entity {
        return entities[index]
    }

}

// MARK: - Codable Protocol

extension SKEntities: Codable {

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.init(entities: try container.decode())
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(contentsOf: entities)
    }

}

// MARK: - Equatable Protocol

extension SKEntities: Equatable {

    public static func == (lhs: SKEntities<Entity>, rhs: SKEntities<Entity>) -> Bool {
        return lhs.entities == rhs.entities
    }

}
