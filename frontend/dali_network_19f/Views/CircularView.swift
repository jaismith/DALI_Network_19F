//
//  CircularView.swift
//  dali_network_19f
//
//  Created by Jai Smith on 8/14/19.
//  Copyright © 2019 Jai Smith. All rights reserved.
//

import UIKit

class CircularView: UIView {

    // MARK: Overrides

    override init(frame: CGRect) {
        super.init(frame: frame)
        roundCorners()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        roundCorners()
    }

    // MARK: Public Methods

    func roundCorners() {
        layer.cornerRadius = frame.height / 2
        layer.masksToBounds = true
    }

}
