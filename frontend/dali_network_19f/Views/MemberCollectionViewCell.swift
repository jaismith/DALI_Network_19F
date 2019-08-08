//
//  MemberCollectionViewCell.swift
//  dali_network_19f
//
//  Created by Jai Smith on 8/8/19.
//  Copyright © 2019 Jai Smith. All rights reserved.
//

import UIKit

class MemberCollectionViewCell: UICollectionViewCell {

    // MARK: Properties

    @IBOutlet weak var profileImageView: ProfileImageView!
    @IBOutlet weak var primaryLabel: UILabel!
    @IBOutlet weak var secondaryLabel: UILabel!
    
    // MARK: Overrides

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: Public Methods

    func load(from member: Member) {
        profileImageView.configure(for: member)
        primaryLabel.text = member.name
        secondaryLabel.text = "\(member.role) \(member.year)"
    }
}
