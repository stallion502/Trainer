//
//  ExercisesData.swift
//  TrainerCoach
//
//  Created by User on 08/07/2017.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation
import SwiftyJSON
import FirebaseCore
import Firebase

class ExercisesData {
    
    
    static func getExercises(completion: @escaping (JSON) -> ()) {
        let reference = Database.database().reference(fromURL: "https://personalcoach-edc0d.firebaseio.com")
        reference.child("Exercises").queryOrderedByKey().observe(.value, with: { (snapshot) in
            let json = JSON(snapshot.value as AnyObject)
            completion(json)
        })
    }
    
    static func getProTraining(completion: @escaping ([TrainData]) -> ()) {
        let reference = Database.database().reference(fromURL: "https://personalcoach-edc0d.firebaseio.com")
        reference.child("pro_trainig").queryOrderedByKey().observe(.value, with: { (snapshot) in
            let json = JSON(snapshot.value as AnyObject).arrayValue
            var localArray:Array = [TrainData]()
            for jsonObject in json {
                localArray.append(TrainData(first_week: jsonObject["first_week"], second_week: jsonObject["second_week"], third_week: jsonObject["third_week"], tips: jsonObject.arrayValue, title: jsonObject["title"].stringValue, expanded: false))
            }
            completion(localArray)
        })
    }

}
