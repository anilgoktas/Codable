//
//  DefaultCodable.swift
//  Codable
//
//  Created by Anil Goktas on 9/25/21.
//

import Foundation
import DefaultCodable

/// - Note: [Source](https://github.com/gonzalezreal/DefaultCodable)
/// Naming is a bit too generic. e.g. `Default`, `Empty`, `True`.
/// It would be nice to have a namespace as in Sundell's implementation of `DecodableDefault`.
func test_defaultCodable() {
    enum ProductType: String, Codable, CaseIterable, DefaultValueProvider {
        case phone, pad, mac, accesory
        
        static var `default`: Self { .phone }
    }
    
    struct Product: Codable {
        var name: String
        
        @Default<Empty>
        var description: String
        
        @Default<True>
        var isAvailable: Bool
        
        @Default<ProductType>
        var type: ProductType
    }
    
    let json = """
    {
      "name": "iPhone 11 Pro"
    }
    """
    let data = json.data(using: .utf8)!
    do {
        let product: Product = try data.decoded()
        print(product)
    } catch {
        print(error)
    }
}
