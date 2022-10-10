//
//  CryptoCurrencyDetailTVCell.swift
//  Crypto Tracker_DemoPractice
//
//  Created by tmtech1 on 10/10/22.
//

import UIKit

class CryptoCurrencyDetailTVCell: UITableViewCell {

    @IBOutlet weak var lblOpenPrice: UILabel!
    @IBOutlet weak var lblClosePrice: UILabel!
    @IBOutlet weak var lblHighPrice: UILabel!
    @IBOutlet weak var lblLowPrice: UILabel!
    
    // number formatter for currency price float
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.allowsFloats = true
        formatter.locale = .current
        formatter.numberStyle = .currency
        formatter.formatterBehavior = .default
        return formatter
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
            
        lblOpenPrice = nil
        lblClosePrice = nil
        lblHighPrice = nil
        lblLowPrice = nil
    }
    
    func configureDetailCell(with cellModel: ExchangerateHistoryModel) {
        
        // float to string using NumberFormatter and use currency in formatter
        // open price
        let openPrice = cellModel.rate_open ?? 0
        let openPriceString = numberFormatter.string(from: NSNumber(value: openPrice))
        
        // open price
        let closePrice = cellModel.rate_close ?? 0
        let closePriceString = numberFormatter.string(from: NSNumber(value: closePrice))
        
        // open price
        let highPrice = cellModel.rate_high ?? 0
        let highPriceString = numberFormatter.string(from: NSNumber(value: highPrice))
        
        // open price
        let lowPrice = cellModel.rate_low ?? 0
        let lowPriceString = numberFormatter.string(from: NSNumber(value: lowPrice))
        
        lblOpenPrice.text = openPriceString
        lblClosePrice.text = closePriceString
        lblHighPrice.text = highPriceString
        lblLowPrice.text = lowPriceString

    }
}
