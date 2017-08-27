//
//  CalloryResultsVC.swift
//  TrainerCoach
//
//  Created by User on 20/08/2017.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit

class CalloryResultsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var titles = ["Завтрак", "Обед", "Ужин"]
    var pictures = [#imageLiteral(resourceName: "oatmeal_main_2"), #imageLiteral(resourceName: "HK-main"), #imageLiteral(resourceName: "breakfast-1209260_1920")]
    var headers: [[[String:String]]]?
    var weight: String?
    var sex: String?
    var strings:[String]?
    var calloryResult = 0.0
    var fatResult = 0.0
    var uglevodsResult = 0.0
    var proteinResult = 0.0
    var totalCallories = 0.0
    var results = [[Double]]()
    @IBOutlet var annotationView: UIViewX!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectInfo()
        countCallories()
        visualEffectView.isHidden = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CalloryResultsCell
        cell.mybackgroundImage.image = pictures[indexPath.section]
        
        if (headers?[indexPath.section][0].count)! > 0 {

            let array = countParametrsForItem((headers?[indexPath.section])!)
            let colors = pickedColorForItem(array, results[indexPath.section])
            cell.firstCircularProgress.set(colors:colors[2])
            cell.secondCircularProgress.set(colors:colors[1])
            cell.thirdCircularProgress.set(colors:colors[0])
            cell.mainLabel.text = configureMainLabelForForItem(array, results[indexPath.section])
            cell.firstLabel.text = "\(Int(array[3]))/\(Int(results[indexPath.section][2]))"
            cell.secondLabel.text = "\(Int(array[2]))/\(Int(results[indexPath.section][1]))"
            cell.thirdLabel.text = "\(Int(array[1]))/\(Int(results[indexPath.section][0]))"
            
            let firstAngle = 360/results[indexPath.section][2]*array[3]
            cell.firstCircularProgress.animate(fromAngle: 0.1, toAngle: firstAngle, duration: 2.1, completion: nil)
            let secondAngle = 360/results[indexPath.section][1]*array[2]
            cell.secondCircularProgress.animate(fromAngle: 0.1, toAngle: secondAngle, duration: 2.1, completion: nil)
            let thirdAngle = 360/results[indexPath.section][0]*array[1]
            cell.thirdCircularProgress.animate(fromAngle: 0.1, toAngle: thirdAngle, duration: 2.1, completion: nil)
        }
        else{
            cell.mainLabel.text = ""
            cell.firstLabel.text = "0/0"
            cell.secondLabel.text = "0/0"
            cell.thirdLabel.text = "0/0"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titles[section]
    }

   /* func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        <#code#>
    }*/
    
    func collectInfo() {
        let myweight = Double(weight!)
        calloryResult = 35 * myweight!
        if sex == "man" {
            proteinResult = myweight!*3
            uglevodsResult = myweight!*5
            fatResult = myweight!*1.5
        }
        else {
            proteinResult = myweight!*2
            uglevodsResult = myweight!*4
            fatResult = myweight!
        }
        
        fatResult = myweight!*1.5
        let uglevods = [uglevodsResult/10*4.5, proteinResult/10*2, fatResult/10*5]
        results.append(uglevods)
        
        let proteins = [uglevodsResult/10*4.5, proteinResult/10*4, fatResult/10*4]
        results.append(proteins)
        
        let fats = [uglevodsResult/10*0.5, proteinResult/10*4, fatResult/10*1]
        results.append(fats)
    }
 
    func countParametrsForItem(_ item:[[String:String]]) -> [Double] {
        
        var array = [0.0, 0.0, 0.0, 0.0]
        for dictionary in item {
            var count = Double(dictionary["text"]!)!/100
            if dictionary["key"] == "Калорийность крупы" {
                count = Double(dictionary["text"]!)!/100/2
            }
            else if dictionary["key"] == "Калорийность мяса субпродуктов птицы" {
                count = Double(dictionary["text"]!)!/100/1.3
            }
            else if dictionary["key"] == "Калорийность рыбы и морепродуктов" {
                count = Double(dictionary["text"]!)!/100/1.3
            }
            var k = dictionary["K"]!.replacingOccurrences(of: ",", with: ".")
            var u = dictionary["U"]!.replacingOccurrences(of: ",", with: ".")
            var b = dictionary["B"]!.replacingOccurrences(of: ",", with: ".")
            var g = dictionary["G"]!.replacingOccurrences(of: ",", with: ".")
            
            k = k.replacingOccurrences(of: "—", with: "0")
            u = u.replacingOccurrences(of: "—", with: "0")
            b = b.replacingOccurrences(of: "—", with: "0")
            g = g.replacingOccurrences(of: "—", with: "0")
            
            array[0]+=Double(k)!*count
            array[1]+=Double(u)!*count
            array[2]+=Double(b)!*count
            array[3]+=Double(g)!*count
        }
        return array
    }
    
    func countCallories(){
        for item in headers!{
            for dictionary in item{
                if dictionary.count > 0{
                    var count = Double(dictionary["text"]!)!/100
                    if dictionary["key"] == "Калорийность крупы" {
                        count = Double(dictionary["text"]!)!/100/2
                    }
                    else if dictionary["key"] == "Калорийность мяса субпродуктов птицы" {
                        count = Double(dictionary["text"]!)!/100/1.3
                    }
                    else if dictionary["key"] == "Калорийность рыбы и морепродуктов" {
                        count = Double(dictionary["text"]!)!/100/1.3
                    }
                    var k = dictionary["K"]!.replacingOccurrences(of: ",", with: ".")
                    k = k.replacingOccurrences(of: "—", with: "0")
                    
                    totalCallories+=Double(k)!*count
                }
                else{
                    return
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 2{
            return 100
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1") as! FooterView
        cell.callory.text = "\(Int(totalCallories)) кк"
        var color = UIColor()
        if calloryResult/2 < abs(totalCallories - calloryResult) {
            color = #colorLiteral(red: 1, green: 0.2314, blue: 0.1882, alpha: 1)  /* #ff3b30 */
        }
        else if totalCallories*1/4 > abs(totalCallories - calloryResult) {
            color = #colorLiteral(red: 0.298, green: 0.851, blue: 0.3922, alpha: 1)
        }
        else {
            color = #colorLiteral(red: 1, green: 0.8, blue: 0, alpha: 1)
        }
        cell.myView.backgroundColor = color
        if section == 2{
            return cell
        }
        return nil
    }
    
    func pickedColorForItem(_ item:[Double], _ secondItem:[Double])-> [UIColor]{
        var colors = [UIColor]()
        
        for i in 1..<item.count{
            
            if secondItem[i-1]/2 < abs(item[i] - secondItem[i-1]) {
                colors.append(#colorLiteral(red: 1, green: 0.2314, blue: 0.1882, alpha: 1))  /* #ff3b30 */
                continue
            }
            if item[i]*1/4 > abs(item[i] - secondItem[i-1]) {
                colors.append(#colorLiteral(red: 0.298, green: 0.851, blue: 0.3922, alpha: 1) /* #4cd964 */)
                continue
            }
            else {
                colors.append(#colorLiteral(red: 1, green: 0.8, blue: 0, alpha: 1) /* #ffcc00 */)
                continue
            }
        }
        return colors
    }
    
    func configureMainLabelForForItem(_ item:[Double], _ secondItem:[Double])-> String{
        var mainLabel = [String]()
        for i in 1..<item.count{
            var string = ""
            if secondItem[i-1]/2 < abs(item[i] - secondItem[i-1]) {
                string = item[i]>secondItem[i-1] ? "Значительно уменьшить" : "Значительно увеличить"
                mainLabel.append(string)
                continue
            }
            if item[i]*1/4 > abs(item[i] - secondItem[i-1]) {
                string = "Находятся в норме"
                mainLabel.append(string)
                continue
            }
            else {
                string = item[i]>secondItem[i-1] ? "Уменьшить потребление" : "Увеличить потребление"
                mainLabel.append(string)
                continue
            }
        }
        
        return "Жиры: \(mainLabel[2])\nБелки: \(mainLabel[1])\nУглеводы: \(mainLabel[0])"
    }
    
    @IBAction func resultButtonAction(_ sender: UIButton) {
        saveToUserDafaults()
        animateNotification()
    }
    
    func saveToUserDafaults() {
        
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: headers!)
        let encodedWeight = NSKeyedArchiver.archivedData(withRootObject: weight)
        let encodedSex = NSKeyedArchiver.archivedData(withRootObject: sex)
        let userDefaults = UserDefaults.standard
        userDefaults.set(encodedData, forKey: "headers")
        userDefaults.set(encodedWeight, forKey: "weight")
        userDefaults.set(encodedSex, forKey: "sex")
        /*
         let decoded  = UserDefaults.standard.object(forKey: UserDefaultsKeys.jobCategory.rawValue) as! Data
         let decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! JobCategory
         print(decodedTeams.name)*/
        // UserDefaults.standard.set(dates, forKey: "dates")
    }
    
    func animateNotification() {
        visualEffectView.isHidden = false
        annotationView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        annotationView.center = view.center
        self.view.addSubview(annotationView)
        UIView.animate(withDuration: 0.5, animations: {
            self.annotationView.transform = .identity
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.navigationController?.popToRootViewController(animated: true)
        })
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
