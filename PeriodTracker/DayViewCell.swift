//
//  DayViewCell.swift
//  Test
//
//  Created by Mahdiar  on 3/18/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit

class DayViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dayOfMonthLabel: UILabel!
    
    var date:Date?
    
    override init(frame: CGRect) {
        super.init(frame:frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
