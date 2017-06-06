//
//  ImagesViewController.swift
//  Test
//
//  Created by Mahdiar  on 3/17/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit
import RealmSwift

class ImagesViewController: UIViewController , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout , UICollectionViewDelegate,
UIPickerViewDelegate , UIPickerViewDataSource{
    
    public static var tutState = false
    public static var instance : ImagesViewController? = nil
    
    let realm = try! Realm()
    
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
        dayOfMonth = 0
        collectionView.reloadData()
        
        CircleViewController.saveNoteState = false
    }
    
    @IBOutlet weak var periodDatesButton: UIButton!
    @IBAction func selectPeriodDates(_ sender: Any) {
        if setupState == .SELECT_PERIOD_DATES {
            setupState = .SELECT_DAY
            periodDatesButton.setTitle("ثبت پریودی", for: .normal)
            dayOfMonth = 0
            collectionView.reloadData()
        }else{
            setupState = .SELECT_PERIOD_DATES
            periodDatesButton.setTitle("اتمام", for: .normal)
            dayOfMonth = 0
            collectionView.reloadData()
        }
    }
    
    let identifier = "CellIdentifire"
    
    let DAYS : [String] = ["ش" , "ی" , "د" , "س" , "چ" , "پ" , "ج"]
    let MONTH : [String] = ["فروردین" , "اردیبهشت" , "خرداد" , "تیر" , "مرداد" , "شهریور" , "مهر" , "آبان" , "آذر" , "دی" , "بهمن" , "اسفند"]
    
    var dateComponents : DateComponents!
    var calendar : Calendar!
    var dayOfMonth = 0
    
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var setPeriodLabel: UIButton!
    @IBOutlet weak var resetSettingsLabel: UIButton!
    
    var pickerView : UIPickerView?
    
    enum SetupState {
        case SELECT_DAY
        case SELECT_PERIOD_LENGHT
        case SELECT_PERIOD_DISTANCE
        case SELECT_PERIOD_DATES
    }
    var setupState : SetupState = .SELECT_DAY
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ImagesViewController.instance = self
        
        checkSetupCompeleted()
        self.automaticallyAdjustsScrollViewInsets = false
        
        collectionView.backgroundColor = UIColor(white: 1, alpha: 0)
        collectionView.dataSource = self
        
        calendar = Calendar(identifier: .persian)
        dateComponents = calendar.dateComponents([.year, .month, .day], from: Date())
        dateComponents.day = 1
        navItem.title = "\(MONTH[dateComponents.month! - 1]) - \(Int(dateComponents.year!))"
        navItem.leftBarButtonItem = UIBarButtonItem(title: "بعد", style: .plain, target: self, action: #selector(nextMonth))
        navItem.leftBarButtonItem?.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "IRANSans(FaNum)", size: 15)!], for: .normal)
        navItem.rightBarButtonItem = UIBarButtonItem(title: "قبل", style: .plain, target: self, action: #selector(preMonth))
        navItem.rightBarButtonItem?.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "IRANSans(FaNum)", size: 15)!], for: .normal)
        
        setupUserSavedData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let showAlert = UserDefaults.standard.integer(forKey: "SELECT_PERIOD_DISTANCE") == 0
        
        if !ImagesViewController.tutState {
            
            alertLabel.isHidden = !showAlert
            resetSettingsLabel.isHidden = showAlert
            setPeriodLabel.isHidden = showAlert
        }else{
            
            alertLabel.isHidden = true
            resetSettingsLabel.isHidden = false
            setPeriodLabel.isHidden = false
        }
        
        
        dayOfMonth = 0
        collectionView.reloadData()
    }
    
    func checkSetupCompeleted() {
        if UserDefaults.standard.double(forKey: "period_begin_date") == 0
            || UserDefaults.standard.integer(forKey: "SELECT_PERIOD_DISTANCE") == 0
            || UserDefaults.standard.integer(forKey: "SELECT_PERIOD_LENGHT") == 0 {
            
            UserDefaults.standard.set(0.0, forKey: "period_begin_date")
            UserDefaults.standard.set(0, forKey: "SELECT_PERIOD_LENGHT")
            UserDefaults.standard.set(0, forKey: "SELECT_PERIOD_DISTANCE")
            
        }
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
            
            UserDefaults.standard.set(0.0, forKey: "period_begin_date")
            UserDefaults.standard.set(0, forKey: "SELECT_PERIOD_LENGHT")
            UserDefaults.standard.set(0, forKey: "SELECT_PERIOD_DISTANCE")
            
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
            navItem.title = "\(MONTH[dateComponents.month! - 1]) - \(Int(dateComponents.year!))"
            dayOfMonth = 0
            collectionView.reloadData()
            setupUserSavedData()
            viewDidAppear(false)
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
        
        if cell.detailLayer != nil {
            cell.detailLayer?.removeFromSuperlayer()
        }
        if cell.todayLayer != nil {
            cell.todayLayer?.removeFromSuperlayer()
        }
        
        setupMonthCalendar(cell: cell, indexPath: indexPath)
        
        if indexPath.item < 7 {
            cell.backgroundColor = UIColor(white: 1, alpha: 0)
            cell.dayOfMonthLabel.textColor = Utility.uicolorFromHex(rgbValue: 0x908F96)
            cell.dayOfMonthLabel.text = DAYS[indexPath.item]
            cell.date = nil
        }
        
        
        if cell.date != nil && realm.objects(PeriodNoteModel.self).filter("timestamp = \(String(describing: calendar.startOfDay(for: cell.date!).timeIntervalSince1970))").count > 0 {
            cell.noteImage.isHidden = false
        }else{
            cell.noteImage.isHidden = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell : DayViewCell = collectionView.cellForItem(at: indexPath) as! DayViewCell
        if cell.date != nil && UserDefaults.standard.double(forKey: "period_begin_date") == 0 && setupState != .SELECT_PERIOD_DATES{
            
            let dateComponents = calendar.dateComponents([.year , .month , .day], from: cell.date!)
            
            let dateString = "\(Int(dateComponents.day!)) - \(MONTH[dateComponents.month! - 1]) - \(Int(dateComponents.year!))"
            
            let attributedString = NSAttributedString(string: "ثبت تاریخ شروع دوره ماهانه", attributes: [
                NSFontAttributeName : UIFont(name: "IRANSans(FaNum)", size: 17)
                ])
            
            let alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.setValue(attributedString, forKey: "attributedTitle")
            alert.setValue(NSAttributedString(string: dateString, attributes: [
                NSFontAttributeName : UIFont(name: "IRANSans(FaNum)", size: 13)
                ])
, forKey: "attributedMessage")
            
            alert.addAction(UIAlertAction(title: "بله", style: UIAlertActionStyle.default, handler: {action in self.setupBeginPeriod(date: cell.date!)}))
            alert.addAction(UIAlertAction(title: "خیر", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else if setupState == .SELECT_PERIOD_DATES{
            cell.choose = !(realm.objects(PeriodDateModel.self).filter("timestamp = \(cell.date!.timeIntervalSince1970)").count > 0)
            if cell.choose {
                cell.dayOfMonthLabel.textColor = UIColor.red
                
                let dateModel = PeriodDateModel()
                dateModel.timestamp = (cell.date?.timeIntervalSince1970)!
                dateModel.id = dateModel.incrementID()
                
                try! realm.write {
                    realm.add(dateModel)
                }
                
            }else{
                cell.dayOfMonthLabel.textColor = UIColor.white
                
                let dateModel = realm.objects(PeriodDateModel.self).filter("timestamp = \(cell.date!.timeIntervalSince1970)").first
                try! realm.write {
                    realm.delete(dateModel!)
                }
            }
        }else{
            
            if cell.date != nil {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let destinationVC = storyboard.instantiateViewController(withIdentifier: "NewsDetailsVCID")
                
                LogPeriodViewController.timestamp = Calendar.current.startOfDay(for: cell.date!).timeIntervalSince1970
                
                present(destinationVC, animated: true, completion: nil)
            }
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
        pickerView?.backgroundColor = Utility.uicolorFromHex(rgbValue: 0x23272F)
        pickerView?.delegate = self
        pickerView?.dataSource = self
        pickerView?.frame.size.height = self.view.frame.height
        pickerView?.frame.size.width = self.view.frame.width
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
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "IRANSans(FaNum)", size: 20.0)!,NSForegroundColorAttributeName:UIColor.black])
        pickerLabel!.attributedText = myTitle
        pickerLabel!.textAlignment = .center
        
        return pickerLabel!
    }
    
    func setupMonthCalendar(cell : DayViewCell , indexPath : IndexPath) {
        let firstDayOfMonthDate :Date = calendar.date(from: dateComponents)!
        let index = calendar.component(.weekday, from: firstDayOfMonthDate)
        
        let range = calendar.range(of: .day, in: .month, for: firstDayOfMonthDate)
        let dayNums = range?.count
        cell.dayOfMonthLabel.text = ""
        
        if (indexPath.item < 7 + index && indexPath.item > 6) || indexPath.item > dayNums! + 6 + index {
            cell.backgroundColor = UIColor(white: 1, alpha: 0)
            cell.date = nil
            cell.dayOfMonthLabel.textColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        }else if indexPath.item > 6{
            
            cell.dayOfMonthLabel.textColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
            dayOfMonth += 1
            var cellDateComponnet : DateComponents = dateComponents
            cellDateComponnet.day = dayOfMonth
            cell.date = calendar.date(from: cellDateComponnet)
            cell.dayOfMonthLabel.text = String (dayOfMonth)
            
            if calendar.isDateInToday(cell.date!) {
                let todayPath = UIBezierPath(arcCenter: CGPoint(x: cell.frame.size.width / 2, y: cell.frame.size.height / 2), radius: cell.frame.size.width / 2 - 3, startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
                
                let todayLayer = CAShapeLayer()
                todayLayer.path = todayPath.cgPath
                todayLayer.fillColor = UIColor.clear.cgColor
                todayLayer.strokeColor = Utility.uicolorFromHex(rgbValue: 0xFFC107).cgColor
                todayLayer.lineWidth = 3.0
                cell.todayLayer = todayLayer
                
                cell.layer.addSublayer(todayLayer)
            }
            
            if setupState != .SELECT_PERIOD_DATES {
                if cell.date != nil && UserDefaults.standard.double(forKey: "period_begin_date") != 0
                && UserDefaults.standard.integer(forKey: "SELECT_PERIOD_DISTANCE") != 0
                && UserDefaults.standard.integer(forKey: "SELECT_PERIOD_LENGHT") != 0{
                    let date : Date = Date(timeIntervalSince1970: UserDefaults.standard.double(forKey: "period_begin_date"))
                    var difference = Calendar.current.dateComponents([.day], from: date, to: cell.date!).day ?? 0
                    let diff = difference
                    
                    let periodLength = UserDefaults.standard.integer(forKey: "SELECT_PERIOD_LENGHT")
                    let periodDistance = UserDefaults.standard.integer(forKey: "SELECT_PERIOD_DISTANCE")
                    
                    difference = difference % periodDistance
                    
                    let circlePath = UIBezierPath(arcCenter: CGPoint(x: cell.frame.size.width / 2, y: cell.frame.size.height - 10), radius: 2, startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
                    
                    let detailLayer = CAShapeLayer()
                    detailLayer.path = circlePath.cgPath
                    detailLayer.fillColor = UIColor.black.cgColor
                    cell.detailLayer = detailLayer
                    
                    
                    if difference < periodLength && diff >= 0{
                        detailLayer.fillColor = Utility.uicolorFromHex(rgbValue: 0xE57373).cgColor
                        cell.layer.addSublayer(detailLayer)
                    }else if difference < periodDistance - 7{
                        if difference >= periodDistance - 16 && difference <= periodDistance - 12{
                            detailLayer.fillColor = Utility.uicolorFromHex(rgbValue: 0x0097A7).cgColor
                            cell.layer.addSublayer(detailLayer)
                        }
                    }else if difference < periodDistance{
                        detailLayer.fillColor = Utility.uicolorFromHex(rgbValue: 0xBDBDBD).cgColor
                        cell.layer.addSublayer(detailLayer)
                    }else{
                        detailLayer.removeFromSuperlayer()
                    }
                }
            }
            if realm.objects(PeriodDateModel.self).filter("timestamp = \(String(describing: cell.date!.timeIntervalSince1970))").count > 0 {
                cell.dayOfMonthLabel.textColor = Utility.uicolorFromHex(rgbValue: 0xE53935)
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
