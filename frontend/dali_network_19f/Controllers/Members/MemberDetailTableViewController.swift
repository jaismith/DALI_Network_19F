//
//  MemberDetailTableViewController.swift
//  dali_network_19f
//
//  Created by Jai Smith on 8/12/19.
//  Copyright © 2019 Jai Smith. All rights reserved.
//

import UIKit
import os.log

class MemberDetailTableViewController: UITableViewController {

    // MARK: Properties

    var member: Member!

    // MARK: Overrides

    override func viewDidLoad() {
        guard member != nil else {
            self.dismiss(animated: false, completion: nil)
            return
        }

        API.shared.getMember(member.name) { member in
            guard let member = member else {
                return
            }

            self.member = member
            self.tableView.reloadData()
        }

        // register tableview cells
        tableView.register(UINib(nibName: "HeaderTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "HeaderCell")
        tableView.register(UINib(nibName: "InfoTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "InfoCell")
        tableView.register(UINib(nibName: "MapTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "MapCell")
        tableView.register(UINib(nibName: "FunFactTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "FactCell")
        tableView.register(UINib(nibName: "StatsButtonTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "StatButtonCell")

        // set view title
        title = member.displayName

        // listen for notification to show stats
        NotificationCenter.default.addObserver(self, selector: #selector(showStats), name: Notification.Name.init("ShowStatSubset"), object: nil)
        
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 4 + (member.other != nil ? 1 : 0)

        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let identifier = "HeaderCell"
                guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? HeaderTableViewCell else {
                    fatalError()
                }

                // config cell
                cell.member = member

                return cell

            case 1:
                let identifier = "InfoCell"
                guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? InfoTableViewCell else {
                    fatalError()
                }

                // config cell
                cell.member = member

                return cell

            case 2:
                let identifier = "MapCell"
                guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? MapTableViewCell else {
                    fatalError()
                }

                // config cell
                cell.member = member

                return cell

            case 3:
                let identifier = "FactCell"
                guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? FunFactTableViewCell else {
                    fatalError()
                }
                
                // config cell
                cell.member = member
                
                return cell
                
            case 4:
                let identifier = "StatButtonCell"
                guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? StatsButtonTableViewCell else {
                    fatalError()
                }
                
                return cell
                
            default:
                fatalError()
            }

        default:
            fatalError()
        }
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 20))
        header.backgroundColor = UIColor(red: 18 / 255, green: 36 / 255, blue: 67 / 255, alpha: 1)
        return header
    }
    
    // MARK: Methods
    
    @objc func showStats() {
        self.performSegue(withIdentifier: "ShowStatSubset", sender: member)
    }
    
    // MARK: Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "ShowStatSubset":
            guard let dest = segue.destination as? StatisticsSubsetTableViewController, let member = sender as? Member else {
                return
            }
            
            dest.member = member
            
        default:
            os_log("Error, invalid segue", log: OSLog.default, type: .error)
        }
    }
}
