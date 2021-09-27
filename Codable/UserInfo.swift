//
//  UserInfo.swift
//  Codable
//
//  Created by Anil Goktas on 9/27/21.
//

import Foundation

extension CodingUserInfoKey {
    static let someKey = CodingUserInfoKey(rawValue: "someKey")!
}

func test_userInfo() {
    let decoder = JSONDecoder()
    decoder.userInfo = [.someKey: "someKeyValue"]
    
    struct SomeStruct: Codable {
        let string: String
        
        init(from decoder: Decoder) throws {
            print(decoder.userInfo[.someKey]!)
            let container = try decoder.container(keyedBy: CodingKeys.self)
            string = try container.decode(forKey: .string)
        }
    }
    let json = """
    {
        "string": "some string value"
    }
    """.data(using: .utf8)!
    
    do {
        let someStruct: SomeStruct = try decoder.decode(from: json)
        print(someStruct)
    } catch {
        print(error)
    }
}
