//
//  AddSchedulerCell.swift
//  TrainerCoach
//
//  Created by User on 13/08/2017.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation

protocol AddScheduleGetText: class {
    func textLabelForCell(_ date:Date, _ indexPath: IndexPath)
}

class AddSchedulerCell: UITableViewCell {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    weak var delegate:AddScheduleGetText?
    var datePicked = ""
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        datePicker.timeZone = TimeZone(abbreviation: "GMT")
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
    }
    
    func dateChanged(_ sender: UIDatePicker) {
      /*  let componenets = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: sender.date)
        if let day = componenets.day, let month = componenets.month, let year = componenets.year, let hour = componenets.hour, let minute = componenets.minute {*/
            delegate?.textLabelForCell(sender.date, indexPath!)//("\(hour):\(minute)", indexPath!)//("\(day):\(month):\(year)", indexPath!)
       // }
    }
}
