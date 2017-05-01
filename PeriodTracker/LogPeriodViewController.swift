//
//  LogPeriodViewController.swift
//  Period Tracker
//
//  Created by Mahdiar  on 5/1/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit

class LogPeriodViewController: UIViewController {

    @IBOutlet weak var navItem: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navItem.leftBarButtonItem = UIBarButtonItem(title: "done", style: .done, target: self, action: #selector(done))
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func done() {
        dismissKeyboard()
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
