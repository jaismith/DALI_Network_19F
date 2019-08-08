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

    var other: [String: String]?

    // MARK: Decodable

    enum CodingKeys: String, CodingKey {
        case name
        case year
        case picture
        case role
    }

    required init(from decoder: Decoder) throws {
        // get container
        let container = try decoder.singleValueContainer()

        var name: String?, year: String?, picture: URL?, role: String?
        other = [String: String]()

        let data = try container.decode([String: String].self)
        for entry in data {
            if let requiredField = CodingKeys(rawValue: entry.key) {
                switch requiredField {
                case .name:
                    name = entry.value

                case .year:
                    year = entry.value

                case .picture:
                    picture = URL(string: entry.value)!

                case .role:
                    role = entry.value
                }
            } else {
                other![entry.key] = entry.value
            }
        }

        self.name = name!
        self.year = year!
        self.picture = picture!
        self.role = role!
    }

    init(name: String, year: String, picture: URL, role: String) {
        self.name = name
        self.year = year
        self.picture = picture
        self.role = role
    }
}
