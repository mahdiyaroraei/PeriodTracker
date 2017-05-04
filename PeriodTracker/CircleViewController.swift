//
//  CircleViewController.swift
//  Test
//
//  Created by Mahdiar  on 3/25/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit

class CircleViewController: UIViewController , UIGestureRecognizerDelegate{
    
    var points : [CGPoint] = []
    var selectDayLayer:CAShapeLayer?
    var textLayer:CATextLayer?
    let startPeriodDate : Date = Date(timeIntervalSince1970: UserDefaults.standard.double(forKey: "period_begin_date"))
    var beginPeriodDate : Date?
    var periodDistance = UserDefaults.standard.integer(forKey: "SELECT_PERIOD_DISTANCE")
    var periodLength = (UserDefaults.standard.integer(forKey: "SELECT_PERIOD_LENGHT"))
    var angelUnit : Double?
    let MONTH : [String] = ["فروردین" , "اردیبهشت" , "خرداد" , "تیر" , "مرداد" , "شهریور" , "مهر" , "آبان" , "آذر" , "دی" , "بهمن" , "اسفند"]
    var timestamp: Double! = 0
    var saveNoteState = false

    @IBOutlet weak var dayLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        periodDistance = UserDefaults.standard.integer(forKey: "SELECT_PERIOD_DISTANCE")
        periodLength = (UserDefaults.standard.integer(forKey: "SELECT_PERIOD_LENGHT"))
        
        if !saveNoteState {
            
            if selectDayLayer != nil {
                selectDayLayer?.removeFromSuperlayer()
                textLayer?.removeFromSuperlayer()
            }
        
            setupDate()
            drawCircleBasic()
            drawCircleCloud()
            drawCirclePeriod()
            drawCircleFertile()
            setupGestureView()
            setupPoints()
            selectDay(sender: points[0])
            saveNoteState = false
        }
    }
    
    func setupDate() {
        var difference = Calendar.current.dateComponents([.day], from: startPeriodDate, to: Date()).day ?? 0
        
        difference = difference % periodDistance
        
        beginPeriodDate = Calendar.current.date(byAdding: .day, value: -difference, to: Date())
        
        dayLabel.isUserInteractionEnabled = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(dayTapped))
        dayLabel.addGestureRecognizer(tap)
        tap.delegate = self
    }
    
    func dayTapped(sender:UITapGestureRecognizer) {
        saveNoteState = true
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "NewsDetailsVCID")
        
        LogPeriodViewController.timestamp = self.timestamp
        
        present(destinationVC, animated: true, completion: nil)
        
    }
    
    func setupPoints() {
        
        let centerPoint:CGPoint = view.center
        let radius = CGFloat(view.frame.size.width / 2 - 35)
        let a = (M_PI * 2) / Double (periodDistance)
        
        for i in 0 ..< periodDistance{
            
            let x = CGFloat(Double (centerPoint.x) + Double (radius) * cos(Double (i) * a - M_PI_2))
            let y = CGFloat(Double (centerPoint.y) + Double (radius) * sin(Double (i) * a - M_PI_2))
            
            points.append(CGPoint(x: x, y: y))
        }
    }
    
    func setupGestureView() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector (self.onViewTouch(sender:))))
    }
    
    func onViewTouch(sender:UITapGestureRecognizer) {
        selectDay(sender: sender.location(in: view))
    }
    
    func selectDay(sender:CGPoint) {
        var selectedPoint : CGPoint = points[0]
        var day = 1
        var selectedDay = 1
        for point in points {
            if distance(a: point, b: sender) < distance(a: selectedPoint, b: sender) {
                selectedPoint = point
                selectedDay = day
            }
            day += 1
        }
        
        let circlePath = UIBezierPath(arcCenter: selectedPoint, radius: 25, startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
        
        if selectDayLayer != nil {
            selectDayLayer?.removeFromSuperlayer()
            textLayer?.removeFromSuperlayer()
        }
        
        selectDayLayer = CAShapeLayer()
        selectDayLayer?.path = circlePath.cgPath
        selectDayLayer?.fillColor = UIColor.black.cgColor
        
        textLayer = CATextLayer()
        textLayer?.string = "\(selectedDay)"
        textLayer?.foregroundColor = UIColor.white.cgColor
        textLayer?.font = UIFont(name: "IRANSans(FaNum)", size: 12)
        textLayer?.fontSize = 15
        textLayer?.alignmentMode = kCAAlignmentCenter
        textLayer?.frame = CGRect(origin: CGPoint(x:selectedPoint.x - 25 , y:selectedPoint.y - 12), size: CGSize(width: 50, height: 50))
        
        view.layer.addSublayer(selectDayLayer!)
        view.layer.addSublayer(textLayer!)
        
        let date = Calendar.current.date(byAdding: .day, value: selectedDay - 1 , to: beginPeriodDate!)
        let dateComponents = Calendar(identifier: .persian).dateComponents([.year , .month , .day], from: date!)
        timestamp = Calendar.current.startOfDay(for: date!).timeIntervalSince1970
        dayLabel.text = "\(Int (dateComponents.year!)) - \(MONTH[dateComponents.month! - 1]) - \(Int (dateComponents.day!))"
    }
    
    func distance(a: CGPoint, b: CGPoint) -> CGFloat {
        let xDist = a.x - b.x
        let yDist = a.y - b.y
        return CGFloat(sqrt((xDist * xDist) + (yDist * yDist)))
    }
    
    func drawCircleBasic() {
        let centerPoint:CGPoint = view.center
        let radius = CGFloat(view.frame.size.width / 2 - 35)
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: centerPoint.x,y: centerPoint.y), radius: radius, startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.gray.cgColor
        shapeLayer.lineWidth = 25.0
        shapeLayer.lineCap = kCALineCapRound
        
        view.layer.addSublayer(shapeLayer)
    }
    
    func drawCirclePeriod() {
        let centerPoint:CGPoint = view.center
        let radius = CGFloat(view.frame.size.width / 2 - 35)
        
        if periodDistance > 0 {
            angelUnit = M_PI * 2 / Double (periodDistance)
        }
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: centerPoint.x,y: centerPoint.y), radius: radius, startAngle: CGFloat(M_PI * 1.5), endAngle:CGFloat(M_PI * 1.5 + (Double (periodLength - 1) * angelUnit!)), clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 25.0
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.contents = UIImage(named: "cloud")?.cgImage
        
        view.layer.addSublayer(shapeLayer)
    }
    
    func drawCircleFertile() {
        let centerPoint:CGPoint = view.center
        let radius = CGFloat(view.frame.size.width / 2 - 35)
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: centerPoint.x,y: centerPoint.y), radius: radius, startAngle: CGFloat(M_PI * 0.3), endAngle:CGFloat(M_PI * 0.7), clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.cyan.cgColor
        shapeLayer.lineWidth = 25.0
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.contents = UIImage(named: "cloud")?.cgImage
        
        view.layer.addSublayer(shapeLayer)
    }
    
    func drawCircleCloud() {
        
        let centerPoint:CGPoint = view.center
        let radius = CGFloat(view.frame.size.width / 2 - 35)
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: centerPoint.x,y: centerPoint.y), radius: radius, startAngle: CGFloat(M_PI * 1.05), endAngle:CGFloat(M_PI * 1.42), clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.blue.cgColor
        shapeLayer.lineWidth = 25.0
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.contents = UIImage(named: "cloud")?.cgImage
        
        view.layer.addSublayer(shapeLayer)
        
        let a = M_PI / 25
        
        for i in 30 ..< 34{
            
            let x = CGFloat(Double (centerPoint.x) + Double (radius) * cos(Double (i) * a))
            let y = CGFloat(Double (centerPoint.y) + Double (radius) * sin(Double (i) * a))
            
            let imageLayer = CALayer()
            imageLayer.backgroundColor = UIColor.clear.cgColor
            imageLayer.bounds = CGRect(x: x, y: y , width: 40, height: 30)
            imageLayer.position = CGPoint(x: x, y: y)
            imageLayer.contents = UIImage(named:"cloud_cartoon")?.cgImage
            imageLayer.shadowRadius = 3
            imageLayer.shadowOpacity = 0.7
            view.layer.addSublayer(imageLayer)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
