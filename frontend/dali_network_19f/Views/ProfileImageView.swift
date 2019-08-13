//
//  ProfileImageView.swift
//  kaasthamandap_ios_client
//
//  Created by Jai Smith on 7/21/19.
//  Copyright © 2019 Mobera Tech. All rights reserved.
//

import UIKit
import Kingfisher
import os.log

class ProfileImageView: UIImageView {

    // MARK: Overrides

    override func awakeFromNib() {
        self.kf.indicatorType = .activity

        // make round
        self.contentMode = .scaleAspectFill
        self.layer.cornerRadius = floor(self.frame.height / 2)
        self.layer.masksToBounds = true
    }

    // MARK: Public Methods

    func configure(for member: Member) {
        self.kf.setImage(
            with: member.picture,
            placeholder: UIImage(named: "person.crop.circle"),
            options: [
                .processor(DownsamplingImageProcessor(size: frame.size)),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
            ],
            progressBlock: nil,
            completionHandler: { result in
            switch result {
            case .failure:
                os_log("Error loading profile image for member %@", log: OSLog.default, type: .error, member.name)

            default:
                break
            }
        })
    }
}
