//
//  ImagesViewController.swift
//  Test
//
//  Created by Mahdiar  on 3/17/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit

class ImagesViewController: UIViewController , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout , UICollectionViewDelegate,
UIPickerViewDelegate , UIPickerViewDataSource{

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var navItem: UINavigationItem!
    
    @IBOutlet weak var startLabel: UILabel!
    
    @IBOutlet weak var lengthLabel: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBAction func clearSettings(_ sender: Any) {
        UserDefaults.standard.set(0.0, forKey: "period_begin_date")
        UserDefaults.standard.set(0, forKey: "SELECT_PERIOD_LENGHT")
        UserDefaults.standard.set(0, forKey: "SELECT_PERIOD_DISTANCE")
        
        setupUserSavedData()
    }
    
    let identifier = "CellIdentifire"
    
    let DAYS : [String] = ["ش" , "ی" , "د" , "س" , "چ" , "پ" , "ج"]
    let MONTH : [String] = ["فروردین" , "اردیبهشت" , "خرداد" , "تیر" , "مرداد" , "شهریور" , "مهر" , "آبان" , "آذر" , "دی" , "بهمن" , "اسفند"]
    
    var dateComponents : DateComponents!
    var calendar : Calendar!
    var dayOfMonth = 0
    
    var pickerView : UIPickerView?
    
    enum SetupState {
        case SELECT_DAY
        case SELECT_PERIOD_LENGHT
        case SELECT_PERIOD_DISTANCE
    }
    var setupState : SetupState = .SELECT_DAY
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        
        calendar = Calendar(identifier: .persian)
        dateComponents = calendar.dateComponents([.year, .month, .day], from: Date())
        dateComponents.day = 1
        navItem.title = "\(MONTH[dateComponents.month! - 1]) - \(Int(dateComponents.year!))"
        navItem.leftBarButtonItem = UIBarButtonItem(title: "pre", style: .plain, target: self, action: #selector(preMonth))
        navItem.rightBarButtonItem = UIBarButtonItem(title: "next", style: .plain, target: self, action: #selector(nextMonth))
        
        setupUserSavedData()
    }
    
    func preMonth() {
        switch setupState {
        case .SELECT_DAY:
            
            if dateComponents.month == 1 {
                dateComponents.month = 12
                dateComponents.year = dateComponents.year! - 1
            }else{
                dateComponents.month = dateComponents.month! - 1
            }
            dayOfMonth = 0
            collectionView.reloadData()
            navItem.title = "\(MONTH[dateComponents.month! - 1]) - \(Int(dateComponents.year!))"
            
            break
            
        case .SELECT_PERIOD_LENGHT:
            
            setupState = .SELECT_DAY
            navItem.title = MONTH[dateComponents.month! - 1]
            pickerView?.removeFromSuperview()
            break
            
        case .SELECT_PERIOD_DISTANCE:
            
            setupState = .SELECT_PERIOD_LENGHT
            navItem.title = "طول مدت پریودی"
            pickerView?.dataSource = self
            break
            
        default:
            break
        }
    }
    
    func nextMonth() {
        
        switch setupState {
        case .SELECT_DAY:
            
            if dateComponents.month == 12 {
                dateComponents.month = 1
                dateComponents.year = dateComponents.year! + 1
            }else{
                dateComponents.month = dateComponents.month! + 1
            }
            dayOfMonth = 0
            collectionView.reloadData()
            navItem.title = "\(MONTH[dateComponents.month! - 1]) - \(Int(dateComponents.year!))"
            break
            
        case .SELECT_PERIOD_LENGHT:
            
            UserDefaults.standard.set((pickerView?.selectedRow(inComponent: 0))! + 3, forKey: "SELECT_PERIOD_LENGHT")
            setupState = .SELECT_PERIOD_DISTANCE
            navItem.title = "فاصله میان پریودی"
            pickerView?.dataSource = self
            break
            
        case .SELECT_PERIOD_DISTANCE:
            
            UserDefaults.standard.set((pickerView?.selectedRow(inComponent: 0))! + 14, forKey: "SELECT_PERIOD_DISTANCE")
            setupState = .SELECT_DAY
            pickerView?.removeFromSuperview()
            navItem.title = MONTH[dateComponents.month! - 1]
            dayOfMonth = 0
            collectionView.reloadData()
            setupUserSavedData()
            break
            
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 49
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell :DayViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath as IndexPath) as! DayViewCell
        
        cell.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        
        setupMonthCalendar(cell: cell, indexPath: indexPath)
        
        if indexPath.item < 7 {
            cell.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
            cell.dayOfMonthLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            cell.dayOfMonthLabel.text = DAYS[indexPath.item]
            cell.date = nil
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell : DayViewCell = collectionView.cellForItem(at: indexPath) as! DayViewCell
        if cell.date != nil && UserDefaults.standard.double(forKey: "period_begin_date") == 0{
            
            let dayTimePeriodFormatter = DateFormatter()
            dayTimePeriodFormatter.dateFormat = "MMM dd YYYY hh:mm a"
            dayTimePeriodFormatter.calendar = calendar
            
            let dateString = dayTimePeriodFormatter.string(from: cell.date!)
            
            let alert = UIAlertController(title: "ثبت تاریخ شروع دوره ماهانه", message: dateString, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "بله", style: UIAlertActionStyle.default, handler: {action in self.setupBeginPeriod(date: cell.date!)}))
            alert.addAction(UIAlertAction(title: "خیر", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func setupUserSavedData() {
        let date : Date = Date(timeIntervalSince1970: UserDefaults.standard.double(forKey: "period_begin_date"))
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "MMM dd YYYY hh:mm a"
        dayTimePeriodFormatter.calendar = calendar
        
        var currentDateComponnet : DateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        
        startLabel.text = "\(Int(currentDateComponnet.day!)) - \(MONTH[currentDateComponnet.month! - 1]) - \(Int(currentDateComponnet.year!))"
        lengthLabel.text = "\(UserDefaults.standard.integer(forKey: "SELECT_PERIOD_LENGHT")) روز"
        distanceLabel.text = "\(UserDefaults.standard.integer(forKey: "SELECT_PERIOD_DISTANCE")) روز"
    }
    
    func setupBeginPeriod(date : Date) {
        setupState = .SELECT_PERIOD_LENGHT
        UserDefaults.standard.set(date.timeIntervalSince1970, forKey: "period_begin_date")
        
        pickerView = UIPickerView()
        pickerView?.delegate = self
        pickerView?.dataSource = self
        pickerView?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        pickerView?.frame.size.height = self.view.frame.height
        pickerView?.center = self.view.center
        navItem.title = "طول مدت پریودی"
        self.view.addSubview(pickerView!)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch setupState {
        case .SELECT_PERIOD_LENGHT:
            return 7
        case .SELECT_PERIOD_DISTANCE:
            return 40
        default:
            return 7
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel = view as! UILabel!
        if view == nil {  //if no label there yet
            pickerLabel = UILabel()
            //color the label's background
            let hue = CGFloat(row)/CGFloat(40)
            pickerLabel?.backgroundColor = UIColor(hue: hue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
        }
        var titleData : String
        switch setupState {
        case .SELECT_PERIOD_LENGHT:
            titleData = "\(row + 3) روز"
        case .SELECT_PERIOD_DISTANCE:
            titleData = "\(row + 14) روز"
        default:
            titleData = "\(row + 3) روز"
        }
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 26.0)!,NSForegroundColorAttributeName:UIColor.black])
        pickerLabel!.attributedText = myTitle
        pickerLabel!.textAlignment = .center
        
        return pickerLabel!
    }
    
    func setupMonthCalendar(cell : DayViewCell , indexPath : IndexPath) {
        let firstDayOfMonthDate :Date = calendar.date(from: dateComponents)!
        let index = calendar.component(.weekday, from: firstDayOfMonthDate)
        
        let range = calendar.range(of: .day, in: .month, for: firstDayOfMonthDate)
        let dayNums = range?.count
        
        if (indexPath.item < 7 + index && indexPath.item > 6) || indexPath.item > dayNums! + 6 + index {
            cell.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
            cell.date = nil
            cell.dayOfMonthLabel.textColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        }else if indexPath.item > 6{
            cell.dayOfMonthLabel.textColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
            dayOfMonth += 1
            var cellDateComponnet : DateComponents = dateComponents
            cellDateComponnet.day = dayOfMonth
            cell.date = calendar.date(from: cellDateComponnet)
            cell.dayOfMonthLabel.text = String (dayOfMonth)
            
            
            if cell.date != nil && UserDefaults.standard.double(forKey: "period_begin_date") != 0{
                let date : Date = Date(timeIntervalSince1970: UserDefaults.standard.double(forKey: "period_begin_date"))
                var difference = Calendar.current.dateComponents([.day], from: date, to: cell.date!).day ?? 0
                let diff = difference
                
                let periodLength = UserDefaults.standard.integer(forKey: "SELECT_PERIOD_LENGHT")
                let periodDistance = UserDefaults.standard.integer(forKey: "SELECT_PERIOD_DISTANCE")
                
                difference = difference % periodDistance
                
                if difference < periodLength && diff >= 0{
                    cell.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                }else if difference < periodDistance - 7{
                    if difference > periodDistance / 2 - 3 && difference < periodDistance / 2 + 3{
                        cell.backgroundColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
                    }
                }else if difference < periodDistance{
                    cell.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                }
            }
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.bounds.size.width/7 - 1, height: collectionView.bounds.size.width/7 - 1)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func timeAgoSince(_ date: Date) -> String {
        
        let calendar = Calendar.current
        let now = Date()
        let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
        let components = (calendar as NSCalendar).components(unitFlags, from: date, to: now, options: [])
        
        if let year = components.year, year >= 2 {
            return "\(year) years ago"
        }
        
        if let year = components.year, year >= 1 {
            return "Last year"
        }
        
        if let month = components.month, month >= 2 {
            return "\(month) months ago"
        }
        
        if let month = components.month, month >= 1 {
            return "Last month"
        }
        
        if let week = components.weekOfYear, week >= 2 {
            return "\(week) weeks ago"
        }
        
        if let week = components.weekOfYear, week >= 1 {
            return "Last week"
        }
        
        if let day = components.day, day >= 2 {
            return "\(day) days ago"
        }
        
        if let day = components.day, day >= 1 {
            return "Yesterday"
        }
        
        if let hour = components.hour, hour >= 2 {
            return "\(hour) hours ago"
        }
        
        if let hour = components.hour, hour >= 1 {
            return "An hour ago"
        }
        
        if let minute = components.minute, minute >= 2 {
            return "\(minute) minutes ago"
        }
        
        if let minute = components.minute, minute >= 1 {
            return "A minute ago"
        }
        
        if let second = components.second, second >= 3 {
            return "\(second) seconds ago"
        }
        
        return "Just now"
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
