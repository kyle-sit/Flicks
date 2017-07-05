//
//  movieCollectionViewCell.swift
//  Flicks
//
//  Created by Kyle Sit on 2/4/17.
//  Copyright © 2017 Kyle Sit. All rights reserved.
//

import UIKit

class movieCollectionViewCell: UICollectionViewCell {
    
    //Only title and picture for each cell
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterView: UIImageView!
    
    //rounding edges of pics
    override func awakeFromNib() {
        posterView.layer.cornerRadius = 3
        posterView.clipsToBounds = true
    }
    
    
}
