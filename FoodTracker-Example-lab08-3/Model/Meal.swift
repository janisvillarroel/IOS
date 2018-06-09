//
//  Meal.swift
//  FoodTracker
//
//  Created by jbian on 11/14/17.
//  Copyright © 2017 Apple Inc. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class Meal {
    var id:String?
    var name:String
    var photo:UIImage?
    var raiting:Int
    init?(id:String, name:String, photo:UIImage?, raiting:Int){
        self.id = id
        self.name = name
        self.photo = photo
        self.raiting = raiting
        // contructor Validatio
        if(name.isEmpty || raiting < 0){
            // nil = null
            return nil
        }
    }
}
