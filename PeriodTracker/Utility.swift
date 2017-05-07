//
//  Utility.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 5/7/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit

class Utility: NSObject {
    
    static func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
}
