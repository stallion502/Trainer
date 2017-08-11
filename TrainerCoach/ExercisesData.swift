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
import SwiftSoup

class ExercisesData {
    
    
    static func getExercises(completion: @escaping (JSON) -> ()) {
        let reference = Database.database().reference(fromURL: "https://personalcoach-edc0d.firebaseio.com")
        reference.child("Exercises").queryOrderedByKey().observe(.value, with: { (snapshot) in
            let json = JSON(snapshot.value as AnyObject)
            completion(json)
        })
    }
    
    static func getProgram(_ key:String, completion: @escaping (JSON) -> ()) {
        let reference = Database.database().reference(fromURL: "https://personalcoach-edc0d.firebaseio.com")
        reference.child(key).queryOrderedByKey().observe(.value, with: { (snapshot) in
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
    
    static func writeToDataBase(){
        var finish = [String]()
        var headers = [String]()
        var dictionary = [String : [String]]()
        let string = "http://updiet.info/tablitsa-kaloriynosti"
        let url = URL(string: string)
        
        let task = URLSession.shared.dataTask(with: URLRequest.init(url: url!)) { (data, responce, error) in
            if error != nil {
                print(error ?? "")
            }
            else {
                let htmlContent = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                
                do{
                    let doc = try SwiftSoup.parse(htmlContent! as String)
                    
                    do {
                        let element1 = try doc.select("h3").array()
                        let element = try doc.select("tr").array()
                        do {
                            for i in 0..<element.count-1{
                                //  for j in he {
                                finish.append(try element[i+1].text())
                            }
                        }
                        
                        for i in 0..<element1.count-6 {
                            var string = try element1[i + 6].text()
                            if let range = string.range(of: "и т.д.") {
                                string.removeSubrange(range)
                            }
                            headers.append(string)
                        }
                        var value = 0
                        var array = [String]()
                        for item in finish {
                            if item == "Продукты (100 грамм) Вода Белки Жиры Уг-ды (у.е.) Калории" {
                                let header = headers[value]
                                dictionary[header] = array
                                value += 1
                                array.removeAll()
                                continue
                            }
                            array.append(item)
                            
                        }
                        UserDefaults.standard.setValue(dictionary, forKey: "Food")
                        //  reference.child("Food").setValue(dictionary])
                        // reference.child("default_program").key.setValue(dictionary) setValue(dictionary) //.child("Food").queryOrderedByKey().se
                        
                        print(finish)
                        print(headers)
                    }
                }catch {
                    
                }
                
            }
        }
        task.resume()
    }
    
 }


