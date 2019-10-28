//
//  FunFactTableViewCell.swift
//  dali_network_19f
//
//  Created by Jai Smith on 9/22/19.
//  Copyright © 2019 Jai Smith. All rights reserved.
//

import UIKit

class FunFactTableViewCell: UITableViewCell {

    // MARK: Properties
    
    @IBOutlet weak var funFactsLabel: UILabel!
    
    var member: Member? {
        didSet {
            guard let member = member, let info = member.other, let funFacts = info["fun_facts"], !funFacts.isEmpty else {
                funFactsLabel.isHidden = true
                self.isHidden = true
                return
            }
            
            funFactsLabel.isHidden = false
            self.isHidden = false
            
            funFactsLabel.text = funFacts
        }
    }
}
