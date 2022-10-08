//
//  CryptoCurrencyTVCell.swift
//  Crypto Tracker_DemoPractice
//
//  Created by tmtech1 on 07/10/22.
//

import UIKit

class CryptoTableViewCellModel {
    
    let name: String
    let symbol: String
    let price: String
    let iconUrl: String?
    
    var iconData: Data?

    init(name: String, symbol: String, price: String, iconUrl: String?) {
        self.name = name
        self.symbol = symbol
        self.price = price
        self.iconUrl = iconUrl
    }
}

class CryptoCurrencyTVCell: UITableViewCell {

    // declare variable outlet
    @IBOutlet weak var imgIconCryptoCurrency: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSymbol: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // prepare for reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imgIconCryptoCurrency.image = nil
        lblName.text = nil
        lblSymbol.text = nil
        lblPrice.text = nil
    }
    
    func configureCell(with cellModel: CryptoTableViewCellModel) {
        
        lblName.text = cellModel.name
        lblSymbol.text = cellModel.symbol
        lblPrice.text = cellModel.price
        
        print(cellModel.iconUrl as Any)
        
        if (cellModel.iconUrl != nil) {
            // icon caches in memory using class
            if let data = cellModel.iconData {
                imgIconCryptoCurrency.image = UIImage(data: data)
            } else {
                if let url = URL(string: cellModel.iconUrl!) {
                    let task = URLSession.shared.dataTask(with: url) { (data, _, _) in
                        if let data = data {
                            cellModel.iconData = data
                            DispatchQueue.main.async {
                                self.imgIconCryptoCurrency.image = UIImage(data: data)
                            }
                        }
                    }
                    task.resume()
                }
            }
        } else {
            // default project folder image url (in case not get url from api)
            imgIconCryptoCurrency.image = UIImage(named: "icon-10.png")
        }
        
        
//        let iconUrl = URL(string: aryicon.filter ({ icon in
//            icon.asset_id == strAssetId
//        }).first?.url ?? "")
//
//        do {
//            let data = try Data(contentsOf: iconUrl!)
//            self.imgIconCryptoCurrency.image = UIImage(data: data)
//        } catch let error {
//            print(error)
//        }
    }
    
    func isValidUrl(url: String) -> Bool {
        let urlRegEx = "^(https?://)?(www\\.)?([-a-z0-9]{1,63}\\.)*?[a-z0-9][-a-z0-9]{0,61}[a-z0-9]\\.[a-z]{2,6}(/[-\\w@\\+\\.~#\\?&/=%]*)?$"
        let urlTest = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
        let result = urlTest.evaluate(with: url)
        return result
    }
}
