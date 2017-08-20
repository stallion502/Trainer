//
//  CountCalloryVC.swift
//  TrainerCoach
//
//  Created by User on 17/08/2017.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit

class CountCalloryVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CalloryVCDataSource, CountCalloryCellDataSource, AdditionalCalloryCellDataSource{

    @IBOutlet weak var tableView: UITableView!
    var cellsForBreakfast = [[String:String](), [String: String](), [String:String]()]
    var cellsForLunch = [[String:String](), [String: String](), [String:String]()]
    var cellsForDinner = [[String:String](), [String: String](), [String:String]()]
    var mycells: [[[String:String]]]?
    var currentSegment = 0
    var selectedCell:Int?
    @IBOutlet weak var redButton: UIViewX!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mycells = [cellsForBreakfast, cellsForLunch, cellsForDinner]
        segmentControl.addTarget(self, action: #selector(segmentedControlValueChanged(segment:)), for: .valueChanged)
        redButton.layer.add(addBlink(), forKey: "blinking")
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.backItem?.title = ""
        navigationController?.navigationBar.tintColor = UIColor.white
        self.title = "Рассчитать дневной рацион"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mycells![currentSegment].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CountCalloryCell
        cell.mainLabel?.text = "Продукт \(indexPath.row + 1)"
        cell.delegate = self
        cell.row = indexPath.row
        cell.textfield.text = ""
        if let text = mycells?[currentSegment][indexPath.row]["text"]{
            cell.textfield.text = text
        }
        
        let cells = mycells?[currentSegment]
        if let mainLabel = cells?[indexPath.row]["mainLabel"] {
            let additionalCell = tableView.dequeueReusableCell(withIdentifier: "cell2") as! AdditionalCalloryVCCell
            additionalCell.textfield.text = ""
            if let text = mycells?[currentSegment][indexPath.row]["text"]{
                additionalCell.textfield.text = text
            }
            additionalCell.mainLabel.text = mainLabel
            additionalCell.delegate = self
            additionalCell.row = indexPath.row
            additionalCell.firstLabel.text = cells?[indexPath.row]["K"]
            additionalCell.secondLabel.text = cells?[indexPath.row]["U"]
            additionalCell.thirdLabel.text = cells?[indexPath.row]["B"]
            additionalCell.fouthLabel.text = cells?[indexPath.row]["G"]
            
            return additionalCell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedCell = indexPath.row
        let toVC = self.storyboard?.instantiateViewController(withIdentifier: "CalloryVC") as! CalloryVC
        toVC.delegate = self
        toVC.presented = true
        self.navigationController?.show(toVC, sender: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print("CountCalloryVC")
    }
    
    func getDataFromCalloryVC(data: [String : String]) {
        print(data)
        if let text = mycells?[currentSegment][selectedCell!]["text"] {
            var dict = data
            dict["text"] = text
            mycells?[currentSegment][selectedCell!] = dict
        }
        else {
           mycells?[currentSegment][selectedCell!] = data
        }
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       if let _ = mycells?[currentSegment][indexPath.row]["mainLabel"] { //[indexPath.row].count)! > 0 {
            return 120
        }
        return 60
    }

    func addBlink() -> CABasicAnimation {
        
        let animation = CABasicAnimation(keyPath: "opacity");
        animation.fromValue = 0.5
        animation.toValue = 1
        animation.repeatCount = Float.infinity
        animation.duration = 3.0
        
        return animation
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            mycells?[currentSegment].remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    func gotText(text: String, forRow row: Int) {
        mycells?[currentSegment][row]["text"] = text
        print(text)
    }
    
    func gotAdditionalText(text: String, forRow row: Int) {
        if let _ = mycells?[currentSegment][row]["text"]{
            return
        }
        else {
            mycells?[currentSegment][row]["text"] = text
        }
        print(text)
    }
    
    @IBAction func redButtonPressed(_ sender: UITapGestureRecognizer) {
        mycells?[currentSegment].append([String:String]())
        tableView.reloadData()
    }

    @IBAction func mainButtonPressed(_ sender: Any) {
      //  collectInfo()
    }

    
    func collectInfo() -> Bool {
        var isGoing = true
        let cells = mycells?[currentSegment]
        
        for i in 0..<(cells?.count)! {
            
            if cells?[i]["mainLabel"] == nil || cells?[i]["text"] == nil {
                let cell = tableView.cellForRow(at: IndexPath.init(row: i, section: 0))
                cell?.shake()
                isGoing = false
            }
        }
        return isGoing
    }
    
    func segmentedControlValueChanged(segment: UISegmentedControl) {
        currentSegment = segment.selectedSegmentIndex
        tableView.reloadData()
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
       return collectInfo()
    }
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let toVC = segue.destination as! CalloryResultsVC
        toVC.headers = mycells
    }
    

}
