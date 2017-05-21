//
//  SettingViewController.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 5/16/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit
import Alamofire
import KeychainSwift

class SettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func telegramChannel(_ sender: Any) {
        let botURL = URL.init(string: "tg://resolve?domain=codemo")
        
        if UIApplication.shared.canOpenURL(botURL!) {
            UIApplication.shared.openURL(botURL!)
        } else {
            
        }
    }

    @IBAction func telegramSupport(_ sender: Any) {
        let botURL = URL.init(string: "tg://resolve?domain=mahdiyar_oraei")
        
        if UIApplication.shared.canOpenURL(botURL!) {
            UIApplication.shared.openURL(botURL!)
        } else {
            
        }
    }
    
    @IBAction func removeLicense(_ sender: Any) {
        
        let keychain = KeychainSwift()
        let parameters: Parameters = [
            "email": keychain.get("email")!,
            "app": "period_tracker"
        ]
        
        showActivityIndicator(uiView: self.view)
        Alamofire.request("\(Config.WEB_DOMAIN)/license/public/deactive", method: .post, parameters: parameters).responseJSON{ response in
            
            if let JSON = response.result.value as? [String: Any] {
                print("JSON: \(JSON)")
                self.hideActivityIndicator(uiView: self.view)
                if JSON["success"] as! Int == 1{
                    keychain.set(false, forKey: "buy")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let destinationVC = storyboard.instantiateViewController(withIdentifier: "BuyController")
                    
                    self.present(destinationVC, animated: true, completion: nil)
                }
            }
        }
    }
    var container: UIView = UIView()
    var loadingView: UIView = UIView()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    /*
     Show customized activity indicator,
     actually add activity indicator to passing view
     
     @param uiView - add activity indicator to this view
     */
    func showActivityIndicator(uiView: UIView) {
        container.frame = uiView.frame
        container.center = uiView.center
        container.backgroundColor = UIColorFromHex(rgbValue: 0xffffff, alpha: 0.3)
        
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = uiView.center
        loadingView.backgroundColor = UIColorFromHex(rgbValue: 0x444444, alpha: 0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
        loadingView.addSubview(activityIndicator)
        container.addSubview(loadingView)
        uiView.addSubview(container)
        activityIndicator.startAnimating()
    }
    
    /*
     Hide activity indicator
     Actually remove activity indicator from its super view
     
     @param uiView - remove activity indicator from this view
     */
    func hideActivityIndicator(uiView: UIView) {
        activityIndicator.stopAnimating()
        container.removeFromSuperview()
    }
    
    /*
     Define UIColor from hex value
     
     @param rgbValue - hex color value
     @param alpha - transparency level
     */
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }

}
