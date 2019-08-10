//
//  MemberTableViewCell.swift
//  dali_network_19f
//
//  Created by Jai Smith on 8/8/19.
//  Copyright © 2019 Jai Smith. All rights reserved.
//

import UIKit

class MemberTableViewCell: UITableViewCell {

    // MARK: Properties

    @IBOutlet weak var profileImageContainer: UIView!
    @IBOutlet weak var profileImageView: ProfileImageView!
    @IBOutlet weak var primaryLabel: UILabel!
    @IBOutlet weak var secondaryLabel: UILabel!

    var member: Member!

    // MARK: Overrides

    override func awakeFromNib() {
        super.awakeFromNib()

        // add shadow to profile image
        profileImageContainer.layer.backgroundColor = UIColor.clear.cgColor
        profileImageContainer.layer.shadowColor = UIColor.black.cgColor
        profileImageContainer.layer.shadowOffset = CGSize(width: 1, height: 2)
        profileImageContainer.layer.shadowOpacity = 0.2
        profileImageContainer.layer.shadowRadius = 3.0    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // MARK: Public Methods

    func load(from member: Member) {
        profileImageView.configure(for: member)
        primaryLabel.text = member.displayName
        secondaryLabel.text = "\(member.role), \(member.year)"
    }
}
