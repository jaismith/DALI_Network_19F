//
//  Statistic.swift
//  dali_network_19f
//
//  Created by Jai Smith on 10/22/19.
//  Copyright © 2019 Jai Smith. All rights reserved.
//

import Foundation

struct Statistic: Codable {
    
    // MARK: Properties
    
    var name: String
    var description: String
    var keys: [String]
    var values: [Double]
    
    // MARK: Codable
    
    enum CodingKeys: String, CodingKey {
        case name
        case description
        case keys
        case values
    }
}
