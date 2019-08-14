//
//  Location.swift
//  dali_network_19f
//
//  Created by Jai Smith on 8/15/19.
//  Copyright © 2019 Jai Smith. All rights reserved.
//

import Foundation
import UIKit

struct Location: Codable {

    // MARK: Properties

    var latitude: Double
    var longitude: Double

    // MARK: Codable

    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lng"
    }
}
