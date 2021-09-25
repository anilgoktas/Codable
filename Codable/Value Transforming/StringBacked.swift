//
//  StringBacked.swift
//  Codable
//
//  Created by Anil Goktas on 9/25/21.
//

import Foundation

protocol StringRepresentable: CustomStringConvertible {
    init?(_ string: String)
}

extension Int: StringRepresentable { }

/// - Note: [Source](https://www.swiftbysundell.com/articles/customizing-codable-types-in-swift/#transforming-values)
struct StringBacked<Value: StringRepresentable>: Codable {
    var value: Value
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        
        guard let value = Value(string) else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: """
                Failed to convert an instance of \(Value.self) from "\(string)"
                """
            )
        }
        
        self.value = value
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value.description)
    }
}

func test_stringBacked() {
    struct Video: Codable {
        var title: String
        var description: String
        var url: URL
        var thumbnailImageURL: URL
        
        var numberOfLikes: Int {
            get { likes.value }
            set { likes.value = newValue }
        }
        
        private var likes: StringBacked<Int>
    }
}
