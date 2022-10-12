//
//  CandleStickChartVC.swift
//  Crypto Tracker_DemoPractice
//
//  Created by tmtech1 on 11/10/22.
//

import UIKit
import Charts

class CandleStickChartVC: CandleChartBaseViewController {
    
    // variable outlet
    @IBOutlet weak var chartView: CandleStickChartView!
    
    @IBOutlet weak var lblOpen: UILabel!
    @IBOutlet weak var lblClose: UILabel!
    @IBOutlet weak var lblHigh: UILabel!
    @IBOutlet weak var lblLow: UILabel!
    
    // chart click display value
    @IBOutlet weak var txtXvalue: UITextField!
    @IBOutlet weak var txtYvalue: UITextField!
    
    // table view cell model
    fileprivate var aryCandleChart = [CandleChartResponseModel]()
    
    var aryDate: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // URL call to get data
        let urlCandleChart = URL(string: Constants.candleChartEndPoint)
        self.getAllCandleChartData(url: urlCandleChart!)
    }
    
    func chartDraw() {
       
        // Chart initialize
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
        
        // add this (xAxis) more code for chart x axis custom display
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.granularity = 1
        xAxis.labelCount = 7
        //xAxis.valueFormatter = DayAxisValueFormatter(chart: chartView)
        xAxis.valueFormatter = DateValueFormatter(aryOpenDate: aryDate)

        chartView.dragEnabled = true
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
        
        let marker = XYMarkerView(color: UIColor(white: 180/250, alpha: 1),
                                  font: .systemFont(ofSize: 12),
                                  textColor: .white,
                                  insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8),
                                  xAxisValueFormatter: chartView.xAxis.valueFormatter!)
        marker.chartView = chartView
        marker.minimumSize = CGSize(width: 80, height: 40)
        chartView.marker = marker
        
        updateChartData()

    }
    
    
    //MARK: - Get Candle Chart Data Using API
    func getAllCandleChartData(url: URL) {
        
       // print(url)

        HttpUtility.shared.postApiData(requestUrl: url, requestBody: nil, requestType: [CandleChartResponseModel].self) { [weak self] (response) in
                        
            if let responseData = response {
                
                //print(responseData as Any)
                self?.aryCandleChart = responseData
                              
                // convert api response date to chart x axis display date
                for strDate in self?.aryCandleChart ?? [] {

                    //let string = "2017-01-27T18:36:36Z" // 2021-11-01T00:00:00.0000000Z

                    let displayDate = self?.convertDate(responseDate: strDate.time_period_start)
                    self?.aryDate.append(displayDate!)
                }
                //print(self!.aryDate)
                DispatchQueue.main.async {
                    self?.chartDraw()
                }
            }
        }
    }
    
    //MARK: - convert date - api response date to chart x axis display date
    func convertDate(responseDate: String) -> String {
        
        //let string = strDate.time_period_start  // 2021-11-01T00:00:00.0000000Z

        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale // save locale temporarily
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: responseDate)!
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.locale = tempLocale // reset the locale
        let dateString = dateFormatter.string(from: date)
        //print("EXACT_DATE : \(dateString)")
        return dateString
    }

    //MARK: - Candle stick chart method
    override func updateChartData() {
        if self.shouldHideData {
            chartView.data = nil
            return
        }
        
        //self.setDataCount(Int(sliderX.value), range: UInt32(sliderY.value))
        self.setDataCount()
    }
    
    func setDataCount() {
        
        let yVals1 = (0..<aryCandleChart.count).map { (i) -> CandleChartDataEntry in
            
            //print(i)
            
            let open = aryCandleChart[i].price_open
            let close = aryCandleChart[i].price_close
            let high = aryCandleChart[i].price_high
            let low = aryCandleChart[i].price_low

            //print("high: - \(high)")
            //print("low: - \(low)")
            //print("open: - \(open)")
            //print("close: - \(close)")
            
            let aryData = ["O": aryCandleChart[i].price_open, "C" : aryCandleChart[i].price_close, "H" :  aryCandleChart[i].price_high, "L" : aryCandleChart[i].price_low]
            
            return CandleChartDataEntry(x: Double(i), shadowH: high, shadowL: low, open: open, close: close, icon: UIImage(named: "icon.png")!, data: aryData)
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
    
    // MARK: - label display chark click
    override func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        txtXvalue.text = String(entry.x)
        txtYvalue.text = String(entry.y)
        
        //print(entry.data as Any)
        let temp = entry.data as? Dictionary<String, Any>
        if let data = temp {
            lblOpen.text = String(describing: data["O"]!)
            lblClose.text = String(describing: data["C"]!)
            lblHigh.text = String(describing: data["H"]!)
            lblLow.text = String(describing: data["L"]!)

        }
    }
}
