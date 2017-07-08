//
//  TrainData.swift
//  TrainerCoach
//
//  Created by User on 08/07/2017.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation
import SwiftyJSON

struct TrainData {
    var first_week: JSON
    var second_week: JSON
    var third_week: JSON?
    var tips: [JSON]
    var title: String
    var expanded: Bool
    
    init(first_week:JSON, second_week:JSON, third_week:JSON? = nil, tips: [JSON], title: String, expanded: Bool) {
        self.first_week = first_week
        self.second_week = second_week
        self.third_week = third_week
        self.tips = tips
        self.title = title
        self.expanded = expanded
    }
}
