//
//  DecodingExample1.swift
//  Codable
//
//  Created by Anil Goktas on 9/25/21.
//

import Foundation

/// - Note: [Source](https://gist.github.com/Pasanpr/2ab4f12aad7074b001dbf77553fb5cb4)
struct RedditPost: Decodable {
    let title: String
    let score: Int

    enum CodingKeys: String, CodingKey {
        case data
    }

    enum RedditPostKeys: String, CodingKey {
        case title
        case score
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let innerContainer = try container.nestedContainer(keyedBy: RedditPostKeys.self, forKey: .data)
        self.title = try innerContainer.decode(String.self, forKey: .title)
        self.score = try innerContainer.decode(Int.self, forKey: .score)
    }
}

struct RedditPostListing: Decodable {
    enum CodingKeys: String, CodingKey {
        case data // you only need to assign a string value here if the value is different
    }

    enum ChildrenCodingKeys: String, CodingKey {
        case children
    }

    let children: [RedditPost]

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let data = try container.nestedContainer(keyedBy: ChildrenCodingKeys.self, forKey: .data)
        self.children = try data.decode([RedditPost].self, forKey: .children)
    }
}

func test_decodingExample1() {
    let json = """
    {
        "kind": "Listing",
        "data": {
            "modhash": "asjdfhhjsdfkjhsdfksjd23423",
            "dist": 25,
            "children": [
                {
                    "kind": "t3",
                    "data": {
                        "title": "Test title",
                        "score": 88
                    }
                }
            ]
        }
    }
    """
    let data = json.data(using: .utf8)
    let decoder = JSONDecoder()
    
    do {
        let listing = try decoder.decode(RedditPostListing.self, from: data!)
        print(listing.children)
    } catch {
        print(error)
    }
}
