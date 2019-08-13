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

    @IBOutlet weak var profileImageView: ProfileImageView!
    @IBOutlet weak var yearLabel: CircularLabel!

    // MARK: Public Methods

    func configure(for member: Member) {
        profileImageView.configure(for: member)
        yearLabel.text = member.year
    }
}
