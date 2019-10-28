//
//  StatisticsSubsetTableViewController.swift
//  dali_network_19f
//
//  Created by Jai Smith on 10/27/19.
//  Copyright © 2019 Jai Smith. All rights reserved.
//

import UIKit

class StatisticsSubsetTableViewController: UITableViewController {

    // MARK: Properties
    
    var stats: [Statistic]?
    var member: Member!
    
    // MARK: Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // register cells
        tableView.register(UINib(nibName: "StatisticPieTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "StatisticPieCell")
        tableView.register(UINib(nibName: "StatisticHistTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "StatisticHistCell")
        
        // load stats from API
        API.shared.getStats(filter: ["year": member.year, "gender": member.other!["gender"]!, "phoneType": member.other!["phoneType"]!]) { statistics in
            self.stats = statistics?.sorted(by: { a, b in return a.name > b.name })
            self.tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .fade)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stats?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if stats![indexPath.row].data.count <= 4 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "StatisticPieCell", for: indexPath) as? StatisticPieTableViewCell else {
                fatalError("Dequeued cell not an instance of StatisticPieCell")
            }
            
            // Configure the cell...
            cell.load(from: stats![indexPath.row])
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "StatisticHistCell", for: indexPath) as? StatisticHistTableViewCell else {
                fatalError("Dequeued cell not an instance of StatisticHistCell")
            }
            
            // Configure the cell...
            cell.load(from: stats![indexPath.row])
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard stats != nil else {
            return
        }
        
        stats![indexPath.row].seen = true
    }
}
