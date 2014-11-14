//
//  PositionsTableViewController.swift
//  StockApp
//
//  Created by Andrew Hansen on 11/8/14.
//  Copyright (c) 2014 Andrew Hansen. All rights reserved.
//

import UIKit

class PositionsTableViewController: UITableViewController, NewPositionDelegate {
    
    
    //var stocks : [(String, Double)] = [("AAPL", 1.02), ("APU", 0), ("BAC", 0), ("BP", 0), ("CSCO", 0), ("CVX", 0), ("ESD", 0), ("ETP", 0), ("GE", 0), ("HCN", 0)]
   // var lastPrice = [109.01, 45.42, 17.34, 42.06, 25.33, 118.80, 17.04, 66.01, 26.41, 70.62]
    
    var positionsArray: [Position] = [Position(symbol:"BA", lastPrice:0.0, changeInPercent:0.0)]
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Added manual pull-down to refresh control, which calles the updatePositions method
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.backgroundColor = UIColor.whiteColor()
        self.refreshControl?.tintColor = UIColor.blueColor()
        self.refreshControl?.addTarget(self, action: "updatePositions", forControlEvents: UIControlEvents.ValueChanged)
        
        
        // Adds an entry to the reciever's dispatch table to Register to listen for an NSNotification
        // Registers "self" aka PositionsTableViewCOntroller object as the observer
        // The Selector (function) that specifies the message the receiver sends notificationObserver to notify it of the notification posting.
        // Notification Name for which to register the observer. Only notifications with this name are delivered to the observer.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "positionsUpdated:", name: kNotificationPositionsUpdated, object: nil)
        self.updatePositions()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = positionsArray.count
        return count + 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // setup my number formatter to 2 decimal points 
        let myNumberFormatter = NSNumberFormatter()
        myNumberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        myNumberFormatter.maximumFractionDigits = 2
        myNumberFormatter.minimumFractionDigits = 2
        
        if (indexPath.row < positionsArray.count) {
            let cellIdentifier = "Cell"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as CustomTableViewCell
            
            cell.symbolLabel.text = positionsArray[indexPath.row].symbol
            cell.lastPriceLabel.text = "\(myNumberFormatter.stringFromNumber(positionsArray[indexPath.row].changeInPercent)!)" + "%"
            
            return cell
        } else {
            let cellIdentifier = "AddNewPositionCell"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as AddNewPositionCustomTableViewCell
            
            cell.newPositionLabel.text = "Tap to add symbol"
            return cell
        }
    }
    // function to remove position from table
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            self.positionsArray.removeAtIndex(indexPath.row)
            
            self.tableView.reloadData()
        }
    }
    
    
    func updatePositions() {
        let positionManager:StockDataAggregator = StockDataAggregator.sharedInstance
        positionManager.updateListOfPositions(positionsArray)
        
        
//        // Repeat this method every 15 seconds on a background thread
//        dispatch_after(
//            dispatch_time(DISPATCH_TIME_NOW, Int64(15 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(),
//            {
//            self.updatePositions()
//        })
    }
    
    
    func positionsUpdated(notification : NSNotification) {
        let values = (notification.userInfo as Dictionary<String,NSArray>)
        let stocksRecieved: Array = values[kNotificationPositionsUpdated]!
        positionsArray.removeAll(keepCapacity: false)
        for quote in stocksRecieved {
            let quoteDict: NSDictionary = quote as NSDictionary
            var changeInPercentString = quoteDict["ChangeinPercent"] as String
            let changeInPercentClean: NSString = (changeInPercentString as NSString).substringToIndex(countElements(changeInPercentString)-1)
            positionsArray.append(Position(symbol: quoteDict["symbol"] as String, lastPrice: 0.0, changeInPercent: changeInPercentClean.doubleValue))
        }
        tableView.reloadData()
        NSLog("Positions data updated")
        
        // End the refresh and add Last Updated title
        let formatter = NSDateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("MM d, h:mm a")
        let date = formatter.stringFromDate(NSDate())
        let title: NSString = "Last update: \(date)"
        let attributedTitle = NSAttributedString(string: title)
        self.refreshControl?.attributedTitle = attributedTitle
        
        self.refreshControl?.endRefreshing()
    }
    
    
    func addNewPosition(symbol: NSString) {
        positionsArray.append(Position(symbol: symbol, lastPrice: 0.0, changeInPercent: 0.0))
        self.updatePositions()
        
    
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // if this
        if let newPositionViewControl = segue.destinationViewController as? NewPositionViewController {
            newPositionViewControl.addNewPositionDelegate = self
        }
    }
    

}
