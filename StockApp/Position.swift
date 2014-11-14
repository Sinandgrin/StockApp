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
    var percentDayChange: Double = 0
    var dollarDayChange: Double = 0
    
    init (symbol:String, lastPrice:Double, percentDayChange:Double, dollarDayChange:Double) {
        self.symbol=symbol
        self.lastPrice=lastPrice
        self.percentDayChange=percentDayChange
        self.dollarDayChange=dollarDayChange
    }
}
    
