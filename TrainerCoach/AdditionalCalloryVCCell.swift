//
//  AdditionalCalloryVCCell.swift
//  TrainerCoach
//
//  Created by User on 18/08/2017.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation

protocol AdditionalCalloryCellDataSource: class {
    
    func gotAdditionalText(text:String, forRow row:Int)
}


class AdditionalCalloryVCCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var fouthLabel: UILabel!
    @IBOutlet weak var textfield: UITextField!
    weak var delegate: AdditionalCalloryCellDataSource?
    var row: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textfield.delegate = self
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.gotAdditionalText(text: textfield.text!, forRow: row!)
    }
}
