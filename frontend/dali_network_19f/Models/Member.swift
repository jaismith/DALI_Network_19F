//
//  Member.swift
//  dali_network_19f
//
//  Created by Jai Smith on 8/8/19.
//  Copyright © 2019 Jai Smith. All rights reserved.
//

import Foundation

class Member: Decodable {

    // MARK: Properties

    var name: String
    var year: String
    var picture: URL
    var role: String
    var location: Location

    var other: [String: String]?

    var displayName: String {
        return name.replacingOccurrences(of: "[ ].+[ ]", with: " ", options: .regularExpression)
    }

    // MARK: Decodable

    enum CodingKeys: String, CodingKey {
        case name
        case year
        case picture
        case role
        case location
    }

    required init(from decoder: Decoder) throws {
        // get container
        var container = try decoder.unkeyedContainer()

        var name: String?, year: String?, picture: URL?, role: String?, location: Location?
        other = [String: String]()

//        while !container.isAtEnd {
//
//        }

        let data = try container.decode([String: Data].self)
        for entry in data {
            if let requiredField = CodingKeys(rawValue: entry.key) {
                switch requiredField {
                case .name:
                    name = String(data: entry.value, encoding: .utf8)

                case .year:
                    year = String(data: entry.value, encoding: .utf8)

                case .picture:
                    picture = URL(string: String(data: entry.value, encoding: .utf8)!)!

                case .role:
                    role = String(data: entry.value, encoding: .utf8)

                case .location:
                    location = try JSONDecoder().decode(Location.self, from: entry.value)
                }
            } else {
                other![entry.key] = String(data: entry.value, encoding: .utf8)
            }
        }

        self.name = name!
        self.year = year!
        self.picture = picture!
        self.role = role!
        self.location = location!
    }
}
