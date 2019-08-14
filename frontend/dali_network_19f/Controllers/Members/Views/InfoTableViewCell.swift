//
//  InfoTableViewCell.swift
//  dali_network_19f
//
//  Created by Jai Smith on 8/14/19.
//  Copyright © 2019 Jai Smith. All rights reserved.
//

import UIKit

class InfoTableViewCell: UITableViewCell {

    // MARK: Properties

    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!

    var member: Member? {
        didSet {
            guard let member = member, let info = member.other else {
                return
            }

            var courseOfStudy = info["major"] ?? ""
            if let modification = info["modification"], !modification.isEmpty {
                courseOfStudy.append(" modified with \(modification)")
            }
            if let minor = info["minor"], !minor.isEmpty {
                courseOfStudy.append(", with a minor in \(minor)")
            }

            quoteLabel.text = info["quote"]
            majorLabel.text = courseOfStudy
            roleLabel.text = member.role
        }
    }
}
