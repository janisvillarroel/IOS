//
//  DogTableViewCell.swift
//  DoguiApp
//
//  Created by Janis on 12/11/17.
//  Copyright © 2017 Janis Villarroel. All rights reserved.
//

import UIKit


class DogTableViewCell: UITableViewCell {

    @IBOutlet weak var dogBreed: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
