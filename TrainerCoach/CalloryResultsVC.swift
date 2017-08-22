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
    var headers: [[[String:String]]]?
    var weight: String?
    var sex: String?
    
    var calloryResult = 0
    var fatResult = 0
    var uglevodsResult = 0
    var proteinResult = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectInfo()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if let row = headers?[indexPath.section] {
            
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
        let myweight = Int(weight!)
        calloryResult = 35 * myweight!
        if sex == "man" {
            proteinResult = myweight!*3
            uglevodsResult = myweight!*5
        }
        else {
            proteinResult = myweight!*2
            uglevodsResult = myweight!*4
        }
        
        fatResult = myweight!
    }
 /*
    func countParametrsForItem(_ item:[[String:String]]) -> [Int] {
        
        var array = [Int]()
        for dictionary in item {
            array[0]+=Int(dictionary["K"]!)!
            array[1]+=Int(dictionary["U"]!)!
            array[2]+=Int(dictionary["B"]!)!
            array[3]+=Int(dictionary["G"]!)!
        }
    }
  */  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
