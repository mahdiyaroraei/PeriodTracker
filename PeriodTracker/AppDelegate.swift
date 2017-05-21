//
//  AppDelegate.swift
//  Test
//
//  Created by Mahdiar  on 3/13/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit
import Alamofire
import KeychainSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        var tabBarAppearace = UITabBar.appearance()
        tabBarAppearace.tintColor = uicolorFromHex(rgbValue: 0xE3D9D2)
        tabBarAppearace.barTintColor = uicolorFromHex(rgbValue: 0x23272F)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.white , NSFontAttributeName: UIFont(name: "IRANSans(FaNum)", size: 7)!], for: .normal)
        
        var navigationBarAppearace = UINavigationBar.appearance()
        
        navigationBarAppearace.tintColor = UIColor.white
        navigationBarAppearace.barTintColor = uicolorFromHex(rgbValue: 0x23272F)
        
        
        let parameters: Parameters = [
            "name": "period_tracker"
        ]
        
        Alamofire.request("\(Config.WEB_DOMAIN)/license/public/checkupdate", method: .post, parameters: parameters).responseJSON{ response in
            
            if let JSON = response.result.value as? [String: Any] {
                print("JSON: \(JSON)")
                
                let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
                
                if Float(JSON["version"]! as! String)! > 0.0 && Float(JSON["version"]! as! String)! > Float(version!)!{
                    let attributedString = NSAttributedString(string: "نسخه جدید", attributes: [
                        NSFontAttributeName : UIFont(name: "IRANSans(FaNum)", size: 17)
                        ])
                    
                    let alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alert.setValue(attributedString, forKey: "attributedTitle")
                    alert.setValue(NSAttributedString(string: "نسخه جدید برنامه را دانلود کنید و از ویژگی های جدید آن استفاده کنید", attributes: [
                        NSFontAttributeName : UIFont(name: "IRANSans(FaNum)", size: 13)
                        ])
                        , forKey: "attributedMessage")
                    
                    alert.addAction(UIAlertAction(title: "بله", style: UIAlertActionStyle.default, handler: {action in self.downloadUpdate(JSON["link"] as! String)}))
                    alert.addAction(UIAlertAction(title: "خیر", style: UIAlertActionStyle.cancel, handler: nil))
                    self.window?.rootViewController?.present(alert, animated: true, completion: nil)

                }
            }
        }

        
        // change navigation item title color
        navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white , NSFontAttributeName: UIFont(name: "IRANSans(FaNum)", size: 15)!]
        
        let keychain = KeychainSwift()
        if keychain.getBool("buy") != nil && keychain.getBool("buy")! {
            
            self.window = UIWindow(frame: UIScreen.main.bounds)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "BuyedController")
            
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
        }
        
        return true
    }
    
    func downloadUpdate(_ link:String) {
        
        let botURL = URL.init(string: link)
        
        if UIApplication.shared.canOpenURL(botURL!) {
            UIApplication.shared.openURL(botURL!)
        }
    }
    
    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

