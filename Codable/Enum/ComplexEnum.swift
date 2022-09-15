//
//  ComplexEnum.swift
//  Codable
//
//  Created by Anil Goktas on 6/2/22.
//

import Foundation
import CoreLocation

enum GeoJSON {
//    struct Point: Decodable {
//        let coordinate: CLLocationCoordinate2D
//    }
//    struct LineString: Decodable {
//        let coordinates: [CLLocationCoordinate2D]
//    }
//    struct Polygon: Decodable {
//        let coordinates: [[CLLocationCoordinate2D]]
//    }
//    enum Geometry: Decodable {
//        case point(Point)
//        case linestring(LineString)
//        case polygon(Polygon)
//
//        private enum GeometryTypeKey: String, CodingKey { case type }
//        private enum GeometryType: String, Decodable { case point, linestring, polygon }
//
//        init(from decoder: Decoder) throws {
//            let container = try decoder.container (keyedBy: GeometryTypeKey.self)
//            switch try container.decode(GeometryType.self, forKey: .type) {
//            case .point: self = .point(try Point(from: decoder))
//            case .linestring: self = .linestring(try LineString(from: decoder) )
//            case .polygon: self = .polygon(try Polygon(from: decoder))
//            }
//        }
//    }
}

func test_geoJSON() {
    let _ = Data("""
    [
        { "type": "point", "coordinate": [10.0, 20.0] },
        { "type": "linestring", "coordinate": [[30.0, 40.0], [50.0, 60.0]] },
        { "type": "point", "coordinate": [10.0, 20.0] },
        { "type": "polygon", "coordinate": [[[12.0, 34.0], [56.0, 78.0]], [[12, 34], [56, 78]]] },
    ]
    """.utf8)
}
