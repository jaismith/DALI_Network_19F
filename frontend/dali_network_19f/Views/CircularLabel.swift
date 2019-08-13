//
//  CircularLabel.swift
//  dali_network_19f
//
//  Created by Jai Smith on 8/12/19.
//  Copyright © 2019 Jai Smith. All rights reserved.
//

import UIKit

class CircularLabel: UILabel {

    // MARK: Properties

    private var cornerRadius: CGFloat!

    // MARK: Overrides

    override func awakeFromNib() {
        // calculate corner radius
        cornerRadius = floor(layer.frame.height / 2)

        // round corners
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
    }

    override func drawText(in rect: CGRect) {
        let inset = cornerRadius / 3
        super.drawText(in: rect.inset(by: UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)))
    }
}
