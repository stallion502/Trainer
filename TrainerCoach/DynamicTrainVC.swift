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

class DynamicTrainVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var moveOnButton: UIButton!
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: CHIPageControlJalapeno!
    @IBOutlet var checkBoxView: UIView!
    @IBOutlet weak var checkBox: BEMCheckBox!
    
    var isRest: Bool? = true
    var startTime: TimeInterval?
    var timer: Timer?
    var counter: Int = 0
    var counterInt: Int = 1
    var data:[JSON]?
    var dictionaryClass: NSMutableDictionary?
    var contetnInt: Int = 0
    var nextCell: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startTime = NSDate.timeIntervalSinceReferenceDate
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(advanceTimer), userInfo: nil, repeats: true)
        
        dictionaryClass = self.parseData()
        
        checkBoxView.alpha = 0.0
        checkBox.onAnimationType = .stroke
        configureCheckBox()
        
        let array = dictionaryClass?.object(forKey: "counts") as! [Int]
        pageControl.numberOfPages = array[0]
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.stepLabel.font = UIFont(name: "Avenir-Light", size: 26)
        self.stepLabel.text = "Hello there from Russia"
        UIView.animate(withDuration: 0.4) {
            self.stepLabel.transform = CGAffineTransform(translationX: self.view.center.x - 120, y: self.view.center.y - 100)
            self.stepLabel.layoutIfNeeded()
        }
        stepLabel.layer.add(bloat(), forKey: "scaleLabel")
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
    
    func bloat() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 1.3
        animation.duration = 0.6
        animation.repeatCount = 2.0
        animation.autoreverses = true
        return animation
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CVCell", for: indexPath) as! DynamicTrainCell
        let youtubePlayer = YouTubePlayerView(frame: CGRect(x: 0, y: 50, width: cell.frame.size.width, height: cell.frame.size.height - 50))
        cell.addSubview(youtubePlayer)
        //hardcoded
        let arrayCounts = dictionaryClass?.object(forKey: "counts") as! [Int]
        youtubePlayer.loadVideoURL(URL(string:"https://www.youtube.com/watch?v=klssdO_jB88?start=1275&end=1302")!)//hardcoded
        
        
        let exercise = data?[indexPath.row].stringValue
        let array = dictionaryClass?.object(forKey: "counts") as! [Int]
        cell.stepLabel.text = "Шаг " + String(indexPath.row + 1) + ".Кол-во повторений: \(array[indexPath.row])" + "\nПодход - \(1): " + getURLString(fromString: exercise!)!
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
        
        self.stepLabel.text = String.init(format: "Время: %0.2d:%0.2d:%0.2d.%0.2d",hours,minutes,seconds,ms)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.timer?.invalidate()
    }

    @IBAction func moveOn(_ sender: UIButton) {
        
        
        let array = dictionaryClass?.object(forKey: "counts") as! [Int]
        if isRest == true {
            let indexPathes = collectionView.indexPathsForVisibleItems
            //make counterInt null
            if counterInt ==  array[indexPathes[0].row] {
                let point = CGPoint(x: CGFloat(nextCell) * view.frame.size.width + CGFloat(10 * nextCell), y: 0)
                collectionView.setContentOffset(point, animated: true)
                nextCell+=1
                contetnInt = 0
                counterInt = 1
                moveOnButton.setTitle("Продолжить", for: .normal)
                moveOnButton.layer.add(bloat(), forKey: "scaleButton")
                pageControl.numberOfPages = array[indexPathes[0].row + 1]
                pageControl.set(progress: contetnInt, animated: true)
                
                updateLabel()
                
                isRest = false
                showCheckBox()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                    self.dismissCheckBox()
                })
                return
            }
            moveOnButton.setTitle("Продолжить", for: .normal)
            moveOnButton.layer.add(bloat(), forKey: "scaleButton")
            isRest = false
            counterInt+=1
            contetnInt+=1
            pageControl.set(progress: contetnInt, animated: true)
            
            updateLabel()
            return
        }
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
        
        for i in 0..<data!.count {

           let string = data![i].stringValue
            let intString = string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
            let firstString = intString.substring(from: intString.index(after: intString.startIndex))
                arrayOfCounts.append(Int(firstString)!)
        }
        dictionary["counts"] = arrayOfCounts
        return dictionary
    }
    
    func updateLabel() {
        let cells = collectionView.visibleCells
        
        if cells.count > 0 {
        
        let cell = cells[0] as! DynamicTrainCell
        let array = dictionaryClass?.object(forKey: "counts") as! [Int]
        let exercise = data?[(collectionView.indexPath(for: cell)?.row)!].stringValue
        let count = array[(collectionView.indexPath(for: cell)?.row)!]
        let completeString = getURLString(fromString: exercise!)!
        var string = String(count)
        
        if count == 1 {
            string = "Максимум"
        }
        cell.stepLabel.text = "Шаг " + String((collectionView.indexPath(for: cell)?.row)! + 1) + ".Кол-во повторений: " + string + "\nПодход - \(contetnInt + 1): " + completeString
        }
    }
    
    func getURLString(fromString string:String) -> String? {
        var resultString = ""
        for character in string.characters {
            if character != Character("–") {
                resultString += String(character)
                continue
            }
            resultString.remove(at: resultString.index(before: resultString.endIndex))
            return resultString
        }
        return nil
    }
    
    func showCheckBox() {
        UIView.animate(withDuration: 0.2) {
        self.checkBoxView.alpha = 1.0
        }
        checkBox.setOn(true, animated: true)
        //checkBox.reload()
    }
    
    func dismissCheckBox() {
        UIView.animate(withDuration: 0.2) {
        self.checkBoxView.alpha = 0.0
        }
    }
    
    func configureCheckBox() {
        checkBox.onCheckColor = .red
        checkBox.onFillColor = .white
        checkBox.onTintColor = .red
    }
}
