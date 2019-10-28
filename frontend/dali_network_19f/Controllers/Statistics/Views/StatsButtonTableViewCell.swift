//
//  StatsButtonTableViewCell.swift
//  dali_network_19f
//
//  Created by Jai Smith on 10/27/19.
//  Copyright © 2019 Jai Smith. All rights reserved.
//

import UIKit

class StatsButtonTableViewCell: UITableViewCell {

    // MARK: Properties
    
    @IBOutlet weak var statsButton: UIButton!
    
    // MARK: Actions
    
    @IBAction func statsButton(_ sender: Any) {
        NotificationCenter.default.post(Notification.init(name: Notification.Name(rawValue: "ShowStatSubset")))
    }
}
