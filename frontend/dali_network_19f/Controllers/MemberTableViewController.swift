//
//  MemberTableViewController.swift
//  dali_network_19f
//
//  Created by Jai Smith on 8/8/19.
//  Copyright © 2019 Jai Smith. All rights reserved.
//

import UIKit
import Alamofire
import os.log

class MemberTableViewController: UITableViewController {

    // MARK: Properties

    var members: [Member]?

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        // register cells
        tableView.register(UINib(nibName: "MemberTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "MemberCell")

        // add refresh control
//        self.tableView.refreshControl = UIRefreshControl()

        // fix tableview
//        self.tableView.contentInsetAdjustmentBehavior = .never

        // add space at bottom of tableview if frameless display
        if UIDevice.current.hasNotch {
            self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 20))
        }

        // fetch members
        fetchMembers()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // remove 'back' text
        

        // set title fonts
        if let montserrat = UIFont(name: "Montserrat", size: 30), let montserratBold = montserrat.fontDescriptor.withSymbolicTraits(.traitBold) {
            // regular
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 0, green: 109 / 255, blue: 166 / 255, alpha: 1),
                                                                       NSAttributedString.Key.font:  UIFont(descriptor: montserratBold, size: 20)]

            // large
            navigationController?.navigationBar.largeTitleTextAttributes =
                [NSAttributedString.Key.foregroundColor: UIColor(red: 0, green: 109 / 255, blue: 166 / 255, alpha: 1),
                 NSAttributedString.Key.font: UIFont(descriptor: montserratBold, size: 30)]
        }

        // customize navigationbar
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = self.tableView.backgroundColor
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MemberCell", for: indexPath) as? MemberTableViewCell else {
            fatalError("Dequeued cell not an instance of MemberTableViewCell")
        }

        // Configure the cell...
        cell.load(from: members![indexPath.row])

        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: Private Methods

    private func fetchMembers() {
//        self.tableView.refreshControl?.beginRefreshing()

        AF.request(URL(string: "http://dali-network-19f.appspot.com/api/members")!, method: .get)
            .validate(statusCode: [200])
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                defer {
//                    self.tableView.refreshControl?.endRefreshing()
                }

                switch response.result {
                case .success:
                    guard let data = response.data, let members = try? JSONDecoder().decode([Member].self, from: data) else {
                        os_log("Error fetching members: deserialization failed", log: OSLog.default, type: .error)
                        return
                    }

                    self.members = members.sorted(by: {memberA, memberB in return memberA.name < memberB.name})

                    self.tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .bottom)

                case .failure(let error):
                    os_log("Error fetching members: %@", log: OSLog.default, type: .error, error.localizedDescription)
                }
        }
    }
}
