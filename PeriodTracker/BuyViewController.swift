//
//  BuyViewController.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 5/14/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit
import Alamofire

class BuyViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var codeTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buyApp(_ sender: Any) {
        let parameters: Parameters = [
            "email": emailTextField.text,
            "app": "period_tracker"
        ]
        
        Alamofire.request("http://192.168.1.5/license/public/buy", method: .post, parameters: parameters).responseJSON{ response in
            print(response.request)  // original URL request
            print(response.response) // HTTP URL response
            print(response.data)     // server data
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value as? [String: Any] {
                print("JSON: \(JSON)")
                
                let url = URL(string: "http://192.168.1.5/license/public/pay/\(JSON["license_id"]!)")!
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
