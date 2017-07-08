//
//  ExpandbleHeaderView.swift
//  TrainerCoach
//
//  Created by User on 08/07/2017.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation
import UIKit

protocol ExpandbleHeaderViewDelegate {
    func toogleSection(header: ExpandbleHeaderView,section: Int)
}

class ExpandbleHeaderView: UITableViewHeaderFooterView {
    
    var delegate: ExpandbleHeaderViewDelegate?
    var section: Int!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectHeaderAction(sender:))))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func selectHeaderAction(sender: UITapGestureRecognizer){
        let cell = sender.view as! ExpandbleHeaderView
        delegate?.toogleSection(header: self, section: cell.section)
    }
    
    func customInit(section: Int, title: String, delegate: ExpandbleHeaderViewDelegate) {
        self.textLabel?.text = title
        self.section = section
        self.delegate = delegate
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // do some UI Stuff with header
    }
    
}
