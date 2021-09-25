//
//  Enum.swift
//  Codable
//
//  Created by Anil Goktas on 9/25/21.
//

import Foundation

/// - Note: [Source](https://www.swiftbysundell.com/articles/codable-synthesis-for-swift-enums/#associated-values)
func test_enumAssociatedValues() {
    enum Video: Codable {
        case youTube(id: String)
        case vimeo(id: String)
        case hosted(url: URL)
    }
    
    struct VideoCollection: Codable {
        var name: String
        var videos: [Video]
    }

    let collection = VideoCollection(
        name: "Conference talks",
        videos: [
            .youTube(id: "ujOc3a7Hav0"),
            .vimeo(id: "234961067")
        ]
    )
    
    do {
        let encoded = try collection.encoded()
        print(encoded)
    } catch {
        print(error)
    }
    /*
     {
         "name": "Conference talks",
         "videos": [
             { "youTube": { "id": "ujOc3a7Hav0" } },
             { "vimeo": { "id": "234961067" } }
         ]
     }
     */
}

/// - Note: [Source](https://www.swiftbysundell.com/articles/codable-synthesis-for-swift-enums/#key-customization)
func test_enumKeyCustomization() {
     enum Video: Codable {
         case youTube(id: String)
         case vimeo(id: String)
         case hosted(url: URL)
//         case local(LocalVideo)
         
         enum CodingKeys: String, CodingKey {
             case youTube
             case vimeo
             case hosted = "custom"
         }
         
         enum YouTubeCodingKeys: String, CodingKey {
             case id = "youTubeID"
         }
     }
    /*
     {
         [
             { "youTube": { "youTubeID": "ujOc3a7Hav0" } },
             { "vimeo": { "id": "234961067" } }
         ]
     }
     */
}
