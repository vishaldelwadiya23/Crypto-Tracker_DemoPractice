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
    static let assetsEndPoint = "https://rest.coinapi.io/v1/assets/"
    static let currencyUrl = Constants.assetsEndPoint + "?apikey=" + Constants.apikey
    
    // icon size specified in url
    static let iconsEndPoint = "https://rest.coinapi.io/v1/assets/icons/55/"
    static let currencyIconUrl = Constants.iconsEndPoint + "?apikey=" + Constants.apikey
    
    // Identifier
    static let cryptoCurrencyTVCellIdentifier = "CryptoCurrencyTVCell"

}
