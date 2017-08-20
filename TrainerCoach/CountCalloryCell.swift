//
//  CountCalloryCell.swift
//  TrainerCoach
//
//  Created by User on 17/08/2017.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation

protocol CountCalloryCellDataSource: class {
    
    func gotText(text:String, forRow row:Int)
}


class CountCalloryCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var textfield: UITextField!
    weak var delegate: CountCalloryCellDataSource?
    var row: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textfield.delegate = self
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.gotText(text: textfield.text!, forRow: row!)
    }
}

