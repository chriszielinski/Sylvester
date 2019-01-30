//
//  SKBaseDocInfoEntity.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 1/28/19.
//  Copyright © 2019 Big Z Labs. All rights reserved.
//

/// Represents a structure of symbols (a class has its methods as sub-entities, etc.).
///
/// This includes the function parameters and their types as entities. Each entity refers to the range of the
/// original text via `offset + length` entries.
open class SKBaseEntity: NSObject, SKSequence {

    // MARK: - Internal Declarations

    public enum CodingKeys: String, CodingKey {
        case kind = "key.kind"
        case name = "key.name"
        case keyword = "key.keyword"
        case usr = "key.usr"
        case offset = "key.offset"
        case length = "key.length"
        case fullyAnnotatedDeclaration = "key.fully_annotated_decl"
        case docFullAsXML = "key.doc.full_as_xml"
        case inherits = "key.inherits"
        case genericRequirements = "key.generic_requirements"
        case genericParameters = "key.generic_params"
        case internalChildren = "key.entities"
    }

    // MARK: - Public Type Aliases

    public typealias Kind = SKDeclarationKind
    public typealias Inherit = SKInherit
    public typealias GenericRequirement = SKGenericRequirement
    public typealias GenericParameter = SKGenericParameter
    public typealias DecodingContainer = KeyedDecodingContainer<CodingKeys>

    // MARK: - Public Stored Properties

    /// The UID for the declaration or reference kind (function, class, etc.).
    public let kind: Kind
    /// The displayed name for the entity.
    public let name: String?
    /// The keyword identifying the entity.
    public let keyword: String?
    /// The Unified Symbol Resolution (USR) string for the entity.
    public let usr: String?
    /// the byte location of the entity.
    public let offset: Offset?
    /// The byte length of the entity.
    public let length: Int?
    /// The XML representing the entity, its Unified Symbol Resolution (USR), etc.
    public let fullyAnnotatedDeclaration: String?
    /// The XML representing the entity and its documentation.
    ///
    /// - Note: Only present when the entity is documented.
    public let docFullAsXML: String?
    /// The entities the entity inherits from.
    public let inherits: [Inherit]?
    /// The entity's generic requirements.
    public let genericRequirements: [GenericRequirement]?
    /// The entity's generic parameters.
    public let genericParameters: [GenericParameter]?

    // MARK: SKSequence Protocol

    public var index: Int?
    public var filePath: String?
    public weak var internalParent: SKBaseEntity?
    public var internalChildren: [SKBaseEntity]?

    // MARK: - Public Initializers

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        kind = try container.decode(forKey: .kind)
        name = try container.decodeIfPresent(forKey: .name)
        keyword = try container.decodeIfPresent(forKey: .keyword)
        usr = try container.decodeIfPresent(forKey: .usr)
        offset = try container.decodeIfPresent(forKey: .offset)
        length = try container.decodeIfPresent(forKey: .length)
        fullyAnnotatedDeclaration = try container.decodeIfPresent(forKey: .fullyAnnotatedDeclaration)
        docFullAsXML = try container.decodeIfPresent(forKey: .docFullAsXML)
        inherits = try container.decodeIfPresent(forKey: .inherits)
        genericRequirements = try container.decodeIfPresent(forKey: .genericRequirements)
        genericParameters = try container.decodeIfPresent(forKey: .genericParameters)

        super.init()

        internalChildren = try decodeChildren(from: container)
    }

    // MARK: - SKSequence Protocol Methods

    open class func iteratorClass<Entity>() -> SKPreOrderDFSIterator<Entity>.Type {
        return SKPreOrderDFSIterator.self
    }

    // MARK: - Children Decoding Methods

    /// A convenience method for decoding children entities of a specified type from a decoding container.
    ///
    /// - Parameters:
    ///   - type: The child type.
    ///   - container: The decoding container.
    /// - Returns: The children substructures decoded as a specified type.
    /// - Throws: A `DecodingError`.
    public func decodeChildren<Entity: SKBaseEntity>(_ type: Entity.Type, from container: DecodingContainer) throws
                                                    -> [Entity]? {
            return try container.decodeIfPresent([Entity].self, forKey: .internalChildren)
    }

    /// Decodes the children entities from a decoding container.
    ///
    /// If using a `SKBaseEntity` subclass, override this method and return the decoded children
    /// entities by calling `decodeChildren(_:from:)` with the respective subclass.
    ///
    /// For example:
    ///
    ///     override public func decodeChildren(from container: DecodingContainer) throws -> [SKBaseEntity]? {
    ///         return try decodeChildren(MyEntitySubclass.self, from: container)
    ///     }
    ///
    /// - Parameter container: The decoding container.
    /// - Returns: The children entities decoded as a specified type.
    /// - Throws: A `DecodingError`.
    open func decodeChildren(from container: DecodingContainer) throws -> [SKBaseEntity]? {
        return try decodeChildren(SKBaseEntity.self, from: container)
    }

    // MARK: - Overridden NSObject Methods

    open override func isEqual(_ object: Any?) -> Bool {
        guard let rhs = object as? SKBaseEntity
            else { return false }

        return offset == rhs.offset
            && length == rhs.length
            && kind == rhs.kind
            && name == rhs.name
            && keyword == rhs.keyword
            && usr == rhs.usr
            && fullyAnnotatedDeclaration == rhs.fullyAnnotatedDeclaration
            && docFullAsXML == rhs.docFullAsXML
            && inherits == rhs.inherits
            && genericRequirements == rhs.genericRequirements
            && genericParameters == rhs.genericParameters
            && internalChildren == rhs.internalChildren
    }

}

// MARK: - Optional Byte Range Convertible Protocol

extension SKBaseEntity: OptionalByteRangeConvertible {}

// MARK: - JSON Debug String Convertible Protocol

extension SKBaseEntity: JSONDebugStringConvertible {}
