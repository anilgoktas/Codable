//
//  DecodableDefault.swift
//  Codable
//
//  Created by Anil Goktas on 9/25/21.
//

import Foundation

/// - Note: [Source](https://www.swiftbysundell.com/tips/default-decoding-values/)
protocol DecodableDefaultSource {
    associatedtype Value: Decodable
    static var defaultValue: Value { get }
}

enum DecodableDefault { }

extension DecodableDefault {
    @propertyWrapper
    struct Wrapper<Source: DecodableDefaultSource> {
        typealias Value = Source.Value
        var wrappedValue = Source.defaultValue
    }
}

extension DecodableDefault.Wrapper: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        wrappedValue = try container.decode(Value.self)
    }
}

extension KeyedDecodingContainer {
    func decode<T>(
        _ type: DecodableDefault.Wrapper<T>.Type,
        forKey key: Key
    ) throws -> DecodableDefault.Wrapper<T> {
        try decodeIfPresent(type, forKey: key) ?? .init()
    }
}

extension DecodableDefault {
    typealias Source = DecodableDefaultSource
    typealias List = Decodable & ExpressibleByArrayLiteral
    typealias Dict = Decodable & ExpressibleByDictionaryLiteral

    enum Sources {
        enum True: Source {
            static var defaultValue: Bool { true }
        }

        enum False: Source {
            static var defaultValue: Bool { false }
        }

        enum EmptyString: Source {
            static var defaultValue: String { "" }
        }

        enum EmptyArray<T: List>: Source {
            static var defaultValue: T { [] }
        }

        enum EmptyDict<T: Dict>: Source {
            static var defaultValue: T { [:] }
        }
    }
}

extension DecodableDefault {
    typealias True = Wrapper<Sources.True>
    typealias False = Wrapper<Sources.False>
    typealias EmptyString = Wrapper<Sources.EmptyString>
    typealias EmptyArray<T: List> = Wrapper<Sources.EmptyArray<T>>
    typealias EmptyDict<T: Dict> = Wrapper<Sources.EmptyDict<T>>
}

extension DecodableDefault.Wrapper: Equatable where Value: Equatable { }
extension DecodableDefault.Wrapper: Hashable where Value: Hashable { }

extension DecodableDefault.Wrapper: Encodable where Value: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
}

func test_decodableDefault() {
    struct Comment: Decodable { }
    
    struct Article: Decodable {
        var title: String
        @DecodableDefault.EmptyString var body: String
        @DecodableDefault.False var isFeatured: Bool
        @DecodableDefault.True var isActive: Bool
        @DecodableDefault.EmptyArray var commentIDs: Set<Int>
        @DecodableDefault.EmptyArray var comments: [Comment]
        @DecodableDefault.EmptyDict var flags: [String: Bool]
    }
}
