//
//  Meal.swift
//  FoodTracker
//
//  Created by Isaac Vasquez on 14/11/17.
//  Copyright © 2017 Apple Inc. All rights reserved.
//

import Foundation
import UIKit

class Meal {
    var name: String?
    var photo: UIImage?
    var raiting: Int
    init?(name: String, photo: UIImage, raiting: Int){
        self.name = name
        self.photo = photo
        self.raiting = raiting
//        contructor Validation
        if(name.isEmpty || raiting < 0){
//            nil = null
            return nil
        }
    }
}
