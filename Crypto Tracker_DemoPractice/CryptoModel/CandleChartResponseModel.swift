//
//  CandleChartResponseModel.swift
//  Crypto Tracker_DemoPractice
//
//  Created by tmtech1 on 12/10/22.
//

import Foundation

public struct CandleChartResponseModel: Codable {
    
    let price_open: Double
    let price_close: Double
    let price_high: Double
    let price_low: Double
    
    let time_period_start: String
    let time_period_end: String
    let time_open: String
    let time_close: String
}

/*
"time_period_start": "2022-10-12T06:47:00.0000000Z",
"time_period_end": "2022-10-12T06:48:00.0000000Z",
"time_open": "2022-10-12T06:47:00.0220000Z",
"time_close": "2022-10-12T06:47:49.9800000Z",
"price_open": 19185.000000000,
"price_high": 19196.000000000,
"price_low": 19176.000000000,
"price_close": 19176.000000000,
"volume_traded": 2.856347780,
"trades_count": 16
*/
