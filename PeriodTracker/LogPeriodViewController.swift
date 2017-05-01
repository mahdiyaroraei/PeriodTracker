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
    }
    
    func done() {
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
