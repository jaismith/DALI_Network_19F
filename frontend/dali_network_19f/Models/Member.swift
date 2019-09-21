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
    var location: Location?

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
        case other
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        year = try container.decode(String.self, forKey: .year)
        let pictureURL = URL(string: try container.decode(String.self, forKey: .picture))
        role = try container.decode(String.self, forKey: .role)
        location = try? container.decode(Location.self, forKey: .location)
        other = try container.decodeIfPresent(Dictionary.self, forKey: .other)
        
        guard pictureURL != nil else {
            throw RuntimeError("Invalid picture URL")
        }
        
        picture = pictureURL!
    }
}
