//
//  LossyCodableArray.swift
//  Codable
//
//  Created by Anil Goktas on 9/25/21.
//

import Foundation

/// - Note: [Source](https://www.swiftbysundell.com/articles/ignoring-invalid-json-elements-codable/)
@propertyWrapper
struct LossyCodableArray<Element> {
    private(set) var elements: [Element]
    
    var wrappedValue: [Element] {
        get { elements }
        set { elements = newValue }
    }
}

extension LossyCodableArray: Decodable where Element: Decodable {
    private struct ElementWrapper: Decodable {
        let element: Element?

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            element = try? container.decode()
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let wrappers = try container.decode([ElementWrapper].self)
        elements = wrappers.compactMap(\.element)
    }
}

/*
 extension Item {
     struct Collection: Codable {
         @LossyCodableList var items: [Item]
     }
 }
 */
