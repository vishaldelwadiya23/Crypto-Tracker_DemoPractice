//
//  Constants.swift
//  Crypto Tracker_DemoPractice
//
//  Created by tmtech1 on 07/10/22.
//

import Foundation

final class Constants {
    
    // api key - coinapi.io
    static let apikey = "11B30C1D-53B7-4738-80B4-57D5E1A57514"
    static let assetsEndPoint = "https://rest.coinapi.io/v1/assets"
    static let currencyUrl = Constants.assetsEndPoint + "/?apikey=" + Constants.apikey
    
    // icon size specified in url
    static let iconsEndPoint = "https://rest.coinapi.io/v1/assets/icons/55"
    static let currencyIconUrl = Constants.iconsEndPoint + "/?apikey=" + Constants.apikey
    
    // assets history
    static let assetsHistoryEndPoint = "https://rest.coinapi.io/v1/exchangerate/"
    static let periodHistory = "/USD/history?period_id="
    static let timeHistory = "&time_start="
    
    // Identifier
    static let cryptoCurrencyDetailVCIdentifier = "CryptoCurrencyDetailVC"
    
    // Cell Identifier
    static let cryptoCurrencyTVCellIdentifier = "CryptoCurrencyTVCell"
    static let cryptoCurrencyDetailTVCellIdentifier = "CryptoCurrencyDetailTVCell"

    // candle stick chart url
    //static let candleChartEndPoint = "https://rest.coinapi.io/v1/ohlcv/BITSTAMP_SPOT_BTC_USD/latest?period_id=1MIN"
    static let candleChartEndPoint = "https://rest.coinapi.io/v1/ohlcv/BITSTAMP_SPOT_BTC_USD/history?period_id=1MTH&time_start=2021-10-12T00:00:00"

    
}
