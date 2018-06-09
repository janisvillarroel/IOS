//
//  Dog.swift
//  DoguiApp
//
//  Created by Janis on 12/11/17.
//  Copyright © 2017 Janis Villarroel. All rights reserved.
//

import UIKit

class Dog {
    var breed:String
    init?(breed:String){
        self.breed = breed
        if(breed.isEmpty){
            return nil
        }
    }
}
