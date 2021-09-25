//
//  SwiftyJSON.swift
//  Codable
//
//  Created by Anil Goktas on 9/25/21.
//

import Foundation
import SwiftyJSON

func test_swityjson_codable() {
    let dict: [String: Any] = [
        "first": 1,
        "second": 2,
        "some_array": [
            11,
            22
        ],
        "some_dict": [
            "dict_first": 111,
            "dict_second": 222
        ]
    ]
    let json = JSON(dict)
    
    do {
        let data = try json.encoded()
        let decoded: JSON = try data.decoded()
        let value = decoded["some_dict"]["dict_first"].intValue
        print(value)
    } catch {
        print(error)
    }
}
