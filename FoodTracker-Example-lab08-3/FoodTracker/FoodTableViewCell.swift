//
//  FoodTableViewCell.swift
//  FoodTracker
//
//  Created by jbian on 11/14/17.
//  Copyright © 2017 Apple Inc. All rights reserved.
//

import UIKit

class FoodTableViewCell: UITableViewCell {

    @IBOutlet weak var photoMeal: UIImageView!
    
    @IBOutlet weak var raiting: RatingControl!
    
    @IBOutlet weak var mealLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
