//
//  LikedRouteTableViewCell.swift
//  Cityu_FYP
//
//  Created by Kam on 27/3/2021.
//  Copyright © 2021 Kam. All rights reserved.
//

import UIKit
import Cosmos

class LikedRouteTableViewCell: UITableViewCell {

    @IBOutlet weak var likedRouteNameLabel: UILabel!
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var difficultyImageViewContainer: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        cosmosView.settings.updateOnTouch = false
        // Configure the view for the selected state
    }

}
