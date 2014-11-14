//
//  Position.swift
//  StockApp
//
//  Created by Andrew Hansen on 11/13/14.
//  Copyright (c) 2014 Andrew Hansen. All rights reserved.
//

import Foundation

class Position {
    
    var symbol : String = ""
    var lastPrice: Double = 0
    var changeInPercent: Double = 0
    
    init (symbol:String, lastPrice:Double, changeInPercent:Double) {
        self.symbol=symbol
        self.lastPrice=lastPrice
        self.changeInPercent=changeInPercent
    }
}
    
