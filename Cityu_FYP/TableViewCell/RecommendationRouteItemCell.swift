//
//  RecommendationRouteItemCell.swift
//  Cityu_FYP
//
//  Created by Kam on 3/4/2021.
//  Copyright © 2021 Kam. All rights reserved.
//

import UIKit

class RecommendationRouteItemCell: UITableViewCell {

    @IBOutlet weak var recommendationRouteImage: UIImageView!
    @IBOutlet weak var recommendationRouteNameLabel: UILabel!
    @IBOutlet weak var recommendationRouteDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
