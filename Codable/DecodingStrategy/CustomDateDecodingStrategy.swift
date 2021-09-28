//
//  CustomDateDecodingStrategy.swift
//  Codable
//
//  Created by Anil Goktas on 9/28/21.
//

import Foundation

extension JSONDecoder.DateDecodingStrategy {
    
    private static var longDateFormatter: DateFormatter = .init()
    private static var shortDateFormatter: DateFormatter = .init()
    
    static var backendFormats: JSONDecoder.DateDecodingStrategy = .custom({ decoder in
        let container = try decoder.singleValueContainer()
        let dateString = try container.decode (String.self)
        
        if let date = longDateFormatter.date(from: dateString) {
            return date
        } else if let date = shortDateFormatter.date(from: dateString) {
            return date
        } else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Cannot decode date string \(dateString)"
            )
        }
    })
    
}
