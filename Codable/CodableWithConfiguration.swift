//
//  CodableWithConfiguration.swift
//  Codable
//
//  Created by Anil Goktas on 9/25/21.
//

import Foundation

/// - Note: [Source](https://twitter.com/PDucks32/status/1415131799584313345/photo/1)
/// available iOS 15
func test_codableWithConfiguration() {
    struct UserCodableConfiguration {
        let codingKeys: Set<User.CodingKeys>
        // We can also add pre or post configurations as well.
    }
    
    struct User: Identifiable, CodableWithConfiguration {
        let id: String
        let name: String
        let birthday: Date
        let avatarURL: URL
        
        init() {
            id = ""
            name = ""
            birthday = Date()
            avatarURL = URL(string: "https://www.apple.com")!
        }
        
        init(from decoder: Decoder, configuration: UserCodableConfiguration) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            id = try container.decode(forKey: .id)
            
            if configuration.codingKeys.contains(.name) {
                name = try container.decode(forKey: .name)
            } else {
                name = ""
            }
            if configuration.codingKeys.contains(.birthday) {
                birthday = try container.decode(forKey: .birthday)
            } else {
                birthday = Date()
            }
            if configuration.codingKeys.contains(.avatarURL) {
                avatarURL = try container.decode(forKey: .avatarURL)
            } else {
                avatarURL = URL(string: "https://www.apple.com")!
            }
        }
        
        func encode(to encoder: Encoder, configuration: UserCodableConfiguration) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            if configuration.codingKeys.contains(.id) {
                try container.encode(id, forKey: .id)
            }
            if configuration.codingKeys.contains(.name) {
                try container.encode(name, forKey: .name)
            }
            if configuration.codingKeys.contains(.birthday) {
                try container.encode(birthday, forKey: .birthday)
            }
            if configuration.codingKeys.contains(.avatarURL) {
                try container.encode(avatarURL, forKey: .avatarURL)
            }
//            if configuration.codingKeys.contains(.posts) {
//                // Here we are encoding another WithConfiguration class. Notice we pass a configuration object
//                try container.encode(posts, forKey: .posts, configuration: configuration.postConfiguration)
//            }
        }
        
        enum CodingKeys: String, CodingKey, CaseIterable {
            case id
            case name
            case birthday
            case avatarURL
        }
    }
    
    // This is a provider which tells the property wrapper how to access the configurations.
    struct AllUserAttributes: EncodingConfigurationProviding, DecodingConfigurationProviding {
        static var encodingConfiguration: UserCodableConfiguration {
            .init(codingKeys: Set(User.CodingKeys.allCases))
        }
        static var decodingConfiguration: UserCodableConfiguration {
            .init(codingKeys: Set(User.CodingKeys.allCases))
        }
    }
    
    /// This is a provider which tells the property wrapper how to access the configurations.
    struct JustIDUserAttributes: EncodingConfigurationProviding, DecodingConfigurationProviding {
        static var encodingConfiguration: UserCodableConfiguration {
            .init(codingKeys: [.id])
        }
        static var decodingConfiguration: UserCodableConfiguration {
            .init(codingKeys: [.id])
        }
    }
    
    struct UserAchievementsViewModel: Codable {
        @CodableConfiguration(from: AllUserAttributes.self) var user = User()
    }
    struct FriendsViewModel: Codable {
        @CodableConfiguration(from: JustIDUserAttributes.self) var friends = [User]()
    }
    
    do {
        let json = """
        {
            "friends": [{
                "id": "abcde"
            }]
        }
        """
        let data = json.data(using: .utf8)!
        let friendsViewModel = try JSONDecoder().decode(FriendsViewModel.self, from: data)
        print(friendsViewModel.friends)
    } catch {
        print(error)
    }
}
