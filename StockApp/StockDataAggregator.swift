//
//  StockDataAggregator.swift
//  StockApp
//
//  Created by Andrew Hansen on 11/12/14.
//  Copyright (c) 2014 Andrew Hansen. All rights reserved.
//

import Foundation
let kNotificationPositionsUpdated = "positionsUpdated"

class StockDataAggregator {
    
    //singleton Init
    class var sharedInstance : StockDataAggregator {
        struct Static {
            static let instance : StockDataAggregator = StockDataAggregator()
        }
        return Static.instance
    }
    
    func updateListOfPositions(positions: Array<Position>) ->() {
        
        // The YAHOO Finance API: Request for a list of symbols
        //http://query.yahooapis.com/v1/public/yql?q=select * from yahoo.finance.quotes where symbol IN ("AAPL","GOOG","FB")&format=json&env=http://datatables.org/alltables.env
        
        //Building the URL from above with the baked array of symbols
        
        var stringQuotes = "("
        for position in positions {
            stringQuotes = stringQuotes+"\""+position.symbol+"\","
        }
        stringQuotes = stringQuotes.substringToIndex(stringQuotes.endIndex.predecessor())
        stringQuotes = stringQuotes+")"
        
        var urlString = ("http://query.yahooapis.com/v1/public/yql?q=select * from yahoo.finance.quotes where symbol IN "+stringQuotes+"&format=json&env=http://datatables.org/alltables.env").stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        var url = NSURL (string: urlString!)
        var request = NSURLRequest(URL: url!)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            
            if (error != nil) {
                println("URL Task error \(error.localizedDescription)")
            } else {
                var err: NSError?
                
                // Deserailize the JSON respoonse to a Dictionary, passing in "data" from the completionHandler of my URL task, setting the options to mutable containers, and using my NSError object called "err"
                var jsonDict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
                if (err != nil) {
                    println("JSON Error \(err?.localizedDescription)")
                } else {
                    // Parse down and retrieve the quote data from the JSON response
                    if let quotes: NSArray = ((jsonDict.objectForKey("query") as NSDictionary).objectForKey("results") as NSDictionary).objectForKey("quote") as? NSArray {
                        dispatch_async(dispatch_get_main_queue(), {
                            NSNotificationCenter.defaultCenter().postNotificationName(kNotificationPositionsUpdated, object: nil, userInfo: [kNotificationPositionsUpdated:quotes])
                        })

                    } else if let quote: NSDictionary = ((jsonDict.objectForKey("query") as NSDictionary).objectForKey("results") as NSDictionary).objectForKey("quote") as? NSDictionary {
                        dispatch_async(dispatch_get_main_queue(), {
                            NSNotificationCenter.defaultCenter().postNotificationName(kNotificationPositionsUpdated, object: nil, userInfo: [kNotificationPositionsUpdated:[quote]])
                        })
                    }
                    
                }
            }
        })
        
        // call the resume method of the URL Task to begin
        task.resume()
    }
    
}
