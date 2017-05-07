//
//  PeriodDateModel.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 5/4/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import Foundation
import RealmSwift

class PeriodDateModel: Object {
    dynamic var id = 0
    dynamic var timestamp :Double = 0.0
    
    func incrementID() -> Int {
        let realm = try! Realm()
        return (realm.objects(PeriodDateModel.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
