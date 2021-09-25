//
//  NestedKeyTests.swift
//  CodableTests
//
//  Created by Anil Goktas on 9/25/21.
//

import XCTest
@testable import Codable

final class NestedKeyTests: XCTestCase {
    
    func makeJSONData() -> Data {
        let json = """
        {
            "name": {
                "first": "Ian",
                "last": "Keen"
            },
            "age": 42,
            "settings": {
                "permissions": {
                    "admin": true
                }
            }
        }
        """
        return json.data(using: .utf8)!
    }
    
    private struct User: Codable {
        private enum CodingKeys: String, NestedCodingKey {
            case firstName = "name.first"
            case lastName = "name.last"
            case age
            case isAdmin = "settings.permissions.admin"
        }

        @NestedKey var firstName: String
        @NestedKey var lastName: String
        var age: Int
        @NestedKey var isAdmin: Bool
    }
    
    private struct NotNestedUser: Codable {
        var firstName: String
        var lastName: String
        var age: Int
        var isAdmin: Bool
        
        enum CodingKeys: String, CodingKey {
            case name
            case age
            case settings
            
            enum NameKeys: String, CodingKey {
                case first
                case last
            }
            
            enum SettingsKeys: String, CodingKey {
                case permissions
                
                enum PermissionsKeys: String, CodingKey {
                    case admin
                }
            }
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            let nameContainer = try container.nestedContainer(keyedBy: CodingKeys.NameKeys.self, forKey: .name)
            firstName = try nameContainer.decode(forKey: .first)
            lastName = try nameContainer.decode(forKey: .last)
            
            age = try container.decode(forKey: .age)
            
            let settingsContainer = try container.nestedContainer(keyedBy: CodingKeys.SettingsKeys.self, forKey: .settings)
            let settingsPermissionsContainer = try settingsContainer.nestedContainer(keyedBy: CodingKeys.SettingsKeys.PermissionsKeys.self, forKey: .permissions)
            isAdmin = try settingsPermissionsContainer.decode(forKey: .admin)
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            var nameContainer = container.nestedContainer(keyedBy: CodingKeys.NameKeys.self, forKey: .name)
            try nameContainer.encode(firstName, forKey: .first)
            try nameContainer.encode(lastName, forKey: .last)
            
            try container.encode(age, forKey: .age)
            
            var settingsContainer = container.nestedContainer(keyedBy: CodingKeys.SettingsKeys.self, forKey: .settings)
            var settingsPermissionsContainer = settingsContainer.nestedContainer(keyedBy: CodingKeys.SettingsKeys.PermissionsKeys.self, forKey: .permissions)
            try settingsPermissionsContainer.encode(isAdmin, forKey: .admin)
        }
    }
    
    func test_normalKeys_decoding() {
        let data = makeJSONData()
        let decoder = JSONDecoder()
        measure {
            for _ in 0...10_000 {
                _ = try? decoder.decode(NotNestedUser.self, from: data)
            }
        }
    }
    
    func test_nestedKeys_decoding() {
        let data = makeJSONData()
        let decoder = JSONDecoder()
        measure {
            for _ in 0...10_000 {
                _ = try? decoder.decode(User.self, from: data)
            }
        }
    }
    
    func test_normalKeys_encoding() throws {
        let user: NotNestedUser = try makeJSONData().decoded()
        let encoder = JSONEncoder()
        
        measure {
            for _ in 0...10_000 {
                _ = try? encoder.encode(user)
            }
        }
    }
    
    func test_nestedKeys_encoding() throws {
        let user: User = try makeJSONData().decoded()
        let encoder = JSONEncoder()
        
        measure {
            for _ in 0...10_000 {
                _ = try? encoder.encode(user)
            }
        }
    }
    
}
