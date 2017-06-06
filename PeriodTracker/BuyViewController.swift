//
//  BuyViewController.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 5/14/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit
import Intro
import Alamofire
import AMPopTip
import RealmSwift
import KeychainSwift

class BuyViewController: UIViewController {
    
    var showIntro = true
    var isBuyMode = true;
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var actionBtn: UIButton!
    @IBOutlet weak var toggleBtn: UIButton!
    @IBOutlet weak var actionBgView: UIView!
    @IBOutlet weak var headerBgView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "license_bg")
        backgroundImage.contentMode =  UIViewContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
        // Shadow and Radius
        actionBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        actionBtn.layer.shadowOffset = CGSize(width: 0, height: 2)
        actionBtn.layer.shadowOpacity = 1.0
        actionBtn.layer.shadowRadius = 0.0
        actionBtn.layer.masksToBounds = false
        actionBtn.layer.cornerRadius = 4.0
        
        codeTextField.isEnabled = false
        codeTextField.backgroundColor = Utility.uicolorFromHex(rgbValue: 0xEEEEEE)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func viewDidLayoutSubviews() {
        
        let p = UIBezierPath(roundedRect: headerBgView.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 5, height: 5))
        let m = CAShapeLayer()
        m.path = p.cgPath
        headerBgView.layer.mask = m
        
        let path = UIBezierPath(roundedRect: actionBgView.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 5, height: 5))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        actionBgView.layer.mask = mask
    }
    
    @IBAction func resendCode(_ sender: Any) {
        
        if (emailTextField.text?.isEmpty)! {
            
            let popTip = PopTip()
            popTip.font = UIFont(name: "IRANSans(FaNum)", size: 14)!
            popTip.show(text: "لطفا ایمیل را وارد کنید", direction: .up, maxWidth: 200, in: self.view, from: self.emailTextField.frame, duration: 3)
            
            return
        }
        
        let parameters: Parameters = [
            "email": emailTextField.text!,
            "app": "period_tracker"
        ]
        
        showActivityIndicator(uiView: self.view)
        Alamofire.request("\(Config.WEB_DOMAIN)/license/public/resendcode", method: .post, parameters: parameters).responseJSON{ response in
            
            self.hideActivityIndicator(uiView: self.view)
            if let JSON = response.result.value as? [String: Any] {
                print("JSON: \(JSON)")
                
                if JSON["success"] as! Int == 1{
                    let popTip = PopTip()
                    popTip.bubbleColor = self.UIColorFromHex(rgbValue: 0x2E7D32)
                    popTip.font = UIFont(name: "IRANSans(FaNum)", size: 14)!
                    popTip.show(text: "به ایمیل شما ارسال شد", direction: .up, maxWidth: 200, in: self.view, from: self.emailTextField.frame, duration: 3)
                }else if JSON["success"] as! Int == 0{
                    let popTip = PopTip()
                    popTip.font = UIFont(name: "IRANSans(FaNum)", size: 14)!
                    popTip.show(text: "خریدی با این ایمیل ثبت نشده است. در صورت لزوم با پشتیبانی تماس برقرار کنید", direction: .up, maxWidth: 200, in: self.view, from: self.emailTextField.frame, duration: 3)
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if showIntro {
            let vc = IntroViewController()
            vc.items = [
                ("برنامه تخصصی برای بانوان ایرانی \n برای بازدید از محیط برنامه به سمت راست بروید", UIImage(named: "p1")),
                ("دوران پریودی خود را حرفه ای مدیریت کنید", UIImage(named: "p2")),
                ("تقویم شمسی و ثبت یادداشت", UIImage(named: "p3")),
                ("", UIImage(named: "p4"))
            ]
            vc.animationType = .rotate
            vc.titleColor = Utility.uicolorFromHex(rgbValue: 0xFAFAFA)
            vc.titleFont = UIFont(name: "IRANSans(FaNum)", size: 17)!
            vc.imageContentMode = .scaleAspectFit
            vc.closeTitle = "ورود با کد / خرید برنامه"
            vc.closeColor = .white
            vc.closeBackgroundColor = Utility.uicolorFromHex(rgbValue: 0x1A237E)
            vc.closeBorderWidth = 0
            vc.closeBorderColor = UIColor.black.cgColor
            vc.closeCornerRadius = 2
            vc.didClose = {
                //            vc.showButton.setTitle("Show again", for: .normal)
            }
            present(vc, animated: true, completion: nil)
            showIntro = false
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func toggleAction(_ sender: Any) {
        isBuyMode = !isBuyMode;
        codeTextField.isEnabled = !isBuyMode
        if isBuyMode {
            codeTextField.backgroundColor = Utility.uicolorFromHex(rgbValue: 0xEEEEEE)
        }else{
            codeTextField.backgroundColor = Utility.uicolorFromHex(rgbValue: 0xFFF8E1)
        }
        if isBuyMode {
            actionBtn.setTitle("خرید", for: .normal)
            toggleBtn.setTitle("اگر کدی دریافت کرده اید وارد شوید", for: .normal)
        }else{
            actionBtn.setTitle("ورود", for: .normal)
            toggleBtn.setTitle("خرید برنامه", for: .normal)
        }
    }
    
    func validate() -> Bool {
        if (emailTextField.text?.isEmpty)! {
            
            let popTip = PopTip()
            popTip.font = UIFont(name: "IRANSans(FaNum)", size: 14)!
            popTip.show(text: "لطفا ایمیل را وارد کنید", direction: .up, maxWidth: 200, in: self.view, from: self.emailTextField.frame, duration: 3)
            
            return false
        }else if codeTextField.isEnabled && (codeTextField.text?.isEmpty)!{
            let popTip = PopTip()
            popTip.font = UIFont(name: "IRANSans(FaNum)", size: 14)!
            popTip.show(text: "لطفا کد خود را وارد کنید", direction: .up, maxWidth: 200, in: self.view, from: self.codeTextField.frame, duration: 3)
            
            return false
        }else {
            if !isValidEmail(testStr: emailTextField.text!) {
                
                let popTip = PopTip()
                popTip.font = UIFont(name: "IRANSans(FaNum)", size: 14)!
                popTip.show(text: "لطفا ایمیل معتبر وارد کنید", direction: .up, maxWidth: 200, in: self.view, from: self.emailTextField.frame, duration: 3)
                
                return false
            }
        }
        
        return true
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    @IBAction func buyApp(_ sender: Any) {
        if !validate() {
            return
        }
        if isBuyMode {
            let parameters: Parameters = [
                "email": emailTextField.text!,
                "app": "period_tracker"
            ]
            
            showActivityIndicator(uiView: self.view)
            Alamofire.request("\(Config.WEB_DOMAIN)/license/public/buy", method: .post, parameters: parameters).responseJSON{ response in
                
                if let JSON = response.result.value as? [String: Any] {
                    print("JSON: \(JSON)")
                    self.hideActivityIndicator(uiView: self.view)
                    let url = URL(string: "\(Config.WEB_DOMAIN)/license/public/pay/\(JSON["license_id"]!)")!
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            }
            
        }else{
            
            let parameters: Parameters = [
                "email": emailTextField.text!,
                "code": codeTextField.text!,
                "app": "period_tracker"
            ]
            showActivityIndicator(uiView: self.view)
            Alamofire.request("\(Config.WEB_DOMAIN)/license/public/activation", method: .post, parameters: parameters).responseJSON{ response in
                
                self.hideActivityIndicator(uiView: self.view)
                if let JSON = response.result.value as? [String: Any] {
                    print("JSON: \(JSON)")
                    
                    if JSON["success"] as! Int == 1{
                        let keychain = KeychainSwift()
                        keychain.set(self.emailTextField.text!, forKey: "email")
                        keychain.set(true, forKey: "buy")
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let destinationVC = storyboard.instantiateViewController(withIdentifier: "BuyedController")
                        
                        (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController = destinationVC
                        
                        self.present(destinationVC, animated: true, completion: nil)
                    }else if JSON["success"] as! Int == 0{
                        let popTip = PopTip()
                        popTip.font = UIFont(name: "IRANSans(FaNum)", size: 14)!
                        popTip.show(text: "اطلاعات شما در سیستم وجود ندارد.", direction: .up, maxWidth: 200, in: self.view, from: self.actionBtn.frame, duration: 3)
                    }
                }
            }
            
        }
    }
    
    @IBAction func connectToSupport(_ sender: Any) {
        let botURL = URL.init(string: "tg://resolve?domain=mahdiyar_oraei")
        
        if UIApplication.shared.canOpenURL(botURL!) {
            UIApplication.shared.openURL(botURL!)
        } else {
            let popTip = PopTip()
            popTip.font = UIFont(name: "IRANSans(FaNum)", size: 11)!
            popTip.show(text: "پشتیبان تلگرام در دسترس نیست با ایمیل mahdiyar.oraei@gmail.com در تماس باشید.", direction: .up, maxWidth: 200, in: self.view, from: self.actionBtn.frame, duration: 5)
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
