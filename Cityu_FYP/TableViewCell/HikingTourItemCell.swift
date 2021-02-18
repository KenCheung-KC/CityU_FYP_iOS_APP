//
//  HikingTourItemCell.swift
//  Cityu_FYP
//
//  Created by Kam on 17/2/2021.
//  Copyright © 2021 Kam. All rights reserved.
//

import UIKit

class HikingTourItemCell: UITableViewCell {

    @IBOutlet weak var hikingTourImageView: UIImageView!
    @IBOutlet weak var hikingTourNameLabel: UILabel!
    @IBOutlet weak var hikingRouteNameLabel: UILabel!
    @IBOutlet weak var hikingTourDescriptionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    
}
