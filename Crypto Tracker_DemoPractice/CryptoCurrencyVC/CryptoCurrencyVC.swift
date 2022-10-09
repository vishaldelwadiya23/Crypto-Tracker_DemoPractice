//
//  CryptoCurrencyVC.swift
//  Crypto Tracker_DemoPractice
//
//  Created by tmtech1 on 07/10/22.
//

import UIKit

class CryptoCurrencyVC: UIViewController {

    @IBOutlet weak var tblCryptoCurrency: UITableView!
    
    public var aryCryptoCurrency: [CryptoCurrencyModel] = []
    public var aryIcons: [CryptoIcons] = []
    
    // table view cell model
    private var viewModel = [CryptoTableViewCellModel]()

    let group = DispatchGroup()

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

        // register tableview cell
        let nib = UINib(nibName: Constants.cryptoCurrencyTVCellIdentifier, bundle: nil)
        tblCryptoCurrency.register(nib, forCellReuseIdentifier: Constants.cryptoCurrencyTVCellIdentifier)
        
        // let's say the crypto icons operation needs to be executed first before the crypto data operation
        let cryptoIconsBlockOperation = BlockOperation()
        cryptoIconsBlockOperation.addExecutionBlock {
            // get crypto currency icon
            let urlCryptoIcons = URL(string: Constants.currencyIconUrl)
            self.getAllCryptoIcons(url: urlCryptoIcons!)
        }
        
        let cryptoDataBlockOperation = BlockOperation()
        cryptoDataBlockOperation.addExecutionBlock {
            // get crypto currency data
            let urlCryptoData = URL(string: Constants.currencyUrl)
            self.getAllCryptoCurrencyData(url: urlCryptoData!)
        }
        
        // since we want the project operation to kick off first we add dependency
        cryptoDataBlockOperation.addDependency(cryptoIconsBlockOperation)
        
        // adding operations to the operation queue
        let operationQueue = OperationQueue()
        operationQueue.addOperation(cryptoIconsBlockOperation)
        operationQueue.addOperation(cryptoDataBlockOperation)
    }

    //MARK: - Get Crypto Currency Data Using API
    func getAllCryptoCurrencyData(url: URL) {
        
        guard !aryIcons.isEmpty else { return }
             
        print("2 enter")

        HttpUtility.shared.getApiData(requestUrl: url, requestType: [CryptoCurrencyModel].self) { [weak self] (response) in
                        
            if let responseData = response {
                
                // price sorted high to low
                self?.aryCryptoCurrency = responseData.sorted(by: { (first, second) -> Bool in
                    first.price_usd ?? 0 > second.price_usd ?? 0
                })
                
                // return crypto tableview cell
                self?.viewModel = self!.aryCryptoCurrency.compactMap({ model in
                    
                    // float to string using NumberFormatter and use currency in formatter
                    let price = model.price_usd ?? 0
                    let priceString = self?.numberFormatter.string(from: NSNumber(value: price))
                    
                    // icon url
                    let iconImgUrlString = self?.aryIcons.filter { icon in
                        icon.asset_id == model.asset_id
                    }.first?.url
                    
                    return CryptoTableViewCellModel(
                        name: model.asset_id,
                        symbol: model.asset_id,
                        price: priceString ?? "N/A",
                        iconUrl: iconImgUrlString
                    )
                })
                
                print("2 leave")
                self?.tblCryptoCurrency.hideActivityIndicator()

                DispatchQueue.main.async {
                    self?.tblCryptoCurrency.reloadData()
                }
            }
        }
    }
    
    //MARK: - Get Crypto Currency Icon Using API
    func getAllCryptoIcons(url: URL) {
        
        group.enter()
        print("1 enter")
        tblCryptoCurrency.showActivityIndicator()

        HttpUtility.shared.getApiData(requestUrl: url, requestType: [CryptoIcons].self) { [weak self] (response) in

            if let responseData = response {
                
                // price sorted high to low
                self?.aryIcons = responseData
                
                self?.group.leave()
                print("1 leave")
                
//                DispatchQueue.main.async {
//                    self?.tblCryptoCurrency.reloadData()
//                }
            }
        }
        // we need to wait for an entire execution block to complete
        group.wait()
        print("wait")
    }
}

//MARK: - Crypto currency tableview delegate method
extension CryptoCurrencyVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return aryCryptoCurrency.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cryptoCurrencyTVCellIdentifier, for: indexPath) as? CryptoCurrencyTVCell else { fatalError() }
//        cell.lblName.text = aryCryptoCurrency[indexPath.row].name
//        cell.lblSymbol.text = aryCryptoCurrency[indexPath.row].asset_id
//
//        // float to string using NumberFormatter and use currency in formatter
//        let price = aryCryptoCurrency[indexPath.row].price_usd ?? 0
//        let priceString = numberFormatter.string(from: NSNumber(value: price))
//        cell.lblPrice.text = priceString
        
        cell.configureCell(with: viewModel[indexPath.row])
        //cell.getIconUrl(aryicon: aryIcons, strAssetId: aryCryptoCurrency[indexPath.row].asset_id)
//        let iconUrl = URL(string: aryIcons.filter ({ icon in
//            icon.asset_id == aryCryptoCurrency[indexPath.row].asset_id
//        }).first?.url ?? "")

       // print(iconUrl!)
//        do {
//            let data = try Data(contentsOf: iconUrl!)
//            cell.imgIconCryptoCurrency.image = UIImage(data: data)
//        } catch let error {
//            print(error)
//        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

//MARK: - Activity indicator in tableView
extension UITableView {
    func showActivityIndicator() {
        DispatchQueue.main.async {
            let activityView = UIActivityIndicatorView(style: .large)
            self.backgroundView = activityView
            activityView.startAnimating()
        }
    }

    func hideActivityIndicator() {
        DispatchQueue.main.async {
            self.backgroundView = nil
        }
    }
}
