//
//  MemberDetailTableViewController.swift
//  dali_network_19f
//
//  Created by Jai Smith on 8/12/19.
//  Copyright © 2019 Jai Smith. All rights reserved.
//

import UIKit

class MemberDetailTableViewController: UITableViewController {

    // MARK: Properties

    var member: Member!

    // MARK: Overrides

    override func viewDidLoad() {
        guard member != nil else {
            self.dismiss(animated: false, completion: nil)
            return
        }

        self.hero.isEnabled = false

        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "HeaderCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? HeaderTableViewCell else {
            fatalError()
        }

        cell.configure(for: member)

        return cell
    }
}
