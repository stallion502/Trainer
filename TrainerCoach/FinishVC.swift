//
//  FinishVC.swift
//  TrainerCoach
//
//  Created by User on 21/07/2017.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit
import KDCircularProgress
import SwiftyJSON

class FinishVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var iphoneView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var progressView: KDCircularProgress!
    @IBOutlet weak var InsideProgressView: UIView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var topLayout: NSLayoutConstraint!
    @IBOutlet weak var bottomLayout: NSLayoutConstraint!
    var titleLabelText: String?
    var time: String?
    
    var timer: Timer?
    var value = 0 // hardcoded
    var swiftyData: [JSON]?
    let images = [#imageLiteral(resourceName: "birn"), #imageLiteral(resourceName: "time"), #imageLiteral(resourceName: "muscle"), #imageLiteral(resourceName: "dummbell")]
    let titles = ["Калорий сожжено:", "Время тренировки:", "Рабочие группы:", "Выполнено упражнений:"] // hardcoded
    let data = ["342", "", "Ноги - плечи", "13"] // HardCoded what muscle groupe to use - Will be solved by Firebase
    var value1 = 0
    var value2 = 0
    var value3 = 0
    var week: Int?
    //Check if train was already when toggle header pop up view with time of training decide what to add to user defaults 
    override func viewDidLoad() {
        super.viewDidLoad()
        timer = Timer.scheduledTimer(timeInterval: 0.025, target: self, selector: #selector(updateLabel), userInfo: nil, repeats: true)
        configureView()
        progressView.roundedCorners = false
     //   progressView.startAngle = -90
        progressView.angle = 0.5
        progressView.glowMode = .forward
        
        var count = 1
        
        if let exercice = UserDefaults.standard.object(forKey: titleLabelText!) as? Array<Any> {
            count = exercice.count
        }
        
        progressView.animate(fromAngle: 0.1, toAngle: Double(120 * count), duration: 2.1) { (bool) in
            
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.transform = CGAffineTransform(translationX: 1000, y: 0)
        
        UIView.animate(withDuration: 1.0, delay: 0.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.7, options: [], animations: {
            self.tableView.transform = .identity
        })
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 0.1333, blue: 0.1333, alpha: 1)
        let font = UIFont(name: "Avenir-Light", size: 25.0)
        let attributeFontSaySomething : [String : Any] = [NSFontAttributeName : font!, NSForegroundColorAttributeName: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = attributeFontSaySomething
        navigationController?.navigationBar.topItem?.title = "Results"
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "identifier", for: indexPath) as! FinishCell
        if indexPath.row == 1 {
            cell.myImageView.image = images[indexPath.row]
            cell.leftLabel.text = titles[indexPath.row]
            cell.rightLabel.text = self.time
            return cell
        }
        
        cell.myImageView.image = images[indexPath.row]
        cell.leftLabel.text = titles[indexPath.row]
        cell.rightLabel.text = data[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 25
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func configureView() {
        iphoneView.layer.cornerRadius = 3
        iphoneView.layer.masksToBounds = true
        var coeff = 2.0
        progressView.progressThickness = 0.45
        progressView.trackThickness = 0.45
        
        topLayout.constant = 35
        bottomLayout.constant = 7
        
        let maxWidth = max(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        
        if maxWidth > 568 {
            coeff = 1.4
            progressView.progressThickness = 1.0
            progressView.trackThickness = 1.0
        }
        
        if maxWidth >= 735 {
            coeff = 1.24
            topLayout.constant = 41
            bottomLayout.constant = 12
            progressView.progressThickness = 1.2
            progressView.trackThickness = 1.2
        }
        
        
        InsideProgressView.layer.cornerRadius = InsideProgressView.frame.size.width / CGFloat(coeff)//progressView.cor
        InsideProgressView.layer.masksToBounds = true
    }
    
   // func add
    
    func updateLabel() {
        
        let cells = tableView.visibleCells
        
        if value != 44 {
            value += 1
            let firstWord = titleLabelText?.components(separatedBy: " ").first
            self.mainLabel.text = "\(firstWord ?? "") Progress\n\(value)%"
        }
        
        if value3 != swiftyData?.count{
            value3 += 1
            let cell = cells[3] as! FinishCell
            cell.rightLabel.text = String(value3)
        }
        //Hardcoded what calories are used - Now is equal to 15
        if value1 != (swiftyData?.count)!*15{
            value1 += 1
            let cell = cells[0] as! FinishCell
            cell.rightLabel.text = String(value1)
        }
            
        else {
            timer?.invalidate()
            timer = nil
        }
    }
    
    @IBAction func finishAction(_ sender: UIButton) {

    }
    //Not working on the moment
    @IBAction func taped(_ sender: UITapGestureRecognizer) {
        
        UIView.animate(withDuration: 0.4) {
            self.iphoneView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }
        if sender.state == .ended {
            UIView.animate(withDuration: 0.4) {
                self.iphoneView.transform = .identity
            }
            return
        }
    }
    
    @IBAction func tapedPhoneView(_ sender: UITapGestureRecognizer) {
        
        UIView.animate(withDuration: 0.4) {
            self.iphoneView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }
        
        if sender.state == .ended {
            UIView.animate(withDuration: 0.4) {
                self.iphoneView.transform = .identity
            }
            return
        }
    }
    
    func saveToDefaults() {
        //  Need to be repaired, check for already done this week
        var dictionaryToWrite = NSMutableDictionary()
        dictionaryToWrite["time"] = self.time
        dictionaryToWrite["exercises"] = swiftyData?.count
        dictionaryToWrite["data"] = NSDate()
        dictionaryToWrite["title"] = "\(titleLabelText!) - Day: \(week!)"
        dictionaryToWrite["calories"] = (swiftyData?.count)! * 15 // Hardcoded ahain, doesn't know calorie value for ex
      //  if arrayOfArnold
      //  UserDefaults.standard.set(<#T##value: Any?##Any?#>, forKey: <#T##String#>)
    }

}
