//
//  AppDelegate.swift
//  Test
//
//  Created by Mahdiar  on 3/13/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit
import Gecco
import Alamofire
import KeychainSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate , SpotlightViewControllerDelegate {

    var window: UIWindow?
    
    var spotlightView : SpotlightView! = nil
    var spotlightViewController : SpotlightViewController! = nil


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
        
        if UserDefaults.standard.bool(forKey: "tut") {
            showTutorials()
        }
        
        return true
    }
    
    var noteLabel : UILabel! = nil
    func showTutorials() {
        ImagesViewController.tutState = true
        
        if ImagesViewController.instance != nil {
            ImagesViewController.instance?.viewDidAppear(false)
        }
        
        stepIndex = 0
        spotlightViewController = SpotlightViewController()
        self.spotlightView = spotlightViewController.spotlightView
        
        
        spotlightViewController.delegate = self
        
        self.window!.rootViewController?.present(spotlightViewController, animated: true, completion: nil)
        
        
        let screenSize = UIScreen.main.bounds.size
        
        noteLabel = UILabel(frame: CGRect(x: 0, y: 90, width: screenSize.width , height: 100))
        noteLabel.textAlignment = .center
        noteLabel.text = "Testing...123"
        noteLabel.numberOfLines = 5
        noteLabel.font = UIFont(name: "IRANSans(FaNum)", size: 13)
        noteLabel.backgroundColor = UIColorFromHex(rgbValue: 0x000000, alpha: 0.8)
        noteLabel.textColor = UIColor.white
        
        spotlightViewController.view.addSubview(noteLabel)
        
    }
    
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    var stepIndex: Int = 0
    let notes : [String] = ["برای پیشبینی زمان پریودی شما در آینده ابتدا روز اول آخرین پریودیتان را از روی تقویم انتخاب کنید!"
        , "برای ثبت یادداشت بعد از وارد کردن اطلاعات پریودیتان روی روز مورد نظر از روی تقویم کلیک کنید"
        , "بخش مهم دیگر این برنامه برای ثبت و پریودی های گذشته شما است به این منظور بروی این دکمه کلیک کنید و سپس روز های مورد نظر را انتخاب کنید"
        , "برای تنظیم دوباره اطلاعات پریودیتان روی این دکمه کلیک کنید"
    ,""]
    
    func next(_ labelAnimated: Bool) {
        
        noteLabel.text = notes[stepIndex]
        
        let screenSize = UIScreen.main.bounds.size
        switch stepIndex {
        case 0:
            spotlightView.appear(Spotlight.RoundedRect(center: CGPoint(x: screenSize.width / 2, y: screenSize.height / 2 + 45), size: CGSize(width: screenSize.width - 10 , height: screenSize.height / 2 - 15), cornerRadius: 6))
        case 1:
            spotlightView.move(Spotlight.Oval(center: CGPoint(x: screenSize.width / 2 , y: screenSize.height / 2 + 10) , diameter: 50))
        case 2:
            spotlightView.move(Spotlight.RoundedRect(center: CGPoint(x: 46, y: screenSize.height - 75), size: CGSize(width: 90, height: 35), cornerRadius: 6), moveType: .disappear)
        case 3:
            spotlightView.move(Spotlight.RoundedRect(center: CGPoint(x: screenSize.width - 46 , y: screenSize.height - 75), size: CGSize(width: 90, height: 35), cornerRadius: 6), moveType: .disappear)
        case 4:
            ImagesViewController.tutState = false
            UserDefaults.standard.set(false, forKey: "tut")
            spotlightViewController.dismiss(animated: true, completion: nil)
        default:
            break
        }
        
        stepIndex += 1
    }
    
    func spotlightViewControllerWillPresent(_ viewController: SpotlightViewController, animated: Bool) {
        next(false)
    }
    
    func spotlightViewControllerTapped(_ viewController: SpotlightViewController, isInsideSpotlight: Bool) {
        next(true)
    }
    
    func spotlightViewControllerWillDismiss(_ viewController: SpotlightViewController, animated: Bool) {
        spotlightView.disappear()
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

