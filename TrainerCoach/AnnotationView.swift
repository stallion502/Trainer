//
//  AnnotationView.swift
//  TrainerCoach
//
//  Created by User on 28/07/2017.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation
import UIKit

protocol AnnotationViewDelegate:class {
    func buttonTaped()
}

class AnnotationView: UIView {
    
    weak var delegate:AnnotationViewDelegate?
    
    @IBOutlet weak var mainLabel_1: UILabel!
    @IBOutlet weak var mainLabel_2: UILabel!
    @IBOutlet weak var mainLabel_3: UILabel!
    @IBOutlet weak var mainLabel_4: UILabel!
    
    @IBOutlet weak var titleLabel_1: UILabel!
    @IBOutlet weak var titleLabel_2: UILabel!
    @IBOutlet weak var titleLabel_3: UILabel!
    @IBOutlet weak var titleLabel_4: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBAction func doneTaped(_ sender: UIButton) {
        delegate?.buttonTaped()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        print("aButt")
    }
}
