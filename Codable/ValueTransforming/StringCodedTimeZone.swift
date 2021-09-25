//
//  StringCodedTimeZone.swift
//  Codable
//
//  Created by Anil Goktas on 9/25/21.
//

import Foundation

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
