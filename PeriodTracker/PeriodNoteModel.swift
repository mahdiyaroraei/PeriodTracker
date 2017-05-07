//
//  PeriodNoteModel.swift
//  Period Tracker
//
//  Created by Mahdiar  on 5/3/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import Foundation
import RealmSwift

class PeriodNoteModel: Object {
    dynamic var id = 0
    dynamic var timestamp :Double = 0.0
    dynamic var note = ""
    
    func incrementID() -> Int {
        let realm = try! Realm()
        return (realm.objects(PeriodNoteModel.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
