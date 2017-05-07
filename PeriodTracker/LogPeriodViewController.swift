//
//  LogPeriodViewController.swift
//  Period Tracker
//
//  Created by Mahdiar  on 5/1/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit
import RealmSwift

class LogPeriodViewController: UIViewController {
    
    static var timestamp: Double! = 0

    @IBOutlet weak var navItem: UINavigationItem!
    
    @IBOutlet weak var noteTextView: UITextView!
    
    let realm = try! Realm()
    
    var update : Bool? = false
    var updateId : Int? = 0
    
    @IBAction func saveNote(_ sender: Any) {
        
        let noteModel : PeriodNoteModel = PeriodNoteModel()
        noteModel.timestamp = LogPeriodViewController.timestamp!
        noteModel.note = noteTextView.text
        if update! {
            noteModel.id = updateId!
        }else{
            noteModel.id = noteModel.incrementID()
        }
        
        try! realm.write {
            realm.add(noteModel , update: update!)
        }
        
        done()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        noteTextView.clipsToBounds = true
        noteTextView.layer.cornerRadius = 5.0
        noteTextView.layer.shadowOpacity = 0.3
        noteTextView.layer.shadowRadius = 10.0
        noteTextView.layer.shadowColor = UIColor.black.cgColor
        noteTextView.layer.shadowOffset = CGSize(width: 2, height: 3)
        navItem.leftBarButtonItem = UIBarButtonItem(title: "cancel", style: .done, target: self, action: #selector(done))
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fetchSavedNote()
    }
    
    func fetchSavedNote() {
        
        let note = realm.objects(PeriodNoteModel.self).filter("timestamp = \(LogPeriodViewController.timestamp!)")
        
        if note.count > 0 {
            update = true
        }
        
        noteTextView.text = note.first?.note
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func done() {
        dismissKeyboard()
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
