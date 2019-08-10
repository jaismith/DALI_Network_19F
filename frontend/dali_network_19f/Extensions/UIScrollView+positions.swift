//
//  UIScrollView+positions.swift
//  dali_network_19f
//
//  REF: https://gist.github.com/mukyasa/263732c4e482f591930e8805790b85f9#file-scrollview-gist-swift
//
//  Created by Jai Smith on 8/10/19.
//  Copyright © 2019 Jai Smith. All rights reserved.
//

import Foundation
import UIKit

extension UIScrollView {
    var isAtTop: Bool {
        return contentOffset.y <= verticalOffsetForTop
    }

    var isAtBottom: Bool {
        return contentOffset.y >= verticalOffsetForBottom
    }

    var verticalOffsetForTop: CGFloat {
        let topInset = contentInset.top
        return -topInset
    }

    var verticalOffsetForBottom: CGFloat {
        let scrollViewHeight = bounds.height
        let scrollContentSizeHeight = contentSize.height
        let bottomInset = contentInset.bottom
        let scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight
        return scrollViewBottomOffset
    }
}
