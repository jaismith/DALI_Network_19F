//
//  IntFormatter.swift
//  dali_network_19f
//
//  Created by Jai Smith on 10/27/19.
//  Copyright © 2019 Jai Smith. All rights reserved.
//

import Foundation
import Charts

class IntFormatter: IValueFormatter {
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        return String(Int(value))
    }
}
