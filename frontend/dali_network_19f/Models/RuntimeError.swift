//
//  RuntimeError.swift
//  kaasthamandap_ios_client
//
//  Created by Jai Smith on 7/23/19.
//  Copyright © 2019 Mobera Tech. All rights reserved.
//

import Foundation

struct RuntimeError: Error {
    let message: String

    init(_ message: String) {
        self.message = message
    }

    public var localizedDescription: String {
        return message
    }
}
