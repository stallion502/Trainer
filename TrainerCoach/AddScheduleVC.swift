//
//  AddScheduleVC.swift
//  TrainerCoach
//
//  Created by User on 12/08/2017.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit
import UserNotifications

class AddScheduleVC: UIViewController, UITableViewDelegate, UITableViewDataSource, ExpandbleHeaderViewDelegate, AddScheduleGetText {

    @IBOutlet weak var tableView: UITableView!
    var pressed = -1
    var cells =  [Int:Bool]()
    var headers = [Int: ExpandbleHeaderView]()
    var times = [Int:String]()
    var dates = [Int: Date]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cells[0] = false
        cells[1] = false
        cells[2] = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.alwaysBounceVertical = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.backItem?.title = ""
        navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AddSchedulerCell
        cell.isHidden = true
        cell.delegate = self
        cell.indexPath = indexPath

        if
            cells[indexPath.section] == true{
            cell.isHidden = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if cells[indexPath.section] == true {
            return 160
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = Bundle.main.loadNibNamed("ExpandbleHeader", owner: self, options: nil)?.first as! ExpandbleHeaderView
        let title = "Прием пищи: \(section + 1)"
        cell.section = section
        cell.lLable.text = title
        cell.rLabel.text = "Время: "
        cell.delegate = self
        if let title = times[section] {
            cell.rLabel.text = title
        }
        
        //  cell.customInit(section: section, title: title, delegate: self)
        if let _ = headers[section] {
            headers[section] = cell
            if let title = times[section] {
                cell.rLabel.text = title
            }
            return cell
        }

        
        
        headers[section] = cell
        return cell
    }
    
    @IBAction func buttonTapped(_ sender: UITapGestureRecognizer) {
        print("taped")
        let count = cells.count
        cells[count] = false
        tableView.reloadData()
    }
    
    func saveToRealm() {
        
    }
    
    func addLocalNotifications() {
        
            for date in dates {
                
            }
            
        if #available(iOS 10.0, *) {
            
 /*           let content = UNMutableNotificationContent()
        
        content.title = "Пора продолжать."
        content.body = "Следующее упражнение - \(string)"
        content.sound = UNNotificationSound.default()
        
        // Deliver the notification in five seconds.
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 3, repeats: false)
        let request = UNNotificationRequest.init(identifier: "FiveSecond", content: content, trigger: trigger)
        // Schedule the notification.
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            print(error)
        }
        let systemSoundID: SystemSoundID = 1016
        
        // to play sound
        AudioServicesPlaySystemSound (systemSoundID)
    }
    else {
        let notification = UILocalNotification()
        notification.alertBody = "Следующее упражнение - \(string)"
        notification.alertAction = "back to app"
        notification.fireDate = NSDate.init(timeIntervalSinceNow: 0) as Date
        notification.soundName = UILocalNotificationDefaultSoundName
    
        UIApplication.shared.scheduleLocalNotification(notification)
    }*/
        }
        }

/*
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
        proTraining.titleLabelText = trainData?[indexPath.section].title
        tableView.deselectRow(at: indexPath, animated: true)
        
        navigationController?.pushViewController(proTraining, animated: true)
        
        return nil
    }
    */
    func toogleSection(header: ExpandbleHeaderView, section: Int) {
        cells[section] = !cells[section]!
        let numberOfrows = 1

        tableView.beginUpdates()
        for i in 0..<numberOfrows {
            tableView.rectForRow
            tableView.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
            tableView.endUpdates()
        }
    }
    
    func textLabelForCell(_ date:Date, _ indexPath: IndexPath) {
        let header = headers[indexPath.section]!
        dates[indexPath.section] = date
        let componenets = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        if let hour = componenets.hour, let minute = componenets.minute {
            times[indexPath.section] = "Время: " + "\(hour):\(minute)"
            header.rLabel.text! = "Время: " + "\(hour):\(minute)"
        }
        // do something here
    }

    func deleteSection(section: Int) {
        var i = section
        if i == cells.count-1 {
            cells[i] = nil
            headers[i] = nil
            times[i] = nil
            dates[i] = nil
            tableView.reloadData()
            return
        }
        
        for _ in section..<cells.count-1{
            cells[i] = cells[i+1]
            cells[i+1] = nil
            headers[i] = headers[i+1]
            headers[i+1] = nil
            times[i] = times[i+1]
            times[i+1] = nil
            dates[i] = dates[i+1]
            dates[i+1] = nil
            i+=1
        }
        
        tableView.reloadData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        print("deinit ViewController")
    }
    
}

extension Date {
    var minute: Int {
        return Calendar.current.component(.minute, from: self)
    }
    var hour: Int {
        return Calendar.current.component(.hour, from: self)
    }
    var day: Int {
        return Calendar.current.component(.day, from: self)
    }
    var month: Int {
        return Calendar.current.component(.month, from: self)
    }
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }
    var fireDate: Date {
        let today = Date()
        return Calendar.current.date(from: DateComponents(calendar: Calendar.current, timeZone: .current, era: 1,
                                                        year: today.year,
                                                        month: today.month,
                                                        day: { hour > today.hour || (hour  == today.hour
                                                            &&  minute > today.minute) ? today.day : today.day+1 }(),
                                                        hour: hour,
                                                        minute: minute,
                                                        second: 0,
                                                        nanosecond: 0, weekday: nil, weekdayOrdinal:nil, quarter:nil, weekOfMonth:nil, weekOfYear: nil, yearForWeekOfYear: nil))!
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
