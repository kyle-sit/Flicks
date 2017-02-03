//
//  MovieViewCell.swift
//  Flicks
//
//  Created by Kyle Sit on 2/2/17.
//  Copyright © 2017 Kyle Sit. All rights reserved.
//

import UIKit

class MovieViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var posterView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
