//
//  MemberTableViewController.swift
//  dali_network_19f
//
//  Created by Jai Smith on 8/8/19.
//  Copyright © 2019 Jai Smith. All rights reserved.
//

import UIKit
import os.log
import Hero

class MemberTableViewController: UITableViewController, UIGestureRecognizerDelegate {

    // MARK: Properties

    var members: [Member]?

    // drag to exit
    var panGestureRecognizer: UIPanGestureRecognizer!
    var progressBool: Bool = false
    var dismissBool: Bool = false

    // tableview ready to load?
    var tableViewLoaded: Bool = false
    var viewDidAppear: Bool = false
    var viewDidLayout: Bool = false

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        // register cells
        tableView.register(UINib(nibName: "MemberTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "MemberCell")

        // configure hero
        view.hero.isEnabled = true
        view.hero.isEnabledForSubviews = false
        view.hero.id = "members"
        view.hero.modifiers = [.arc(), .shadowColor(UIColor(red: 0 / 255, green: 84 / 255, blue: 180 / 255, alpha: 1))]

        // fetch members
        API.shared.getMembers { members in
            self.members = members
            DispatchQueue.main.async {
//                if !self.viewAppeared {
//                    self.tableViewLoaded = true
//                } else {
//                    self.tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .fade)
//                }
                if self.viewDidLayout && !self.tableViewLoaded {
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
        // customize navigationbar
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = self.tableView.backgroundColor
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        if tableViewLoaded {
//            self.tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .fade)
//        } else {
//            viewAppeared = true
//        }
//    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewDidLayout = true

        guard isViewLoaded, view.window != nil, !tableViewLoaded else { return }
        tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .fade)
        tableViewLoaded = true
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

    // MARK: Private Methods

    @objc private func exit(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: nil)
        let progressY = (translation.y / 2) / view.bounds.height

        if recognizer.direction == .down && tableView.isAtTop {
            if dismissBool {
                dismissBool = false
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
            }
        }
    }

    // MARK: UIGestureRecognizerDelegate

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    // MARK: UIScrollViewDelegate

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isAtTop && scrollView.panGestureRecognizer.direction == .down {
            scrollView.contentOffset = CGPoint(x: 0, y: -(UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0) + (self.navigationController?.navigationBar.frame.height ?? 0)
            )
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
