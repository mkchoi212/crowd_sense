//
//  ChartViewController.swift
//  CrowdSense
//
//  Created by Mike Choi on 10/29/17.
//  Copyright © 2017 Mike Choi. All rights reserved.
//

import UIKit
import Charts

class ChartViewController: UIViewController {
  
  @IBOutlet weak var blurView: UIVisualEffectView!
  @IBOutlet weak var cview: UIView!
  @IBOutlet weak var overallLabel: UILabel!
  
  var histogram: [String: Int] = [:]
  
  @IBAction func closeView(_ sender: Any) {
    dismiss(animated: true, completion: {})
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.clear
    view.isOpaque = false
    pieChart()
    overallLabel?.text = histogram.max{$0.1 < $1.1}?.key
  }

  func pieChart() {
    let chart = PieChartView(frame: self.cview.frame)
    
    var entries = [PieChartDataEntry]()
    for (e, v) in histogram {
      let entry = PieChartDataEntry(value: Double(v), label: e)
      entries.append(entry)
    }
    
    // 3. chart setup
    let set = PieChartDataSet(values: entries, label: "Reactions")
    // this is custom extension method. Download the code for more details.
    var colors: [UIColor] = []
    
    for _ in 0..<histogram.count {
      let red = Double(arc4random_uniform(256))
      let green = Double(arc4random_uniform(256))
      let blue = Double(arc4random_uniform(256))
      let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
      colors.append(color)
    }
    set.colors = colors
    let data = PieChartData(dataSet: set)
    chart.data = data
    chart.noDataText = "No data available"
    // user interaction
    chart.isUserInteractionEnabled = true
    
    let d = Description()
    chart.chartDescription = d
    chart.centerText = "Reactions"
    chart.holeRadiusPercent = 0.2
    chart.transparentCircleColor = UIColor.clear
    
    self.cview.addSubview(chart)
  }
  
}
