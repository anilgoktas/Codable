//
//  StringCodedTimeZone.swift
//  Codable
//
//  Created by Anil Goktas on 9/25/21.
//

import Foundation

/// - Note: [Source](https://www.swiftbysundell.com/articles/customizing-how-a-type-is-encoded-or-decoded/)
@propertyWrapper
struct StringCodedTimeZone {
    var wrappedValue: TimeZone
}

extension StringCodedTimeZone: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let identifier = try container.decode(String.self)

        guard let timeZone = TimeZone(identifier: identifier) else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Unknown time zone '\(identifier)'"
            )
        }

        wrappedValue = timeZone
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue.identifier)
    }
}

func test_stringCodedTimeZoen() {
    struct User: Identifiable, Codable {
        let id: UUID
        var name: String
        @StringCodedTimeZone var timeZone: TimeZone
    }
    
    var user = User(id: UUID(), name: "Test User", timeZone: .current)
    user.timeZone = .autoupdatingCurrent
}

// MARK: - More Generic

protocol CodableByTransform: Codable {
    associatedtype CodingValue: Codable
    static func transformDecodedValue(_ value: CodingValue) throws -> Self?
    static func transformValueForEncoding(_ value: Self) throws -> CodingValue
}

extension CodableByTransform {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let decoded = try container.decode(CodingValue.self)

        guard let value = try Self.transformDecodedValue(decoded) else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Decoding transformation failed for '\(decoded)'"
            )
        }

        self = value
    }

    func encode(to encoder: Encoder) throws {
        let encodable = try Self.transformValueForEncoding(self)
        var container = encoder.singleValueContainer()
        try container.encode(encodable)
    }
}

@propertyWrapper
struct StringCodedTimeZone_CodableByTransform: CodableByTransform {
    static func transformDecodedValue(_ value: String) throws -> Self? {
        TimeZone(identifier: value).map(Self.init)
    }

    static func transformValueForEncoding(_ value: Self) throws -> String {
        value.wrappedValue.identifier
    }

    var wrappedValue: TimeZone
}
