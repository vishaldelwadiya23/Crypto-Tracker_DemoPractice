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
        
        // icon size specified in url
        static let iconsEndPoint = "https://rest.coinapi.io/v1/assets/icons/55/"
    }
    
    private init() {}
    
    public var icons: [Icons] = []
    
    private var whenReadyBlock: ((Result<[CryptoModel], Error>) -> Void)?
    
    //MARK: - Public
    public func getAllCryptoData(completionHandler: @escaping (Result<[CryptoModel], Error>) -> Void) {
        
        guard !icons.isEmpty else {
            
            whenReadyBlock = completionHandler
            return
        }
        guard let url = URL(string: Constants.assetsEndPoint + "?apikey=" + Constants.apikey) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            
            guard let data = data, error == nil else { return }
            
            do {
                // decode response
                let cryptos = try JSONDecoder().decode([CryptoModel].self, from: data)
                
                // price sorted high to low
                completionHandler(.success(cryptos.sorted { (first, second) -> Bool in
                    return first.price_usd ?? 0 > second.price_usd ?? 0
                }))
                //completionHandler(.success(cryptos))
                
            } catch let error {
                completionHandler(.failure(error))
            }
        }
        task.resume()
    }
    
    //MARK: - Icon
    public func getAllIcons() {
        
        guard let url = URL(string: Constants.iconsEndPoint + "?apikey=" + Constants.apikey) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, _, error) in
            
            guard let data = data, error == nil else { return }
            
            do {
                self?.icons = try JSONDecoder().decode([Icons].self, from: data)
                if let completion = self?.whenReadyBlock {
                    self?.getAllCryptoData(completionHandler: completion)
                }
                
            } catch let error {
                
                print(error)
            }
        }
        task.resume()
    }
}
