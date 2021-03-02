//
//  JoinedTourDetailCell.swift
//  Cityu_FYP
//
//  Created by Kam on 2/3/2021.
//  Copyright © 2021 Kam. All rights reserved.
//

import UIKit

class JoinedTourDetailCell: UITableViewCell {

    @IBOutlet weak var hikingTourNameLabel: UILabel!
    @IBOutlet weak var hikingRouteOfTourLabel: UILabel!
    @IBOutlet weak var hikingToueDateLabel: UILabel!
    @IBOutlet weak var hikingTourTimeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
