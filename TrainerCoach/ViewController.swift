//
//  ViewController.swift
//  TrainerCoach
//
//  Created by User on 08/07/2017.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ExpandbleHeaderViewDelegate {

    @IBOutlet weak var tableVIew: UITableView!
    var trainData: [TrainData]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableVIew.delegate = self
        tableVIew.dataSource = self
        
        ExercisesData.getExercises { (json) in
            print(json)
        }
        
        ExercisesData.getProTraining { (proTrainig) in
            self.trainData = proTrainig
            DispatchQueue.main.async {
                self.tableVIew.reloadData()
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return trainData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (trainData?.count)! > 0 {
        if ((trainData?[section].third_week?.count)! > 0){
            return 3
        }
        return 2
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        var json: [JSON] = (trainData?[indexPath.row].first_week.arrayValue)!
        
        cell.isHidden = true
        
        switch indexPath.row {
        case 0:
            json = (trainData?[indexPath.section].first_week.arrayValue)!
        case 1:
            json = (trainData?[indexPath.section].second_week.arrayValue)!
        case 2:
            json = (trainData?[indexPath.section].third_week?.arrayValue)!
        default: break
        }
        if
            (trainData?[indexPath.section].expanded == true){
            cell.isHidden = false
        }
        
        if json.count > 0 {
            cell.textLabel?.text = json[0]["mainLabel"].stringValue
            cell.detailTextLabel?.text = json[0]["titleLabel"].stringValue
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (trainData?[indexPath.section].expanded)! {
            return 45
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = ExpandbleHeaderView()
        let title = trainData?[section].title
        cell.customInit(section: section, title: title!, delegate: self)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let proTraining = self.storyboard?.instantiateViewController(withIdentifier: "ProTraining") as! ProTrainingVC
        var json: [JSON] = (trainData?[indexPath.row].first_week.arrayValue)!
        
        switch indexPath.row {
        case 0:
            json = (trainData?[indexPath.section].first_week.arrayValue)!
        case 1:
            json = (trainData?[indexPath.section].second_week.arrayValue)!
        case 2:
            json = (trainData?[indexPath.section].third_week?.arrayValue)!
        default: break
        }
        proTraining.proData = json
        tableView.deselectRow(at: indexPath, animated: true)

        navigationController?.pushViewController(proTraining, animated: true)
        
        return nil
    }

    func toogleSection(header: ExpandbleHeaderView, section: Int) {
        trainData?[section].expanded = !(trainData?[section].expanded)!
        var numberOfrows = 2
        if ((trainData?[section].third_week?.count)! > 0){
            numberOfrows = 3
        }
        
        tableVIew.beginUpdates()
        for var i in 0..<numberOfrows {
            tableVIew.rectForRow
            tableVIew.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
            tableVIew.endUpdates()
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

