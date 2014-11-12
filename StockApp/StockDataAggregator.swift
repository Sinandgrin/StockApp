//
//  StockDataAggregator.swift
//  StockApp
//
//  Created by Andrew Hansen on 11/12/14.
//  Copyright (c) 2014 Andrew Hansen. All rights reserved.
//

import Foundation

class StockDataAggregator {
    
    //singleton Init
    class var sharedInstance : StockDataAggregator {
        struct Static {
            static let instance : StockDataAggregator = StockDataAggregator()
        }
        return Static.instance
    }
    
    func updateListOfPositions(positions: [String] ) ->() {
        
        // The YAHOO Finance API: Request for a list of symbols
        //http://query.yahooapis.com/v1/public/yql?q=select * from yahoo.finance.quotes where symbol IN ("AAPL","GOOG","FB")&format=json&env=http://datatables.org/alltables.env
        
        //Building the URL from above with the baked array of symbols
        
        var stringQuotes = "("
        for symbol in positions {
            stringQuotes = stringQuotes+"\""+symbol+"\","
        }
        stringQuotes = stringQuotes.substringToIndex(stringQuotes.endIndex.predecessor())
        stringQuotes = stringQuotes+")"
        
        var urlString = ("http://query.yahooapis.com/v1/public/yql?q=select * from yahoo.finance.quotes where symbol IN "+stringQuotes+"&format=json&env=http://datatables.org/alltables.env").stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        var url = NSURL (string: urlString!)
        var request = NSURLRequest(URL: url!)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
    }
    
}
