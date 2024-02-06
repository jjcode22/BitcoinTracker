//
//  CoinData.swift
//  ByteCoin
//
//  Created by JJ on 06/02/24.
//  Copyright © 2024 The App Brewery. All rights reserved.
//

import Foundation

//property names have to be EXACTLY THE SAME as the JSON keys
struct CoinData: Decodable {
    let rate:Double
    
}
