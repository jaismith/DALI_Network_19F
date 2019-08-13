//
//  CustomSnapshotView.swift
//  dali_network_19f
//
//  Created by Jai Smith on 8/12/19.
//  Copyright © 2019 Jai Smith. All rights reserved.
//

import UIKit

class CustomSnapshotView: UIView {

    // MARK: Overrides

    override func snapshotView(afterScreenUpdates afterUpdates: Bool) -> UIView? {
        // hide all subviews
        subviews.forEach {$0.isHidden = true}

        // get snapshot
        let snapshow = super.snapshotView(afterScreenUpdates: afterUpdates)

        // show all subviews
        subviews.forEach {$0.isHidden = false}

        // return snapshot
        return snapshow
    }
}
