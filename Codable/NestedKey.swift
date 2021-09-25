//
//  NestedKey.swift
//  Codable
//
//  Created by Anil Goktas on 9/25/21.
//

import Foundation

struct AnyCodingKey: CodingKey {
    private(set) var stringValue: String
    private(set) var intValue: Int?
    
    init(intValue: Int) {
        self.intValue = intValue
        self.stringValue = "\(intValue)"
    }
    init(stringValue: String) {
        self.intValue = nil
        self.stringValue = stringValue
    }
    init(_ int: Int) {
        self.init(intValue: int)
    }
    init(_ string: String) {
        self.init(stringValue: string)
    }
    init<T: CodingKey>(_ key: T) {
        self.stringValue = key.stringValue
        self.intValue = key.intValue
    }
}

/// - Note: [Source](https://twitter.com/IanKay/status/1293952365205184513)
/// [Other Source](https://gist.github.com/IanKeen/9e77041c386cd5ba0128330d6149c5a4)
/// Nested for loops are very slow. Check `NestedKeyTests` for comparison.
public protocol NestedCodingKey: CodingKey {
    var nestedKeys: [String] { get }
}

@propertyWrapper
public struct NestedKey<T: Codable>: Codable {
    public var wrappedValue: T

    public init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
    }

    public init(from decoder: Decoder) throws {
        let codingKey = decoder.codingPath.last!

        guard let key = codingKey as? NestedCodingKey else {
            throw DecodingError.keyNotFound(
                codingKey,
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "CodingKeys must conform to NestedCodingKey"
                )
            )
        }
        
        let container = try key.nestedKeys
            .dropFirst()
            .dropLast()
            .reduce(decoder.container(keyedBy: AnyCodingKey.self))
        { container, key in
            try container.nestedContainer(keyedBy: AnyCodingKey.self, forKey: AnyCodingKey(key))
        }
        
        let last = key.nestedKeys.last!
        self.wrappedValue = try container.decode(T.self, forKey: AnyCodingKey(last))
    }
    
    public func encode(to encoder: Encoder) throws {
        let codingKey = encoder.codingPath.last!
        
        guard let key = codingKey as? NestedCodingKey else {
            throw EncodingError.invalidValue(
                codingKey,
                EncodingError.Context(
                    codingPath: encoder.codingPath,
                    debugDescription: "CodingKeys must conform to NestedCodingKey"
                )
            )
        }
        
        var container = encoder.container(keyedBy: AnyCodingKey.self)
        
        for key in key.nestedKeys.dropFirst().dropLast() {
            container = container.nestedContainer(keyedBy: AnyCodingKey.self, forKey: AnyCodingKey(key))
        }
        
        let last = key.nestedKeys.last!
        try container.encode(wrappedValue, forKey: AnyCodingKey(last))
    }
}

extension NestedKey: Equatable where T: Equatable { }

extension KeyedDecodingContainer {
    public func decode<T>(
        _ type: NestedKey<T?>.Type,
        forKey key: KeyedDecodingContainer<K>.Key
    ) throws -> NestedKey<T?> {
        NestedKey<T?>(wrappedValue: try? decode(NestedKey<T>.self, forKey: key).wrappedValue)
    }
}

extension NestedCodingKey where Self: RawRepresentable, RawValue == String {
    public init?(stringValue: String) { self.init(rawValue: stringValue) }
    public init?(intValue: Int) { fatalError() }

    public var intValue: Int? { nil }
    public var stringValue: String { nestedKeys.first! }

    public var nestedKeys: [String] { rawValue.components(separatedBy: ".") }
}

func test_nestedKey() {
    let json = """
    {
        "name": {
            "first": "Ian",
            "last": "Keen"
        },
        "age": 42,
        "settings": {
            "permissions": {
                "admin": true
            }
        }
    }
    """

    struct User: Codable {
        private enum CodingKeys: String, NestedCodingKey {
            case firstName = "name.first"
            case lastName = "name.last"
            case age
            case isAdmin = "settings.permissions.admin"
        }

        @NestedKey var firstName: String
        @NestedKey var lastName: String
        var age: Int
        @NestedKey var isAdmin: Bool
    }
    
    let data = json.data(using: .utf8)!
    let decoder = JSONDecoder()
    
    do {
        let user = try decoder.decode(User.self, from: data)
        print(user)
    } catch {
        print(error)
    }
}
