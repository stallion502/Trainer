//
//  CalloryData.swift
//  TrainerCoach
//
//  Created by User on 11/08/2017.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation

struct CalloryData {
    private let breakfast = ["Яйца(Белок)", "Куриное мясо", "Ржаной хлеб", "Мед", "Сыр", "Каши"]
    private let eggs = [336, 7, 73.3, 1.8]
    private let chiken = [165, 0.6, 20.8, 8.8]
    private let brad = [214, 49.8, 4.7, 0.7]
    private let med = [308, 80.3, 0.8, 0]
    private let cheese = [350, 0, 24.9, 26.5]
    private let meal = [345, 65.4, 11.9, 5.8]
    var dictionaryBreakfast : [String: [Double]]
    
    init() {
        var value = 0
        dictionaryBreakfast = [String: [Double]]()
        let breakfastStuff = [eggs, chiken, brad, med, cheese, meal]
        for _ in breakfast {
            dictionaryBreakfast[breakfast[value]] = breakfastStuff[value]
            value+=1
        }
    }
}
