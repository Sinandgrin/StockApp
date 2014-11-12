//
//  PositionsTableViewController.swift
//  StockApp
//
//  Created by Andrew Hansen on 11/8/14.
//  Copyright (c) 2014 Andrew Hansen. All rights reserved.
//

import UIKit

class PositionsTableViewController: UITableViewController {
    
    
    var stocks = ["AAPL", "APU", "BAC", "BP", "CSCO", "CVX", "ESD", "ETP", "GE", "HCN"]
    var lastPrice = [109.01, 45.42, 17.34, 42.06, 25.33, 118.80, 17.04, 66.01, 26.41, 70.62]
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        let count = stocks.count
        return count + 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // setup my number formatter to 2 decimal points
        let myNumberFormatter = NSNumberFormatter()
        myNumberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        myNumberFormatter.maximumFractionDigits = 2
        myNumberFormatter.minimumFractionDigits = 2
        
        if (indexPath.row < stocks.count) {
            let cellIdentifier = "Cell"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as CustomTableViewCell
            
            cell.symbolLabel.text = stocks[indexPath.row]
            cell.lastPriceLabel.text = "$\(myNumberFormatter.stringFromNumber(lastPrice[indexPath.row])!)"
            
            return cell
        } else {
            let cellIdentifier = "AddNewPositionCell"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as AddNewPositionCustomTableViewCell
            
            cell.newPositionLabel.text = "Tap to add symbol"
            return cell
        }
    }
    

}
