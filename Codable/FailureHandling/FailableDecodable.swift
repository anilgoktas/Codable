//
//  FailableDecodable.swift
//  Codable
//
//  Created by Anil Goktas on 9/25/21.
//

import Foundation

/// - Note: [Source](https://martiancraft.com/blog/2020/03/going-deep-with-decodable/)
enum FailableDecodable<T: Decodable>: Decodable {
    case decoded(T)
    case failed(Error)
  
    init(from decoder: Decoder) throws {
        do {
            let decoded = try T(from: decoder)
            self = .decoded(decoded)
        } catch {
            self = .failed(error)
        }
    }
  
    var decoded: T? {
        switch self {
        case .decoded(let decoded): return decoded
        case .failed: return nil
        }
    }
}
