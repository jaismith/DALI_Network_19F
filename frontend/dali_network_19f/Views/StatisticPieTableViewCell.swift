//
//  StatisticPieTableViewCell.swift
//  dali_network_19f
//
//  Created by Jai Smith on 10/23/19.
//  Copyright © 2019 Jai Smith. All rights reserved.
//

import UIKit
import Charts

class StatisticPieTableViewCell: UITableViewCell, StatisticCell {
    
    // MARK: - Properties
    
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var chartLabel: UILabel!
    
    var statistic: Statistic!
    
    // MARK: Methods:
    
    func load(from stat: Statistic) {
        // save ref to stat
        statistic = stat
        
        // set label
        chartLabel.text = stat.name
        
        // set up pie chart
        pieChartView.chartDescription?.text = nil
        pieChartView.chartDescription?.textColor = UIColor.white
        pieChartView.holeColor = UIColor.init(red: 75 / 255, green: 160 / 255, blue: 221 / 255, alpha: 1)
        pieChartView.drawHoleEnabled = false
        pieChartView.drawEntryLabelsEnabled = false
        
        // generate PieChartData
        var chartData = [PieChartDataEntry]()
        for (key, value) in statistic.data {
            chartData.append(PieChartDataEntry(value: value, label: key))
        }
        
        // add chartData to pie chart
        let pieChartDataSet = PieChartDataSet(entries: chartData, label: nil)
        pieChartDataSet.colors = [UIColor(named: "color0"), UIColor(named: "color1"), UIColor(named: "color2"), UIColor(named: "color3")] as! [NSUIColor]
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        pieChartView.data = pieChartData
        
        // config legend formatting
        pieChartView.legend.font = NSUIFont(name: "Montserrat-Medium", size: 14) ?? NSUIFont.systemFont(ofSize: 14)
        
        // animate chart
        pieChartView.animate(xAxisDuration: stat.seen ? 0 : 0.75)
        pieChartView.animate(yAxisDuration: stat.seen ? 0 : 0.75)
    }
}
