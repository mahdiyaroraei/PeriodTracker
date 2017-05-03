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
    dynamic var timestamp :Double = 0.0
    dynamic var note = ""
}
