//
//  AnyCodingKey.swift
//  Codable
//
//  Created by Anil Goktas on 9/27/21.
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
