//
//  ManualMigration.swift
//  Codable
//
//  Created by Anil Goktas on 9/25/21.
//

import Foundation

/// - Note: [Source](https://twitter.com/Erickdepavo/status/1397259219041198080/photo/1)
struct ManualMigration {
    let original: String
    let addedLater: String
}

extension ManualMigration: Codable {
    
    enum CodingKeys: String, CodingKey {
        case original
        case addedLater
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // V1
        let original = try container.decode(String.self, forKey: .original)
        // V2, use `optional try` in order not to fail.
        let addedLater = try? container.decode(String.self, forKey: .addedLater)
        
        self.init(
            original: original,
            addedLater: addedLater ?? "default"
        )
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container (keyedBy: CodingKeys.self)
        try container.encode(original, forKey: .original)
        try container.encode(addedLater, forKey: .addedLater)
    }
    
}
