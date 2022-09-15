//
//  OptionalURL.swift
//  Codable
//
//  Created by Anil Goktas on 6/2/22.
//

import Foundation

func test_optionalURL() {
    let json = [
        "boomURL": ""
    ]
    let data = try! JSONSerialization.data(withJSONObject: json)

    struct Holder: Codable {
        let boomURL: URL?
    }

    do {
        _ = try JSONDecoder().decode(Holder.self, from: data)
    } catch {
        print(error)
    }
}
