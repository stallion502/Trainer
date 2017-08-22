//
//  CalloryResultCell.swift
//  TrainerCoach
//
//  Created by User on 21/08/2017.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation
import KDCircularProgress

class CalloryResultsCell: UITableViewCell {
    
    @IBOutlet weak var firstCircularProgress: KDCircularProgress!
    
    @IBOutlet weak var secondCircularProgress: KDCircularProgress!
    
    @IBOutlet weak var thirdCircularProgress: KDCircularProgress!
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var mainLabel: UILabel!
    
    @IBOutlet weak var mybackgroundImage: UIImageView!
    
}
