//
//  DetailCalloryCell.swift
//  TrainerCoach
//
//  Created by User on 11/08/2017.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation

class DetailCalloryCell: UITableViewCell {
    @IBOutlet weak var foodLabel: UILabel! 
    @IBOutlet weak var labelStackView: UIStackView!
    
    var array: [Double] = [] {
        didSet{
            var i = 0
            labelStackView.subviews.forEach { (view) in
                (view as! UILabel).text = String(array[i])
                i+=1
            }
        }
    }
}
