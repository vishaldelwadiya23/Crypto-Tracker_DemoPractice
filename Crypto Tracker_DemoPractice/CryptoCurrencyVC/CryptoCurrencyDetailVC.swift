//
//  CryptoCurrencyDetailVC.swift
//  Crypto Tracker_DemoPractice
//
//  Created by tmtech1 on 10/10/22.
//

import UIKit

class CryptoCurrencyDetailVC: UIViewController {

    @IBOutlet weak var imgIconAssets: UIImageView!
    @IBOutlet weak var lblAssetsTitle: UILabel!
    
    @IBOutlet weak var tblAssetsHistory: UITableView!
    
    public var aryAssetsHistory: [ExchangerateHistoryModel] = []

    // static days of history pass
    let strPeriod = "1DAY"
    
    var strNameTitle: String = ""
    var strAssetsId: String = ""
    var dataIconImage: Data?

    // number formatter for currency price float
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.allowsFloats = true
        formatter.locale = .current
        formatter.numberStyle = .currency
        formatter.formatterBehavior = .default
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // setup UI
        setupUI()
        
        // register cell
        let nib = UINib(nibName: Constants.cryptoCurrencyDetailTVCellIdentifier, bundle: nil)
        tblAssetsHistory.register(nib, forCellReuseIdentifier: Constants.cryptoCurrencyDetailTVCellIdentifier)
        
        // time for history show - minus 5 minutes form current time
        let currentDate = Date()
        let minusminutes = currentDate.addingTimeInterval(TimeInterval(-5.0 * 60.0))
        let dateFormatter = ISO8601DateFormatter()
        let strTime = dateFormatter.string(from: minusminutes)
        
        print(strTime)
        
        // time for history show - minus 5 minit form current time
        let current = Date()
        let dateFormatter1 = ISO8601DateFormatter()
        let strTime1 = dateFormatter.string(from: current)
        
        print(strTime1)
        
        //https://rest.coinapi.io/v1/exchangerate/BTC/USD/history?period_id=1DAY&time_start=2022-09-10T00:00:00
        let urlString = URL(string: Constants.assetsHistoryEndPoint + strAssetsId + Constants.periodHistory + strPeriod + Constants.timeHistory + strTime)
        print(urlString as Any)
        getExchangeRate(url: urlString!)
    }
    
    func setupUI() {
        
        lblAssetsTitle.text = strNameTitle
        
        // icon image
        if (dataIconImage != nil) {
            imgIconAssets.image = UIImage(data: dataIconImage!)

        } else {
            imgIconAssets.image = UIImage(named: "icon-10.png")
        }
    }
    
    //MARK: - Get Crypto Currency Icon Using API
    func getExchangeRate(url: URL) {
        
        //print(url)
        tblAssetsHistory.showActivityIndicator()

        HttpUtility.shared.postApiData(requestUrl: url, requestBody: nil, requestType: [ExchangerateHistoryModel].self) { [weak self] (response) in

            if let responseData = response {
                
                print(responseData as Any)
                self?.aryAssetsHistory = responseData
                                
                DispatchQueue.main.async {
                    self?.tblAssetsHistory.reloadData()
                    self?.tblAssetsHistory.hideActivityIndicator()

                }
            }
        }
    }
}

extension CryptoCurrencyDetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return aryAssetsHistory.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cryptoCurrencyDetailTVCellIdentifier, for: indexPath) as? CryptoCurrencyDetailTVCell else { fatalError() }
        
        cell.configureDetailCell(with: aryAssetsHistory[indexPath.row])
        
        return cell
    }


}
