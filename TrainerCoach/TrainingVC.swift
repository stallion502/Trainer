//
//  TrainingVC.swift
//  TrainerCoach
//
//  Created by User on 05/08/2017.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit
import SwiftyJSON

class TrainingVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var trainingData: [JSON]?
    var indexVC: Int?
    var groups: String?
    var type: String?
    var titleLabelText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(false, animated: false)
        tableView.delegate = self
        tableView.dataSource = self
        self.title = "Тренировка \(indexVC ?? 0)"
     //   self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.backItem?.title = ""
        navigationController?.navigationBar.tintColor = UIColor.white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (trainingData?.count)! - 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TrainingCell
        cell.countLabel.text = String(indexPath.row + 1)
        let title = trainingData?[indexPath.row].stringValue
        let numbers = title?.components(separatedBy: CharacterSet.decimalDigits.inverted).filter({return !$0.isEmpty})
        
        cell.mainLabel.text = getURLString(fromString: title!)
        var repeats = "Макс."
        if numbers?[1] != "1"{
            repeats = (numbers?[1])!
        }
        cell.repeatLabel.text = "\(numbers?[0] ?? "")x\(repeats ?? "")"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (trainingData?.count)! > 7 {
            return 65
        }
        return (view.frame.height - 140)/CGFloat((trainingData!.count - 1))
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
    
    
    @IBAction func moveOnAction(_ sender: UIButton) {
        let toVC = storyboard?.instantiateViewController(withIdentifier: "DynamicTrainVC") as! DynamicTrainVC
        toVC.groups = self.groups
        toVC.data = trainingData
        toVC.type = self.type
        toVC.week = indexVC! - 1
        toVC.titleLabelText = self.titleLabelText
        navigationController?.pushViewController(toVC, animated: true)
    }

    deinit {
        print("TrainingVC")
    }

}
