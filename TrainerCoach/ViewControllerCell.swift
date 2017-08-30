//
//  ViewControllerCell.swift
//  TrainerCoach
//
//  Created by User on 20/08/2017.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation

protocol ViewControllerCellDelegate: class {
    func toogleSection(header: ViewControllerCell,section: Int)
}


class ViewControllerCell: UITableViewCell {
    
    weak var delegate: ViewControllerCellDelegate?
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    var section: Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectHeaderAction(sender:))))
        myImageView.layer.borderWidth = 1
        //myImageView.layer.borderColor = #colorLiteral(red: 1, green: 0.1333, blue: 0.1333, alpha: 1).cgColor
        myImageView.layer.cornerRadius = myImageView.frame.height/2
        
    }
    
    func selectHeaderAction(sender: UITapGestureRecognizer){
        let cell = sender.view as! ViewControllerCell
        delegate?.toogleSection(header: self, section: cell.section)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // do some UI Stuff with header
    }
}
