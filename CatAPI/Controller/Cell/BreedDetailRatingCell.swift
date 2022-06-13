//
//  BreedDetailRatingCell.swift
//  CatAPI
//
//  Created by motor on 2022/6/10.
//

import UIKit
import Cosmos

class BreedDetailRatingCell: UITableViewCell {
    
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var ratingStars: CosmosView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
