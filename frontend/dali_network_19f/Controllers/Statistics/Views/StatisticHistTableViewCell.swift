//
//  StatisticHistTableViewCell.swift
//  dali_network_19f
//
//  Created by Jai Smith on 10/26/19.
//  Copyright © 2019 Jai Smith. All rights reserved.
//

import UIKit
import Charts

class StatisticHistTableViewCell: UITableViewCell {

    // MARK: Properties
    
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var chartLabel: UILabel!
    
    var statistic: Statistic!
    
    // MARK: Methods:
    
    func load(from stat: Statistic) {
        // save ref to stat
        statistic = stat
        
        // set label
        chartLabel.text = stat.name
        
        // set up pie chart
        barChartView.chartDescription?.text = nil
        barChartView.chartDescription?.textColor = UIColor.white
        barChartView.xAxis.labelTextColor = UIColor.white
        barChartView.leftAxis.labelTextColor = UIColor.white
        barChartView.rightAxis.labelTextColor = UIColor.white
        
        // generate PieChartData
        var chartData = [BarChartDataEntry]()
        for (key, value) in statistic.data {
            chartData.append(BarChartDataEntry(x: Double(Int(key) ?? 0), y: value))
        }
        
        // add chartData to pie chart
        let barChartDataSet = BarChartDataSet(entries: chartData, label: nil)
        barChartDataSet.colors = [UIColor(named: "color0"), UIColor(named: "color1"), UIColor(named: "color2"), UIColor(named: "color3")] as! [NSUIColor]
        barChartDataSet.valueTextColor = UIColor.white
        barChartDataSet.valueFormatter = IntFormatter()
        let barChartData = BarChartData(dataSet: barChartDataSet)
        barChartView.data = barChartData
        
        // config legend formatting
        barChartView.legend.enabled = false
        barChartView.legend.textColor = UIColor.white
        
        // animate chart
        barChartView.animate(xAxisDuration: stat.seen ? 0 : 0.75)
        barChartView.animate(yAxisDuration: stat.seen ? 0 : 0.75)
    }
}
