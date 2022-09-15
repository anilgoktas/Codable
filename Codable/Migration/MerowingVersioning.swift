//
//  MerowingVersioning.swift
//  Codable
//
//  Created by Anil Goktas on 9/25/21.
//

import Foundation
import Versionable

/// - Note: [Source](https://github.com/krzysztofzablocki/Versionable)
/// VersionableDecoder for flat structures
/// VersionableContainer<> for objects trees'
private struct Complex {
    let text: String
    let number: Int
    var version: Version = Self.version
}

extension Complex: Versionable {
    static var mock: Complex {
        .init(text: "Mocking", number: 0)
    }
    
    enum Version: Int, VersionType {
        case v1 = 1
        case v2 = 2
        case v3 = 3
    }

    static func migrate(to: Version) -> Migration {
        switch to {
        case .v1:
            return .none
        case .v2:
            return .migrate { payload in
                payload["text"] = "defaultText"
            }
        case .v3:
            return .migrate { payload in
                payload["number"] = (payload["text"] as? String) == "defaultText" ? 1 : 200
            }
        }
    }
}

func test_merowingVersioning() {
    let json = """
    {
        "text": "Mocking",
        "number": 0
    }
    """
    let data = json.data(using: .utf8)!
    
    do {
        let model = try VersionableDecoder().decode(Complex.self, from: data)
        print(model)
    } catch {
        print(error)
    }
}
