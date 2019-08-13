//
//  ViewController.swift
//  dali_network_19f
//
//  Created by Jai Smith on 8/8/19.
//  Copyright © 2019 Jai Smith. All rights reserved.
//

import UIKit
import Hero

class LandingViewController: UIViewController {

    // MARK: Properties

    @IBOutlet weak var membersView: UIView!
    @IBOutlet weak var memberCountLabel: UILabel!
    @IBOutlet weak var statisticsView: UIView!

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        // hide navbar
        self.navigationController?.setNavigationBarHidden(true, animated: false)

        // use hero animations
        self.navigationController?.hero.navigationAnimationType = .fade

        // set geto animation background color
        Hero.shared.containerColor = UIColor(red: 18 / 255, green: 36 / 255, blue: 67 / 255, alpha: 1)

        // apply curve to button views
        membersView.layer.cornerRadius = 14
        membersView.layer.masksToBounds = true
        statisticsView.layer.cornerRadius = 14
        statisticsView.layer.masksToBounds = true

        // set memberCount label
        API.shared.getMembers(completion: { members in
            guard let members = members else {
                return
            }

            DispatchQueue.main.async {
                self.memberCountLabel.text = "\(members.count)"
            }
        })
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
}
