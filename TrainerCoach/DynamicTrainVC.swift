//
//  DynamicTrainVC.swift
//  TrainerCoach
//
//  Created by User on 10/07/2017.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit
import SwiftyJSON
import YouTubePlayer
import CHIPageControl
import UserNotifications
import AVFoundation

class DynamicTrainVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    

    @IBOutlet weak var moveOnButton: UIButton!
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: CHIPageControlJalapeno!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var checkBox: BEMCheckBox!
    @IBOutlet weak var alarmClock: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var restLabel: UILabel!
    var animatingImages = [#imageLiteral(resourceName: "_1"),#imageLiteral(resourceName: "_2"),#imageLiteral(resourceName: "_3"),#imageLiteral(resourceName: "_4"),#imageLiteral(resourceName: "_5"),#imageLiteral(resourceName: "_6"),#imageLiteral(resourceName: "_7"),#imageLiteral(resourceName: "_8"),#imageLiteral(resourceName: "_9"),#imageLiteral(resourceName: "_10"),#imageLiteral(resourceName: "_11"),#imageLiteral(resourceName: "_12")]
    
    var mainCounter: Int = 0
    var week: Int?
    var isRest: Bool? = true
    var startTime: TimeInterval?
    var timer: Timer?
    var counter: Int = 0
    var counterInt: Int = 1
    var data:[JSON]?
    var dictionaryClass: NSMutableDictionary?
    var contetnInt: Int = 0
    var nextCell: Int = 1
    var restTimer: Timer?
    var valueForRest:Double = 0
    var timeRemaining:Float = 25
    var titleLabelText: String?
    var type: String?
    var groups: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startTime = NSDate.timeIntervalSinceReferenceDate
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(advanceTimer), userInfo: nil, repeats: true)
        
        dictionaryClass = self.parseData()

        let array = dictionaryClass?.object(forKey: "repeats") as! [Int]
        pageControl.numberOfPages = array[0]
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        alarmClock.animationImages = animatingImages
        alarmClock.animationDuration = 0.8
        
        checkBox.alpha = 0
        self.alarmClock.alpha = 0
        configureCheckBox()
        checkBox.onAnimationType = .stroke
        progressView.alpha = 0
        restLabel.alpha = 0
        progressView.transform = CGAffineTransform(scaleX: 1, y: 2)
        
        UIView.animate(withDuration: 0.4) {
            self.stepLabel.transform = CGAffineTransform(translationX: 0 , y: 250)
            self.stepLabel.layoutIfNeeded()
        }
        stepLabel.layer.add(bloatWithCount(count: 3), forKey: "scaleLabel")
        animateLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let array = dictionaryClass?.object(forKey: "counts") as! [Int]
        return array.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func bloatWithCount(count:Int) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 1.3
        animation.duration = 0.8
        animation.repeatCount = Float(count)
        animation.autoreverses = true
        return animation
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CVCell", for: indexPath) as! DynamicTrainCell
        let youtubePlayer = YouTubePlayerView(frame: CGRect(x: 10, y: 10, width: cell.frame.size.width - 20, height: cell.frame.size.height - 20))
        youtubePlayer.layer.cornerRadius = 5.0
        youtubePlayer.layer.masksToBounds = true
        cell.addSubview(youtubePlayer)
        //hardcoded
        youtubePlayer.loadVideoURL(URL(string:"https://www.youtube.com/watch?v=klssdO_jB88?start=1275&end=1302")!)//hardcoded
        
        
        let exercise = data?[nextCell - 1].stringValue
        var nextExercise = "Finish"
        if nextCell < (data?.count)!{
            nextExercise = (data?[nextCell].stringValue)!
            nextExercise = getURLString(fromString:nextExercise)!
        }
        
        let array = dictionaryClass?.object(forKey: "counts") as! [Int]
        let arrayOfRepeats = dictionaryClass?.object(forKey: "repeats") as! [Int]
        
        firstLabel.text = "1/\(arrayOfRepeats[nextCell - 1])\n" + getURLString(fromString: exercise!)!
        secondLabel.text = "Repeats:\(array[nextCell - 1])"
        thirdLabel.text = nextExercise + "\nNext"
        pageControl.numberOfPages = arrayOfRepeats[nextCell - 1]
        pageControl.set(progress: 0, animated: true)
        firstLabel.layer.add(bloatWithCount(count: 1), forKey: "scaleLabel")

        return cell
    }
    
    func animateLabel() {
        UIView.animate(withDuration: 0.4, delay: 2.5, options: [], animations: { 
            self.stepLabel.transform = .identity
        })

    }
    
    func advanceTimer(timer: Timer)
    {
        let timeInterval = Date.timeIntervalSinceReferenceDate - startTime!
        let ti = Int(timeInterval)
        
        let ms = Int(timeInterval.truncatingRemainder(dividingBy: 1) * 1000)
        
        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        let hours = (ti / 3600)
        
        self.stepLabel.text = String.init(format: "Время:%0.2d:%0.2d:%0.2d.%0.2d",hours,minutes,seconds,ms)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    @IBAction func moveOn(_ sender: UIButton) {
        
        let array = dictionaryClass?.object(forKey: "repeats") as! [Int]
    
        if isRest == true {
            //make counterInt null
            if counterInt ==  array[nextCell - 1] {
                
                if mainCounter == array.reduce(0, +) - 1 {
                    showFinishVC()
                    return
                }
                
                let point = CGPoint(x: CGFloat(nextCell) * view.frame.size.width + CGFloat(10 * nextCell), y: 0)
                collectionView.setContentOffset(point, animated: true)
                nextCell+=1
                contetnInt = 0
                counterInt = 1
                mainCounter+=1
                moveOnButton.setTitle("Продолжить", for: .normal)
                moveOnButton.titleLabel?.layer.add(bloatWithCount(count: 2), forKey: "scaleButton")
                showCheckBox()
                dismissCheckBox()
                updateLabel()
                pageControl.numberOfPages = array[nextCell - 1]
                pageControl.set(progress: 0, animated: true)
                isRest = false
                return
            }
            moveOnButton.setTitle("Продолжить", for: .normal)
            moveOnButton.titleLabel?.layer.add(bloatWithCount(count: 2), forKey: "scaleButton")
            isRest = false
            counterInt+=1
            mainCounter+=1
            contetnInt+=1
            pageControl.set(progress: contetnInt, animated: true)
            addPulse()
            firstLabel.layer.add(bloatWithCount(count: 1), forKey: "scaleLabel")
            updateLabel()
            configureViewForRest()
            return
        }
        
        tapedContinue()
        removePulse()
        moveOnButton.setTitle("Закончить", for: .normal)
        isRest = true
        
    }
    
    func blinkAnimation(withRepeating repeatDuraion:CGFloat) -> CABasicAnimation{
        let theAnimation=CABasicAnimation(keyPath:"backgroundColor");
        theAnimation.duration=0.7;
        theAnimation.fromValue=UIColor.white.cgColor
        theAnimation.toValue=UIColor.red.cgColor
        theAnimation.repeatDuration = CFTimeInterval(repeatDuraion)
        return theAnimation
    }
    
    func parseData() -> NSMutableDictionary? {
        
        var dictionary = NSMutableDictionary()
        var arrayOfCounts = Array<Int>()
        var arrayOfRepeats = Array<Int>()
        
        for i in 0..<data!.count {

            let string = data![i].stringValue
            let intString =
                string.components(separatedBy: CharacterSet.decimalDigits.inverted).filter({return !$0.isEmpty})
            
            arrayOfCounts.append(Int(intString[1])!)
            arrayOfRepeats.append(Int(intString[0])!)
        }
        dictionary["counts"] = arrayOfCounts
        dictionary["repeats"] = arrayOfRepeats
        return dictionary
    }
    
    func updateLabel() {
        let cells = collectionView.visibleCells
        
        if cells.count > 0 {
        
        let cell = cells[0] as! DynamicTrainCell
        let array = dictionaryClass?.object(forKey: "counts") as! [Int]
        let arrayOfRepeats = dictionaryClass?.object(forKey: "repeats") as! [Int]
        let exercise = data?[nextCell - 1].stringValue
            
        var nextExercise = "Finish"
        let index = collectionView.indexPath(for: cell)?.row
            
            if (index! + 1 < (data?.count)!){
            nextExercise = (data?[index! + 1].stringValue)!
            nextExercise = self.getURLString(fromString:nextExercise)!
        }
            
        let count = array[nextCell - 1]
        var string = String(count)
        if count == 1 {
            string = "Максимум"
        }
            firstLabel.text = "\(counterInt)/\(arrayOfRepeats[nextCell - 1])\n" + getURLString(fromString: exercise!)!
            secondLabel.text = "Repeats:\(string)"
            thirdLabel.text = nextExercise + "\nNext"

        }
    }
    
    func getURLString(fromString string:String) -> String? {
        var resultString = ""
        for character in string.characters {
            if character != Character("-") && character != Character("–") {
                resultString += String(character)
                continue
            }
            resultString.remove(at: resultString.index(before: resultString.endIndex))
            return resultString
        }
        return nil
    }
    
    func showCheckBox() {
        UIView.animate(withDuration: 0.4) { 
            self.checkBox.alpha = 1.0
            self.checkBox.setOn(true, animated: true)
        }
    }
    
    func dismissCheckBox() {
        UIView.animate(withDuration: 0.4, delay: 1.0, options: [], animations: {
            self.checkBox.alpha = 0.0
        })
    }
    
    func configureCheckBox() {
        checkBox.onTintColor = #colorLiteral(red: 1, green: 0.1333, blue: 0.1333, alpha: 1) /* #ff2222 */
        checkBox.onCheckColor = #colorLiteral(red: 1, green: 0.1333, blue: 0.1333, alpha: 1) /* #ff2222 */
        checkBox.onFillColor = .clear
    }
    
    func addPulse() {
        
        UIView.animate(withDuration: 1.0) { 
            self.alarmClock.alpha = 1.0
            self.alarmClock.startAnimating()
            self.stepLabel.transform = CGAffineTransform(translationX: 20, y: 0)
            }
        alarmClock.layer.add(bloatWithCount(count: Int(timeRemaining-Float(5))), forKey: "scaleAlarm")
        let pulse = Pulsing(nuberOfPulses: Float.infinity, position: self.alarmClock.center)
        pulse.backgroundColor = #colorLiteral(red: 1, green: 0.1333, blue: 0.1333, alpha: 1).cgColor
        self.view.layer.insertSublayer(pulse, below: self.alarmClock.layer)
    }
    
    func removePulse() {
        
        UIView.animate(withDuration: 0.5) { 
            self.alarmClock.stopAnimating()
            self.alarmClock.alpha = 0.0
            self.stepLabel.transform = .identity
        }
        
        for layer in view.layer.sublayers!{
            if ((layer as? Pulsing) != nil) {
                UIView.animate(withDuration: 0.4, animations: { 
                    layer.removeFromSuperlayer()
                })
                return
            }
        }

    }
    
    func configureViewForRest() {
        self.restTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(restCountDown), userInfo: nil, repeats: true)
        UIView.animate(withDuration: 0.5) {
            self.alarmClock.alpha = 1
            self.alarmClock.startAnimating()
            self.restLabel.alpha = 1
            self.stepLabel.textColor = UIColor.lightGray
            self.moveOnButton.backgroundColor = UIColor.lightGray
            self.progressView.alpha = 1
            
        }
    }
    
    
    func notificationWithString(string:String) {
        
        if #available(iOS 10.0, *) {
            
            let content = UNMutableNotificationContent()
        
            content.title = "Пора продолжать."
            content.body = "Следующее упражнение - \(string)"
            content.sound = UNNotificationSound.default()
        
        // Deliver the notification in five seconds.
            let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 3, repeats: false)
            let request = UNNotificationRequest.init(identifier: "FiveSecond", content: content, trigger: trigger)
            // Schedule the notification.
            let center = UNUserNotificationCenter.current()
            center.add(request) { (error) in
                print(error)
            }
            let systemSoundID: SystemSoundID = 1016
            
            // to play sound
            AudioServicesPlaySystemSound (systemSoundID)
        }
            else {
                      let notification = UILocalNotification()
                 notification.alertBody = "Следующее упражнение - \(string)"
                 notification.alertAction = "back to app"
                 notification.fireDate = NSDate.init(timeIntervalSinceNow: 0) as Date
                 notification.soundName = UILocalNotificationDefaultSoundName
            
                 UIApplication.shared.scheduleLocalNotification(notification)
            }
    }
    
    func restCountDown() {
        
        timeRemaining-=0.01
        
        let minutesLeft = Int(timeRemaining) / 60 % 60
        let secondsLeft = Int(timeRemaining) % 60
        restLabel.text = String.init(format: "%0.2d:%0.2d",minutesLeft,secondsLeft)
        
        valueForRest += 1 / 25 / 10 / 10 // hardcoded
        DispatchQueue.main.async {
        self.progressView.setProgress(Float(self.valueForRest), animated: true)
        }
        
        if valueForRest > 1 {
            
            UIView.animate(withDuration: 0.5, animations: { 

                self.progressView.alpha = 0
                self.moveOnButton.backgroundColor = #colorLiteral(red: 1, green: 0.1333, blue: 0.1333, alpha: 1)
            })
            
            moveOnButton.titleLabel?.layer.add(bloatWithCount(count: 3), forKey: "scale_button")
            restTimer?.invalidate()
            restTimer = nil
            
            let cells = collectionView.visibleCells
            let cell = cells[0] as! DynamicTrainCell
            let nextExercise = data?[(collectionView.indexPath(for: cell)?.row)! + 1].stringValue
            
            self.notificationWithString(string: getURLString(fromString: nextExercise!)!)
        }
    }
    
    func tapedContinue() {
        if valueForRest < 1 {
            // inform user
        }
        self.alarmClock.stopAnimating()
        UIView.animate(withDuration: 0.5) {
            self.restLabel.alpha = 0.0
            self.progressView.setProgress(0, animated: false)
            self.stepLabel.textColor = #colorLiteral(red: 1, green: 0.1333, blue: 0.1333, alpha: 1)
            self.progressView.alpha = 0
            self.moveOnButton.backgroundColor = #colorLiteral(red: 1, green: 0.1333, blue: 0.1333, alpha: 1)
            self.alarmClock.alpha = 0

        }
        self.timeRemaining = 25
        self.valueForRest = 0
        moveOnButton.titleLabel?.layer.add(bloatWithCount(count: 3), forKey: "scale_button")
        restTimer?.invalidate()
        restTimer = nil
    }

    func showFinishVC() {
        self.timer?.invalidate()
        self.timer = nil
        self.restTimer?.invalidate()
        self.restTimer = nil
        let finishVC = self.storyboard?.instantiateViewController(withIdentifier: "finishVC") as! FinishVC
        finishVC.swiftyData = self.data
        finishVC.time = stepLabel.text?.substring(from: (stepLabel.text?.index((stepLabel.text?.startIndex)!, offsetBy: 6))!)
        finishVC.titleLabelText = self.titleLabelText
        finishVC.week = self.week
        finishVC.type = self.type
        finishVC.groups = self.groups
        navigationController?.pushViewController(finishVC, animated: true)
    }
    
    deinit {
        print("DynamictrainVC")
    }
    
 //   func addFillingEffect() {
 //       let badgeView = FillView(frame:moveOnButton.frame)
 //       badgeView.setCoeff(coeff: 1.0, duration: 15.0)
  //      view.addSubview(badgeView)
 //   }
    
}
