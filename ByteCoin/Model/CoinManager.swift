//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateCoinPrice(_ coinManager: CoinManager, _ coinModel: CoinModel)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "API KEY GOES HERE"
    var delegate: CoinManagerDelegate?
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    
    func getCoinPrice(for currency: String) {
        let url = "https://rest.coinapi.io/v1/exchangerate/BTC/\(currency)?apikey=\(apiKey)"
        performRequest(with: url)
    }
    
    func performRequest(with urlString: String) {
        
        // 1. Creating a URL
        
        if let url = URL(string: urlString) {
            
            // 2. Create a URLSession
            
            let session = URLSession(configuration: .default)
            
            
            // 3. Create a session task
            
            let task = session.dataTask(with: url) { (data, response, error) -> Void in
                if error != nil {
                    print("[!] Error: \(error!)\n.....\n")
                    delegate?.didFailWithError(error: error!)
                    print("\n.....\n")
                    return
                }
                
                if let safeData = data {
                    print("safeData: \(String(data: safeData, encoding: .utf8) ?? "nillllllll")")
                    print("------ParsingData Started-------")
                    if let parsedCoinData = parseJSON(safeData) {
                        print("parsedCoinData: \(parsedCoinData)")
                        self.delegate?.didUpdateCoinPrice(self, parsedCoinData)
                        print("------ParsingData Ended-------")
                    }
                }
            }
            
            
            // 4. Start the task
            task.resume()
        }
        
        
    }
    
    func parseJSON(_ coinData: Data) -> CoinModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            let coinModel = CoinModel(rate: decodedData.rate, assetIdQuote: decodedData.asset_id_quote)
            print("coinModel: \(coinData)")
            return coinModel
        } catch {
            print("[!] an error occuried while decoding data. \(error)")
            return nil
        }
    }
    
}
