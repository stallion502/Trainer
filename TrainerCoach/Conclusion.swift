//
//  Conclusion.swift
//  TrainerCoach
//
//  Created by User on 28/07/2017.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class Conclusion: Object {
    dynamic var key = ""
    dynamic var time = ""
    dynamic var exercises = 0
    dynamic var date = Date()
    dynamic var title = ""
    dynamic var calories = 0
    dynamic var week = 0
}
