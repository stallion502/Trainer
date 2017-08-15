//
//  DetailCalloryVC.swift
//  TrainerCoach
//
//  Created by User on 11/08/2017.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit

class DetailCalloryVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    let calloryData = CalloryData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.backItem?.title = ""
        navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calloryData.dictionaryBreakfast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DetailCalloryCell
        let keys = Array(calloryData.dictionaryBreakfast.keys)
        let key = keys[indexPath.row]
        cell.array = calloryData.dictionaryBreakfast[key]!
        cell.foodLabel.text = key
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (tableView.frame.height)  / CGFloat(calloryData.dictionaryBreakfast.count)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Рекомендуемые продукты"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "Avenir-Medium", size: 18)!
        header.textLabel?.textColor = UIColor.black
    }

    func configureCell(_ cell: DetailCalloryCell, _ indexPath:IndexPath) -> DetailCalloryCell{
        let keys = Array(calloryData.dictionaryBreakfast.keys)
        let key = keys[indexPath.row]
        cell.array = calloryData.dictionaryBreakfast[key]!
        cell.foodLabel.text = key
        return cell
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
