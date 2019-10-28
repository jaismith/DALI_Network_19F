//
//  StatisticPieTableViewCell.swift
//  dali_network_19f
//
//  Created by Jai Smith on 10/23/19.
//  Copyright © 2019 Jai Smith. All rights reserved.
//

import UIKit
import Charts

class StatisticPieTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var chartLabel: UILabel!
    @IBOutlet weak var chartDescription: UITextView!
    
    var statistic: Statistic!
    
    // MARK: Methods:
    
    func load(from stat: Statistic) {
        // save ref to stat
        statistic = stat
        
        // set label
        chartLabel.text = stat.name
        chartDescription.text = stat.description
        print(stat.description)
        // set up pie chart
        pieChartView.chartDescription?.text = nil
        pieChartView.chartDescription?.textColor = UIColor.white
        pieChartView.drawHoleEnabled = false
        pieChartView.drawEntryLabelsEnabled = false
        pieChartView.setExtraOffsets(left: 0, top: 0, right: 0, bottom: -15)
        
        // generate PieChartData
        var chartData = [PieChartDataEntry]()
        for (key, value) in statistic.data.sorted(by: { a, b in return a.key == b.key ? a.value < b.value : a.key < b.key }) {
            chartData.append(PieChartDataEntry(value: value, label: key))
        }
        
        // add chartData to pie chart
        let pieChartDataSet = PieChartDataSet(entries: chartData, label: nil)
        pieChartDataSet.colors = [UIColor(named: "color0"), UIColor(named: "color1"), UIColor(named: "color2"), UIColor(named: "color3")] as! [NSUIColor]
        pieChartDataSet.valueFormatter = IntFormatter()
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        pieChartView.data = pieChartData
        
        // config legend formatting
        pieChartView.legend.font = NSUIFont(name: "Montserrat-Medium", size: 14) ?? NSUIFont.systemFont(ofSize: 14)
        pieChartView.legend.textColor = UIColor.white
        
        // animate chart
        pieChartView.animate(xAxisDuration: stat.seen ? 0 : 0.75)
        pieChartView.animate(yAxisDuration: stat.seen ? 0 : 0.75)
    }
}
