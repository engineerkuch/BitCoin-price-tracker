//
//  CoinModel.swift
//  ByteCoin
//
//  Created by Kelvin KUCH on 01.11.2022.
//  Copyright © 2022 The App Brewery. All rights reserved.
//

import Foundation

struct CoinModel {
    let rate: Double
    let assetIdQuote: String
    
    var rateString: String {
        return String(format: "%.2f", arguments: [self.rate])
    }
    
    var assetIdQuoteString: String {
        return self.assetIdQuote
    }
}
