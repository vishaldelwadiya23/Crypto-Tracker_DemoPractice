//
//  CandleStickChartVC.swift
//  Crypto Tracker_DemoPractice
//
//  Created by tmtech1 on 11/10/22.
//

import UIKit
import Charts

struct OCHLModel {
    let Kopen: Int
    let Kclose: Int
    let Khigh: Int
    let Klow: Int
    let Kval: Int
    
    init(open:Int,close:Int,high:Int,low:Int,val:Int) {
        self.Kopen = open
        self.Kclose = close
        self.Khigh = high
        self.Klow = low
        self.Kval = val
    }
}

class CandleStickChartVC: CandleChartBaseViewController {
    
    @IBOutlet weak var chartView: CandleStickChartView!
    @IBOutlet var sliderX: UISlider!
    @IBOutlet var sliderY: UISlider!
    @IBOutlet var sliderTextX: UITextField!
    @IBOutlet var sliderTextY: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Candle Stick Chart"
        self.options = [.toggleValues,
                        .toggleIcons,
                        .toggleHighlight,
                        .animateX,
                        .animateY,
                        .animateXY,
                        .saveToGallery,
                        .togglePinchZoom,
                        .toggleAutoScaleMinMax,
                        .toggleShadowColorSameAsCandle,
                        .toggleShowCandleBar,
                        .toggleData]
        
        chartView.delegate = self
        
        chartView.chartDescription.enabled = false
        
        chartView.dragEnabled = false
        chartView.setScaleEnabled(true)
        chartView.maxVisibleCount = 200
        chartView.pinchZoomEnabled = true
        
        chartView.legend.horizontalAlignment = .right
        chartView.legend.verticalAlignment = .top
        chartView.legend.orientation = .vertical
        chartView.legend.drawInside = false
        chartView.legend.font = UIFont(name: "HelveticaNeue-Light", size: 10)!
        
        chartView.leftAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 10)!
        chartView.leftAxis.spaceTop = 0.3
        chartView.leftAxis.spaceBottom = 0.3
        chartView.leftAxis.axisMinimum = 0
        
        chartView.rightAxis.enabled = false
        
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 10)!
        
        sliderX.value = 10
        sliderY.value = 50
        slidersValueChanged(nil)
    }
    
    override func updateChartData() {
        if self.shouldHideData {
            chartView.data = nil
            return
        }
        
        //self.setDataCount(Int(sliderX.value), range: UInt32(sliderY.value))
        self.setDataCount(10, range: 50)
    }
    
    func setDataCount(_ count: Int, range: UInt32) {
        
        let aryOCHL = [
            OCHLModel(open: 15, close: 20, high: 45, low: 20, val: 60),
            OCHLModel(open: 10, close: 15, high: 30, low: 25, val: 80),
            OCHLModel(open: 30, close: 40, high: 65, low: 50, val: 70),
            OCHLModel(open: 10, close: 15, high: 40, low: 30, val: 50),
            OCHLModel(open: 40, close: 35, high: 55, low: 45, val: 60),
            OCHLModel(open: 55, close: 50, high: 70, low: 60, val: 50)
        ]
        
        let yVals1 = (0..<aryOCHL.count).map { (i) -> CandleChartDataEntry in
            print(i)
            //let mult = 6 + 1                       //let mult = range + 1
            let val = Double(aryOCHL[i].Kval)   //Double(arc4random_uniform(40) + mult)
            let high = Double(aryOCHL[i].Khigh)  //Double(arc4random_uniform(9) + 8)
            let low = Double(aryOCHL[i].Klow)   //Double(arc4random_uniform(9) + 8)
            let open = Double(aryOCHL[i].Kopen)     //Double(arc4random_uniform(6) + 1)
            let close = Double(aryOCHL[i].Kclose)   //Double(arc4random_uniform(6) + 1)
            let even = i % 2 == 0
            print("value: - \(val)")
            print("high: - \(high)")
            print("low: - \(low)")
            print("open: - \(open)")
            print("close: - \(close)")
            //return CandleChartDataEntry(x: Double(i), shadowH: val + high, shadowL: val - low, open: val + open, close: val - close, icon: UIImage(named: "icon-10.png")!)
            return CandleChartDataEntry(x: Double(i), shadowH: val + high, shadowL: val - low, open: even ? val + open : val - open, close: even ? val - close : val + close, icon: UIImage(named: "icon-10.png")!)
        }
        
        let set1 = CandleChartDataSet(entries: yVals1, label: "Data Set")
        set1.axisDependency = .left
        set1.setColor(UIColor(white: 80/255, alpha: 1))
        set1.drawIconsEnabled = false
        set1.shadowColor = .darkGray
        set1.shadowWidth = 0.7
        set1.decreasingColor = .red
        set1.decreasingFilled = true
        set1.increasingColor = UIColor(red: 122/255, green: 242/255, blue: 84/255, alpha: 1)
        set1.increasingFilled = false
        set1.neutralColor = .blue
        
        let data = CandleChartData(dataSet: set1)
        chartView.data = data
    }
    /*
     func setDataCount(_ count: Int, range: UInt32) {
         let yVals1 = (0..<count).map { (i) -> CandleChartDataEntry in
             let mult = range + 1
             let val = Double(arc4random_uniform(40) + mult)
             let high = Double(arc4random_uniform(9) + 8)
             let low = Double(arc4random_uniform(9) + 8)
             let open = Double(arc4random_uniform(6) + 1)
             let close = Double(arc4random_uniform(6) + 1)
             let even = i % 2 == 0
             
             return CandleChartDataEntry(x: Double(i), shadowH: val + high, shadowL: val - low, open: even ? val + open : val - open, close: even ? val - close : val + close, icon: UIImage(named: "icon")!)
         }
         
         let set1 = CandleChartDataSet(entries: yVals1, label: "Data Set")
         set1.axisDependency = .left
         set1.setColor(UIColor(white: 80/255, alpha: 1))
         set1.drawIconsEnabled = false
         set1.shadowColor = .darkGray
         set1.shadowWidth = 0.7
         set1.decreasingColor = .red
         set1.decreasingFilled = true
         set1.increasingColor = UIColor(red: 122/255, green: 242/255, blue: 84/255, alpha: 1)
         set1.increasingFilled = false
         set1.neutralColor = .blue
         
         let data = CandleChartData(dataSet: set1)
         chartView.data = data
     }
     */
    override func optionTapped(_ option: Option) {
        switch option {
            case .toggleShadowColorSameAsCandle:
                for case let set as CandleChartDataSet in chartView.data! {
                    set.shadowColorSameAsCandle = !set.shadowColorSameAsCandle
                }
                chartView.notifyDataSetChanged()
            case .toggleShowCandleBar:
                for set in chartView.data!.dataSets as! [CandleChartDataSet] {
                    set.showCandleBar = !set.showCandleBar
                }
                chartView.notifyDataSetChanged()
            default:
                super.handleOption(option, forChartView: chartView)
        }
    }
    
    // MARK: - Actions
    @IBAction func slidersValueChanged(_ sender: Any?) {
        sliderTextX.text = "\(Int(sliderX.value))"
        sliderTextY.text = "\(Int(sliderY.value))"
        
        self.updateChartData()
    }
}
