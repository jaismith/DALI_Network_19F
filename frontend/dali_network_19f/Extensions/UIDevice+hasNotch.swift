//
//  UIDevice+hasNotch.swift
//  dali_network_19f
//
//  Created by Jai Smith on 8/9/19.
//  Copyright © 2019 Jai Smith. All rights reserved.
//

import Foundation
import UIKit

extension UIDevice {
    var hasNotch: Bool {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0 > 0
        }
        return false
    }
}
