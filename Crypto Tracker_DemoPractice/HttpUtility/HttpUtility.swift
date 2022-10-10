//
//  HttpUtility.swift
//  Crypto Tracker_DemoPractice
//
//  Created by tmtech1 on 07/10/22.
//

import Foundation
import SystemConfiguration

struct HttpUtility {
    
    static let shared = HttpUtility()
    private init() {}
    
    public func getApiData<T:Decodable>(requestUrl: URL, requestType: T.Type, completionHandler: @escaping (_ result: T?) -> Void) {
    
        //print(requestUrl)

        let task = URLSession.shared.dataTask(with: requestUrl) { (responseData, httpUrlResponse, error) in
            
            guard let data = responseData, error == nil else { return }
            
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                //print(result)
                _ = completionHandler(result)
            } catch let error {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    public func postApiData<T:Decodable>(requestUrl: URL, requestBody: Data?, requestType: T.Type, completionHandler: @escaping (_ result: T?) -> Void) {
    
        var urlRequest = URLRequest(url: requestUrl)
        urlRequest.httpMethod = "GET"
        //urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        urlRequest.addValue(Constants.apikey, forHTTPHeaderField: "X-CoinAPI-Key")
        
        //print(urlRequest)
        //print(urlRequest.allHTTPHeaderFields!)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (responseData, httpUrlResponse, error) in
            
            guard let data = responseData, error == nil else { return }
            
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                //print(result)
                _ = completionHandler(result)
            } catch let error {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}
