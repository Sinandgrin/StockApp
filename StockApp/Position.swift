//
//  Position.swift
//  StockApp
//
//  Created by Andrew Hansen on 11/13/14.
//  Copyright (c) 2014 Andrew Hansen. All rights reserved.
//

import Foundation

class Position: NSObject, NSCoding {
    
    var symbol : String = ""
    var lastPrice: Double = 0
    var percentDayChange: Double = 0
    var dollarDayChange: Double = 0
    
    init (symbol:String) {
        self.symbol = symbol
        self.lastPrice = 0.0
        self.percentDayChange = 0.0
        self.dollarDayChange = 0.0
    }
    
    init (symbol:String, lastPrice:Double, percentDayChange:Double, dollarDayChange:Double) {
        self.symbol = symbol
        self.lastPrice = lastPrice
        self.percentDayChange = percentDayChange
        self.dollarDayChange = dollarDayChange
    }
    

    required init(coder aDecoder: NSCoder) {
        self.symbol = aDecoder.decodeObjectForKey("symbolKey") as String
        self.lastPrice = aDecoder.decodeDoubleForKey("lastPriceKey")
        self.percentDayChange = aDecoder.decodeDoubleForKey("percentDayChangeKey")
        self.dollarDayChange = aDecoder.decodeDoubleForKey("dollarDayChangeKey")
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.symbol, forKey: "symbolKey")
        aCoder.encodeDouble(self.lastPrice, forKey: "lastPriceKey")
        aCoder.encodeDouble(self.percentDayChange, forKey: "percentDayChangeKey")
        aCoder.encodeDouble(self.dollarDayChange, forKey: "dollarDayChangeKey")
    }
}
    
