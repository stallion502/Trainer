//
//  ExpandbleHeaderView.swift
//  TrainerCoach
//
//  Created by User on 08/07/2017.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation
import UIKit

protocol ExpandbleHeaderViewDelegate: class {
    func toogleSection(header: ExpandbleHeaderView,section: Int)
    func deleteSection(section: Int)
}

class ExpandbleHeaderView: UIView {
    
    weak var delegate: ExpandbleHeaderViewDelegate?
    var section: Int!
    var label: UILabel?
    @IBOutlet weak var rLabel: UILabel!
    @IBOutlet weak var lLable: UILabel!
    @IBOutlet weak var myImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectHeaderAction(sender:))))
        myImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(deletePressed(sender:))))
        print("caled")
    }
    
    func selectHeaderAction(sender: UITapGestureRecognizer){
        let cell = sender.view as! ExpandbleHeaderView
        delegate?.toogleSection(header: self, section: cell.section)
    }
     func deletePressed(sender: UITapGestureRecognizer) {
        delegate?.deleteSection(section: self.section)
    }
    
    func customInit(section: Int, title: String, delegate: ExpandbleHeaderViewDelegate) {
    //    self.leftLabel?.text = title
        self.section = section
        self.delegate = delegate
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // do some UI Stuff with header
    }
    
}
