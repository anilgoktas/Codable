//
//  Extensions.swift
//  Codable
//
//  Created by Anil Goktas on 9/25/21.
//

import Foundation

// MARK: - Dictionary

extension Dictionary {
    
    /// Uses `JSONSerialization`.
    func jsonData() throws -> Data {
        try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
    }
    
}

extension UnkeyedDecodingContainer {
    
    mutating func decoders() -> [Decoder] {
        var decoders = [Decoder]()
        while !isAtEnd {
            if let decoder = try? superDecoder() {
                decoders.append(decoder)
            }
        }
        return decoders
    }
    
}

extension KeyedDecodingContainer {
    
    public func decodeIfPresent<T: Decodable>(forKey key: KeyedDecodingContainer.Key) throws -> T? {
        try decodeIfPresent(T.self, forKey: key)
    }
    
    func decode<T: Decodable>(forKey key: Key) throws -> T {
        try decode(T.self, forKey: key)
    }

    func decode<T: Decodable>(
        forKey key: Key,
        default defaultExpression: @autoclosure () -> T
    ) throws -> T {
        try decodeIfPresent(T.self, forKey: key) ?? defaultExpression()
    }
    
}

extension SingleValueDecodingContainer {
    
    func decode<T: Decodable>() throws -> T {
        try decode(T.self)
    }
    
}

extension Encodable {
    
    func encoded(encoder: JSONEncoder = .init()) throws -> Data {
        try encoder.encode(self)
    }
    
}

extension Data {
    
    func decoded<T: Decodable>(decoder: JSONDecoder = .init()) throws -> T {
        try decoder.decode(T.self, from: self)
    }
    
}

extension JSONDecoder {
    
    func decode<T: Decodable>(from data: Data) throws -> T {
        try decode(T.self, from: data)
    }
    
}
