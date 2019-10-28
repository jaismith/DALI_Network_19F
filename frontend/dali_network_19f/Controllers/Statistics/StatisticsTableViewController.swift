//
//  StatisticsTableViewController.swift
//  dali_network_19f
//
//  Created by Jai Smith on 10/23/19.
//  Copyright © 2019 Jai Smith. All rights reserved.
//

import UIKit
import os.log
import Hero

class StatisticsTableViewController: UITableViewController, UIGestureRecognizerDelegate {
    
    // MARK: Properties
    
    var statistics: [Statistic]?
    
    // drag to exit
    var panGestureRecognizer: UIPanGestureRecognizer!
    var progressBool: Bool = false
    var dismissBool: Bool = false
    
    // tableview ready to load?
    var tableViewReady: Bool = false
    var tableViewLoaded: Bool = false
    var viewDidAppear: Bool = false
    
    // MARK: Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // use animated transitions for navcontroller
        self.navigationController?.hero.navigationAnimationType = .autoReverse(presenting: .push(direction: .left))
        
        // register cells
        tableView.register(UINib(nibName: "StatisticPieTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "StatisticPieCell")
        tableView.register(UINib(nibName: "StatisticHistTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "StatisticHistCell")
        
        // configure hero
        view.hero.isEnabled = true
        view.hero.isEnabledForSubviews = false
        view.hero.id = "statistics"
        view.hero.modifiers = [.arc(), .shadowColor(UIColor(red: 75 / 255, green: 160 / 255, blue: 221 / 255, alpha: 1))]
        
        // fetch members
        API.shared.getStats(filter: [:]) { statistics in
            self.statistics = statistics?.sorted(by: { a, b in return a.name > b.name })
            
            DispatchQueue.main.async {
                if !self.viewDidAppear {
                    self.tableViewReady = true
                } else if !self.tableViewLoaded {
                    self.tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .fade)
                    self.tableViewLoaded = true
                }
            }
        }
        
        // setup drag to exit
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(exit))
        panGestureRecognizer.delegate = self
        view.addGestureRecognizer(panGestureRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.hero.isEnabled = true
        
        // customize navigationbar
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = self.tableView.backgroundColor
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if tableViewReady, !tableViewLoaded {
            self.tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .fade)
            tableViewLoaded = true
        } else {
            viewDidAppear = true
        }
        
        self.navigationController?.hero.isEnabled = false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statistics?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if statistics![indexPath.row].data.count <= 4 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "StatisticPieCell", for: indexPath) as? StatisticPieTableViewCell else {
                fatalError("Dequeued cell not an instance of StatisticPieCell")
            }
            
            // Configure the cell...
            cell.load(from: statistics![indexPath.row])
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "StatisticHistCell", for: indexPath) as? StatisticHistTableViewCell else {
                fatalError("Dequeued cell not an instance of StatisticHistCell")
            }
            
            // Configure the cell...
            cell.load(from: statistics![indexPath.row])
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard statistics != nil else {
            return
        }
        
        statistics![indexPath.row].seen = true
    }
    
    // MARK: Private Methods
    
    @objc private func exit(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: nil)
        let progressY = (translation.y / 2) / view.bounds.height
        
        if recognizer.direction == .down && tableView.isAtTop {
            if dismissBool {
                dismissBool = false
                self.navigationController?.hero.isEnabled = true
                hero.dismissViewController()
                self.hero.modalAnimationType = .uncover(direction: .down)
                progressBool = true
                recognizer.setTranslation(.zero, in: view)
            }
        }
        
        switch recognizer.state {
        case .changed:
            if progressBool {
                let currentPos = CGPoint(x: view.center.x, y: max(translation.y + view.center.y, view.center.y))
                Hero.shared.update(progressY)
                Hero.shared.apply(modifiers: [.position(currentPos)], to: view)
            }
            
        default:
            dismissBool = true
            progressBool = false
            
            if abs(progressY + recognizer.velocity(in: nil).y / view.bounds.height) > 0.5 {
                Hero.shared.finish()
            } else {
                Hero.shared.cancel()
                self.navigationController?.hero.isEnabled = false
            }
        }
    }
    
    // MARK: UIGestureRecognizerDelegate
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
