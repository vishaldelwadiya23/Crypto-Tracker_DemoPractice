//
//  APICaller.swift
//  PushNotification_DemoPractice
//
//  Created by tmtech1 on 06/10/22.
//

import Foundation

final class APICaller {
    
    static let shared = APICaller()
    
    private struct Constants {
        static let apikey = "11B30C1D-53B7-4738-80B4-57D5E1A57514"
        static let assetsEndPoint = "https://rest.coinapi.io/v1/assets/"
    }
    
    private init() {}
    
    //MARK: - Public
    public func getAllCryptoData(completionHandler: @escaping (Result<[CryptoModel], Error>) -> Void) {
        
        guard let url = URL(string: Constants.assetsEndPoint + "?apikey=" + Constants.apikey) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            
            guard let data = data, error == nil else { return }
            
            do {
                // decode response
                let cryptos = try JSONDecoder().decode([CryptoModel].self, from: data)
                completionHandler(.success(cryptos))
                
            } catch let error {
                completionHandler(.failure(error))
            }
        }
        task.resume()
    }
}
