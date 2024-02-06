//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate{
    func didPriceUpdate(lastPrice: String, currency: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    //Any class that wants to act as delegate should adopt the protocol CoinManagerDelegate
    
    var delegate: CoinManagerDelegate?
    var cur: String?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "A39FB78C-5C6C-48A6-8320-2533DD0CCF99"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    mutating func getCoinPrice(for currency: String){
        let url = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        cur = currency
        performRequest(with: url)
        
    }
    
    func performRequest(with urlString: String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) {(data, response, error) in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                }
                if let safeData = data {
                    if let btcPrice = self.parseJSON(safeData){
                        let btcPriceString = String(format: "%.2f",btcPrice)
                        delegate?.didPriceUpdate(lastPrice: btcPriceString, currency: cur!)
                    }
                    
                }
            }
            task.resume()
        }
        
        
    }
    
    func parseJSON(_ data: Data) -> Double? {
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let lastPrice = decodedData.rate
            print(lastPrice)
            return lastPrice
            
        } catch{
            print("err")
            return nil
            
        }
        
    }
    
}
    
