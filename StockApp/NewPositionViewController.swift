//
//  NewPositionViewController.swift
//  StockApp
//
//  Created by Andrew Hansen on 11/13/14.
//  Copyright (c) 2014 Andrew Hansen. All rights reserved.
//

import UIKit

class NewPositionViewController: UIViewController, UITextFieldDelegate {
    
    var addNewPositionDelegate: NewPositionDelegate?

    @IBOutlet weak var enterSymbolTextField: UITextField!
    

    @IBAction func screenTapped(sender: AnyObject) {
        enterSymbolTextField.resignFirstResponder()
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enterSymbolTextField.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        addNewPositionDelegate?.addNewPosition(enterSymbolTextField.text)
        self.navigationController?.popViewControllerAnimated(true)
        
        return true
    }
    

}
