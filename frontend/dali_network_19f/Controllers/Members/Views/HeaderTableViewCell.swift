//
//  HeaderTableViewCell.swift
//  dali_network_19f
//
//  Created by Jai Smith on 8/12/19.
//  Copyright © 2019 Jai Smith. All rights reserved.
//

import UIKit

class HeaderTableViewCell: UITableViewCell {

    // MARK: Properties

    @IBOutlet var profileImageView: ProfileImageView!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var yearContainerView: CircularView!

    var xConstraint: NSLayoutConstraint?
    var yConstraint: NSLayoutConstraint?

    var member: Member? {
        didSet {
            guard let member = member else {
                return
            }

            // set image and year label
            profileImageView.configure(for: member)
            yearLabel.text = member.year

            // remove old contraints on yearContainerView
            xConstraint?.isActive = false
            yConstraint?.isActive = false

            // position year label along circle border
            let radius = CGFloat(profileImageView.frame.height / 2)
            xConstraint = yearContainerView.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor, constant: radius * cos(0.785398))
            xConstraint?.isActive = true
            yConstraint = yearContainerView.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor, constant: radius * sin(0.785398))
            yConstraint?.isActive = true
        }
    }
}
