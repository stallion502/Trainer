//
//  CalloryVC.swift
//  TrainerCoach
//
//  Created by User on 09/08/2017.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit

class CalloryVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating {

    @IBOutlet weak var tableView: UITableView!
    var data: [String:[String]]{
        get {
            return UserDefaults.standard.object(forKey: "Food") as! [String : [String]]
        }
    }
    var numbersCount = [String]()
    var filteredData = [String]()
    var isFiltering = false
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController = UISearchController(searchResultsController: nil)
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchResultsUpdater = self
        tableView.delegate = self
        tableView.dataSource = self
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        if isFiltering {
            return 1
        }
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let keys = Array(data.keys)
        if isFiltering {
            return filteredData.count
        }
        return (data[keys[section]]?.count)!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let keys = Array(data.keys)
        return keys[section]
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text == nil || searchController.searchBar.text == "" {
            isFiltering = false
            view.endEditing(true)
            tableView.reloadData()
        }
        else {
            isFiltering = true
            let array = Array(data.values)
            filteredData = array.joined().filter({$0.contains((searchController.searchBar.text)!)})
            
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CalloryCell
        
        if isFiltering {
            let mainLabel = numbersForCell(indexPath, true)
            cell.mainLabel.text = mainLabel
            cell.firstUpLabel.text = numbersCount[4]
            cell.secondUpLabel.text = numbersCount[3]
            cell.thirdUplabel.text = numbersCount[1]
            cell.fouthUpLabel.text = numbersCount[2]
            return cell
        }
        
        let mainLabel = numbersForCell(indexPath, false)
        cell.mainLabel.text = mainLabel
        cell.firstUpLabel.text = numbersCount[4]
        cell.secondUpLabel.text = numbersCount[3]
        cell.thirdUplabel.text = numbersCount[1]
        cell.fouthUpLabel.text = numbersCount[2]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    
    func numbersForCell(_ indexPath: IndexPath, _ filtered: Bool) -> String {
        let keys = Array(data.keys)
        var array = [String]()
        if filtered == false {
            array = data[keys[indexPath.section]]!
        }
        else {
            array = filteredData
        }
        let stringToSearch = array[indexPath.row]
        var mainLabel = ""
        let numbers = stringToSearch.components(separatedBy: " ")
        numbersCount = [String](numbers)
        for string in numbers{
            if !isStringANumber(string: string){
                mainLabel += "\(string) "
                numbersCount.removeFirst()
            }
            else {
                return mainLabel
            }
        }
        return ""
    }
    
    @IBAction func tapedTableView(_ sender: Any) {
        searchController.searchBar.endEditing(true)
    }
    
    func isStringANumber(string: String) -> Bool{
        if Int(string) != nil || Double(string) != nil || string.characters.index(of: ",") != nil {
            return true
        }
        return false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
