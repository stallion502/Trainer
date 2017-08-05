//
//  MainUserVC.swift
//  TrainerCoach
//
//  Created by User on 28/07/2017.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit
import SwiftyJSON

class MainUserVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var                userAttributes:[String]?
    var                program:String?
    var                programData:JSON?
    @IBOutlet weak var tableView:UITableView!
    var                titles: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        tabBarController?.tabBar.isHidden = false
        tableView.transform = CGAffineTransform(translationX: 1000, y: 0)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        
        ExercisesData.getProgram(program!) { [weak self] json in
           print(json)
            self?.programData = json
            self?.tableView.reloadData()
            UIView.animate(withDuration: 0.4, delay: 0.3, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.4, options: [], animations: {
                self?.tableView.transform = .identity
            })
            self?.setTitles()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        self.title = "Тренировки"
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.title = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var number = 0
        if let index = programData?.array?.count{
            number = (index - 3)*5 + 3
        }
        else {
            number = 0
        }
        return number
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MainUserCell
        cell.selectionStyle = .none
        if indexPath.row > 2 {
            cell.mainLabel.textColor = UIColor.lightGray
            cell.mytitleLabel.textColor = UIColor.lightGray
        }
        else {
            cell.mainLabel.textColor = UIColor.black
            cell.mytitleLabel.textColor = UIColor.black
        }
            cell.mytitleLabel.text = nil
        
        cell.mainLabel?.text = "Тренировка \(indexPath.row + 1)"
        let title = titles?[indexPath.row]
        cell.mytitleLabel.text = title
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let toVC = self.storyboard?.instantiateViewController(withIdentifier: "TrainingVC") as! TrainingVC
        toVC.indexVC = indexPath.row + 1
        toVC.trainingData = programData?[indexPath.row].arrayValue
        navigationController?.pushViewController(toVC, animated: true)
    }
    
    func setTitles() {
        var array = programData?.arrayValue
        titles = [String]()
        titles?.append((array?[0].arrayValue.last?.stringValue)!)
        array?.removeFirst()
        titles?.append((array?[0].arrayValue.last?.stringValue)!)
        array?.removeFirst()
        titles?.append((array?[0].arrayValue.last?.stringValue)!)
        array?.removeFirst()
        
        for _ in 0..<5 {
            for item in array! {
                self.titles?.append((item.arrayValue.last?.stringValue)!)
            }
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
    
    deinit {
        print("MainUserVC")
    }

}
