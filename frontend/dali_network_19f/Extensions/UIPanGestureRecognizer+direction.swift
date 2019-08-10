//
//  UIPanGestureRecognizer+direction.swift
//  dali_network_19f
//
//  REF: https://gist.github.com/mukyasa/0201431f735c51eec190d1f9f35dc9d7#file-pangesture-gist-swift
//
//  Created by Jai Smith on 8/10/19.
//  Copyright © 2019 Jai Smith. All rights reserved.
//

import Foundation
import UIKit

// Pan Gesture
enum PanDirection: Int {
    case up, down, left, right
    public var isVertical: Bool { return [.up, .down].contains(self) }
    public var isHorizontal: Bool { return !isVertical }
}

extension UIPanGestureRecognizer {
    var direction: PanDirection? {
        let velocity = self.velocity(in: view)
        let isVertical = abs(velocity.y) > abs(velocity.x)
        switch (isVertical, velocity.x, velocity.y) {
        case (true, _, let y) where y < 0: return .up
        case (true, _, let y) where y > 0: return .down
        case (false, let x, _) where x > 0: return .right
        case (false, let x, _) where x < 0: return .left
        default: return nil
        }
    }
}
