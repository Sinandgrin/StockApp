//
//  PositionsTableViewController.swift
//  StockApp
//
//  Created by Andrew Hansen on 11/8/14.
//  Copyright (c) 2014 Andrew Hansen. All rights reserved.
//

import UIKit

class PositionsTableViewController: UITableViewController, NewPositionDelegate {
    
    
    
    var positionsArray:[Position] = []
    let dataArchiveFileName = "data.archive"
    
    let testArray = ["apple", "tree", "frog"]
    
    
//        Position(symbol:"AAPL"),
//        Position(symbol:"GOOG"),
//        Position(symbol:"MSFT"),
//        Position(symbol:"TSLA"),
//        Position(symbol:"GM"),
//        Position(symbol:"F"),
//        Position(symbol:"WMT")
    
    
    func getDataFilePath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentsDirectory = paths[0] as String
        return documentsDirectory.stringByAppendingPathComponent(dataArchiveFileName)
    }
    
    
    func load() {
        let filePath = self.getDataFilePath()
        if (NSFileManager.defaultManager().fileExistsAtPath(filePath)) {
           positionsArray = NSKeyedUnarchiver.unarchiveObjectWithFile(filePath) as [Position]
        }
    }
    
    
    func save() {
        let filePath = self.getDataFilePath()
        let success = NSKeyedArchiver.archiveRootObject(positionsArray, toFile: filePath)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        load()
        
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
            cell.lastPriceLabel.text = "$\(myNumberFormatter.stringFromNumber(positionsArray[indexPath.row].lastPrice)!)"
            cell.percentDayChangeLabel.text = "(\(myNumberFormatter.stringFromNumber(positionsArray[indexPath.row].percentDayChange)!)" + "%)"
            cell.dollarDayChangeLabel.text = "\(myNumberFormatter.stringFromNumber(positionsArray[indexPath.row].dollarDayChange)!)"
            
            switch positionsArray[indexPath.row].dollarDayChange {
            case let x where x < 0.0:
                cell.dollarDayChangeLabel.textColor = UIColor(red: 255.0/255.0, green: 59/255, blue: 48/255, alpha: 1)
                cell.percentDayChangeLabel.textColor = UIColor(red: 255.0/255.0, green: 59/255, blue: 48/255, alpha: 1)
            case let x where x > 0.0:
                cell.dollarDayChangeLabel.textColor = UIColor(red: 5/255, green: 185/255, blue: 95/255, alpha: 1)
                cell.percentDayChangeLabel.textColor = UIColor(red: 5/255, green: 185/255, blue: 95/255, alpha: 1)
            case let x:
                cell.dollarDayChangeLabel.textColor = UIColor(red: 44/255, green: 186/255, blue: 231/255, alpha: 1)
                cell.percentDayChangeLabel.textColor = UIColor(red: 44/255, green: 186/255, blue: 231/255, alpha: 1)
            }
            
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
            save()
            self.tableView.reloadData()
        }
    }
    
    
    func updatePositions() {
        if positionsArray.count > 0 {
            let positionManager:StockDataAggregator = StockDataAggregator.sharedInstance
            positionManager.updateListOfPositions(positionsArray)
            
            
            //        // Repeat this method every 15 seconds on a background thread
            //        dispatch_after(
            //            dispatch_time(DISPATCH_TIME_NOW, Int64(15 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(),
            //            {
            //            self.updatePositions()
            //        })
        }
    }
    
    
    func positionsUpdated(notification : NSNotification) {
        let values = (notification.userInfo as Dictionary<String,NSArray>)
        let stocksRecieved: Array = values[kNotificationPositionsUpdated]!
        positionsArray.removeAll(keepCapacity: false)
        for quote in stocksRecieved {
            let quoteDict: NSDictionary = quote as NSDictionary
            var changeInPercentString = quoteDict["ChangeinPercent"] as String
            let changeInPercentCleaned: NSString = (changeInPercentString as NSString).substringToIndex(countElements(changeInPercentString)-1)
            var lastPriceString = quoteDict["LastTradePriceOnly"] as String
            let lastPriceStringNsed: NSString = (lastPriceString as NSString)
            let dollarDayChangeNsed: NSString = (quoteDict["Change"] as NSString)
            positionsArray.append(Position(symbol: quoteDict["symbol"] as String, lastPrice: lastPriceStringNsed.doubleValue, percentDayChange: changeInPercentCleaned.doubleValue, dollarDayChange: dollarDayChangeNsed.doubleValue))
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
        save()
    
    }
    
    
    func addNewPosition(symbol: NSString) {
        positionsArray.append(Position(symbol: symbol))
        self.updatePositions()
        
    
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // if this
        if let newPositionViewControl = segue.destinationViewController as? NewPositionViewController {
            newPositionViewControl.addNewPositionDelegate = self
        }
    }
    

}
