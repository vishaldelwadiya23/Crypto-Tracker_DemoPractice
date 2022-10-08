//
//  CryptoModel.swift
//  Crypto Tracker_DemoPractice
//
//  Created by tmtech1 on 07/10/22.
//

import Foundation

struct CryptoCurrencyModel: Codable {
    
    let asset_id: String
    let name: String?
    let price_usd: Float?
    let id_icon: String?
}

struct CryptoIcons: Codable {
    
    let asset_id: String
    let url: String
}

//MARK: - Url Response
/*
 "asset_id": "BTC",
 "name": "Bitcoin",
 "type_is_crypto": 1,
 "data_quote_start": "2014-02-24T17:43:05.0000000Z",
 "data_quote_end": "2022-10-07T00:00:00.0000000Z",
 "data_orderbook_start": "2014-02-24T17:43:05.0000000Z",
 "data_orderbook_end": "2022-10-07T00:00:00.0000000Z",
 "data_trade_start": "2010-07-17T23:09:17.0000000Z",
 "data_trade_end": "2022-10-07T00:00:00.0000000Z",
 "data_symbols_count": 116886,
 "volume_1hrs_usd": 1415984550930.74,
 "volume_1day_usd": 63958043224545.06,
 "volume_1mth_usd": 2.0570587298996937e+21,
 "price_usd": 19954.195615653425,
 "id_icon": "4caf2b16-a017-4e26-a348-2cea69c34cba",
 "data_start": "2010-07-17",
 "data_end": "2022-10-07"
 */
