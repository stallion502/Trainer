//
//  UserAttributes.swift
//  TrainerCoach
//
//  Created by User on 30/07/2017.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation

struct UserAttributes {
    
    let attribute0_34 = NSDictionary(objects: [33.3, 92.5, 69.3, 50], forKeys: [0.34 as NSCopying])//
    let attribute0_36 = NSDictionary(objects: [34.5, 96.3, 72.1, 51.8], forKeys: [0.36 as NSCopying])
    let attribute0_39 = NSDictionary(objects: [35.8, 99.8, 74.7, 53.8], forKeys: [0.39 as NSCopying])
    let attribute0_42 = NSDictionary(objects: [37.1, 103.4, 76.2, 55.9], forKeys: [0.42 as NSCopying])
    let attribute0_44 = NSDictionary(objects: [38.4, 106.9, 80.3, 57.7], forKeys: [0.44 as NSCopying])
    let attribute0_47 = NSDictionary(objects: [39.9, 110.5, 82.8, 57.7], forKeys: [0.47 as NSCopying])
    let attribute0_50 = NSDictionary(objects: [41.1, 114.3, 85.6, 61.7], forKeys: [0.50 as NSCopying])
    
    static let attributeDictionary = NSDictionary(objects:
        [[33.3, 92.5, 69.3, 50],
         [34.5, 96.3, 72.1, 51.8],
         [35.8, 99.8, 74.7, 53.8],
         [37.1, 103.4, 76.2, 55.9],
         [38.4, 106.9, 80.3, 57.7],
         [39.9, 110.5, 82.8, 57.7],
         [41.1, 114.3, 85.6, 61.7]], forKeys:[0.34 as NSCopying,
                                              0.36 as NSCopying,
                                              0.39 as NSCopying,
                                              0.42 as NSCopying,
                                              0.44 as NSCopying,
                                              0.47 as NSCopying,
                                              0.50 as NSCopying])
    
    static let keys = [0.34, 0.36, 0.39, 0.42, 0.44, 0.47, 0.50]
    
}
