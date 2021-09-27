//
//  CustomKeyDecodingStrategy.swift
//  Codable
//
//  Created by Anil Goktas on 9/27/21.
//

import Foundation

/// - Note: [Source](https://www.raywenderlich.com/books/expert-swift/v1.0)
extension JSONDecoder.KeyDecodingStrategy {
    static var convertFromKebabCase: JSONDecoder.KeyDecodingStrategy = .custom({ keys in
        let codingKey = keys.last!
        let key = codingKey.stringValue
        
        guard key.contains("-") else { return codingKey }
        
        let words = key.components(separatedBy: "-")
        let camelCased = words[0] + words[1...].map(\.capitalized).joined()
        
        return AnyCodingKey(camelCased)
    })
}
