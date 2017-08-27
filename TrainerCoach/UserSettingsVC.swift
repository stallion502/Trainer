//
//  UserSettingsVC.swift
//  TrainerCoach
//
//  Created by User on 26/08/2017.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit
import RealmSwift

class UserSettingsVC: UIViewController, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var collectionView: UICollectionView!
    var trainData: [TrainData]?
    var filteredData = [Results<Conclusion>]()
    @IBOutlet weak var stackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let picker = UIImagePickerController()
        scrollView.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        ExercisesData.getProTraining { (proTrainig) in
            self.trainData = proTrainig
            self.parseData()
           DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        ExercisesData.getProTraining { (proTrainig) in
            self.trainData = proTrainig
            self.parseData()
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        
        if let decoded  = UserDefaults.standard.object(forKey: "dates") as? Data {
            let dates = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [Int: Date]
            var i = 0
            stackView.subviews.forEach { (view) in
                if let date = dates[i] {
                    var calendar = Calendar.current
                    calendar.timeZone = TimeZone(abbreviation: "GMT")!
                    let componenets = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
                    if let hour = componenets.hour, let minute = componenets.minute {
                        let titleM = minute < 10 ? "0\(minute)" : "\(minute)"
                        let titleH = hour < 10 ? "0\(hour)" : "\(hour)"
                        (view.subviews.first as! UILabel).text = titleM + ":" + titleH
                    }
                }
                else {
                    view.isHidden = true
                }
                i+=1
            }
        }
        else {
            stackView.subviews.forEach({ (view) in
                (view.subviews.first as! UILabel).text = "-"
            })
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if trainData != nil {
            if (trainData?.count)! + 1 > 3 {
                return trainData!.count + 1
            }
        }
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! UserSettingsCell
        let count = indexPath.row == 0 ? 25 : 3
        let title = indexPath.row == 0 ? "Daily" : trainData?[indexPath.row - 1].title
        var number = 0
        if filteredData.indices.contains(indexPath.row) {
            number = filteredData[indexPath.row].count
        }
        cell.circularProgress.animate(fromAngle: 0.1, toAngle: Double(360/count*number), duration: 1.5, completion: nil)
        cell.labelProgress.text = "\(title?.components(separatedBy: " ").first ?? "") Progress\n\(Int(100*number/count))%"
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func parseData() {
        filteredData.removeAll()
        let realm = try! Realm()
        let userTrain = realm.objects(Conclusion.self).filter("key = 'Тренировка'")
        filteredData.append(userTrain)
        
        for data in trainData! {
            var conclusions = realm.objects(Conclusion.self)
            
            if conclusions.count > 0 {
                conclusions = conclusions.filter("key = '\(data.title)'")
                if conclusions.count > 0 {
                    filteredData.append(conclusions)
                }
            }
        }
    }
    
    @IBAction func trainProgramAction(_ sender: UIButton) {//may not work
        let toVC = storyboard?.instantiateViewController(withIdentifier: "InitialUserVC") as! InitialUserVC
        navigationController?.pushViewController(toVC, animated: true)
    }
    
    @IBAction func changeScheduleAction(_ sender: UIButton) {
        let toVC = storyboard?.instantiateViewController(withIdentifier: "AddScheduleVC") as! AddScheduleVC
        navigationController?.pushViewController(toVC, animated: true)
    }
    
    @IBAction func countCalloryAction(_ sender: UIButton) {
        
        if let decoded  = UserDefaults.standard.object(forKey: "headers") as? Data {
            let headers = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [[[String:String]]]
            let decodedWeight  = UserDefaults.standard.object(forKey: "weight") as? Data
            let decodedSex  = UserDefaults.standard.object(forKey: "sex") as? Data
            let sex = NSKeyedUnarchiver.unarchiveObject(with: decodedSex!) as! String
            let weight = NSKeyedUnarchiver.unarchiveObject(with: decodedWeight!) as! String
            let toVC = storyboard?.instantiateViewController(withIdentifier: "CalloryResultsVC") as! CalloryResultsVC
            toVC.headers = headers
            toVC.weight = weight
            toVC.sex = sex
            navigationController?.pushViewController(toVC, animated: true)
        }
        else {
            tabBarController?.selectedIndex = 2
        }
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
