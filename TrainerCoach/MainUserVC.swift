//
//  MainUserVC.swift
//  TrainerCoach
//
//  Created by User on 28/07/2017.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift

class MainUserVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var                userAttributes:[String]?
    var                program:String?
    var                programData:JSON?
    @IBOutlet weak var tableView:UITableView!
    var                titles: [String]?
    @IBOutlet weak var blurView: UIView!
    @IBOutlet var      popUp: UIView!
    @IBOutlet weak var mainLabel: UILabel!
    var                indexVC:Int?
    var                time:Date?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.transform = CGAffineTransform(translationX: 1000, y: 0)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        blurView.isHidden = true
        popUp.layer.cornerRadius = 5
        popUp.layer.masksToBounds = true
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.hidesBottomBarWhenPushed = false
        tabBarController?.tabBar.isHidden = false
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
        cell.backgroundColor = UIColor.clear
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
        
        cell.backgroundColor = isCellDoneFor(indexPath) ? UIColor.init(red: 76/255, green: 217/255, blue: 100/255 , alpha: 0.5) : UIColor.clear
        
        cell.mainLabel?.text = "Тренировка \(indexPath.row + 1)"
        let title = titles?[indexPath.row]
        cell.mytitleLabel.text = title
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isCellDoneFor(indexPath) {
            animateIn("Тренировка уже проводилась")
            indexVC = indexPath.row
            return
        }
        
        let toVC = self.storyboard?.instantiateViewController(withIdentifier: "TrainingVC") as! TrainingVC
        toVC.indexVC = indexPath.row + 1
        var data = indexPath.row > 2 ? programData?[(indexPath.row+1)%4 + 3].arrayValue : programData?[indexPath.row].arrayValue // hardcoded
        toVC.groups = data?.last?.stringValue
        data?.removeLast()
        toVC.trainingData = data // hardcoded
        toVC.type = "user"
        toVC.titleLabelText = "Тренировка"
        
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
    
    func isCellDoneFor(_ indexPath:IndexPath) -> Bool {
        let realm = try! Realm()
        let conclusions = realm.objects(Conclusion.self).filter("key = 'Тренировка'")
        if conclusions.count != 0 {
            for conclusion in conclusions {
                if conclusion.week == indexPath.row && conclusion.type == "user" {
                    time = conclusion.date
                    return true
                    
                }
            }
        }
        return false
    }
    
    @IBAction func popBackAction(_ sender: Any) {
        UIView.animate(withDuration: 0.4, animations: {
            self.popUp.alpha = 0
            self.blurView.isHidden = true
        }, completion:{ bool in
            self.popUp.removeFromSuperview()
        })
    }
    

    func animateIn(_ name:String) {
        popUp.alpha = 0
        popUp.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        popUp.center = view.center
        popUp.dropShadow()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let date = formatter.string(from:(time)!)
        let text = "Последняя тренировка: " + date
        mainLabel.text = name + "\n" + text
        view.addSubview(popUp)
        self.blurView.isHidden = false
        UIView.animate(withDuration: 0.4) {
            self.popUp.alpha = 1
            self.popUp.transform = .identity
        }
    }
    
    @IBAction func goOnAction(_ sender: Any) {
        let toVC = self.storyboard?.instantiateViewController(withIdentifier: "TrainingVC") as! TrainingVC
        toVC.indexVC = indexVC! + 1
        var data = indexVC! > 2 ? programData?[(indexVC!+1)%4 + 3].arrayValue : programData?[indexVC!].arrayValue
        toVC.groups = data?.last?.stringValue
        data?.removeLast()
        toVC.trainingData = data // hardcoded
        toVC.type = "user"
        toVC.titleLabelText = "Тренировка"
        
        UIView.animate(withDuration: 0.4, animations: {
            self.popUp.alpha = 0
            self.blurView.isHidden = true
        }, completion:{ bool in
            self.popUp.removeFromSuperview()
        })
        
        navigationController?.pushViewController(toVC, animated: true)
    }
    
    deinit {
        print("MainUserVC")
    }

}
