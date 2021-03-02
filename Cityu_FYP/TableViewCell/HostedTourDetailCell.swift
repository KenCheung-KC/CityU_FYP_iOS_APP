//
//  HostedTourDetailCell.swift
//  Cityu_FYP
//
//  Created by Kam on 2/3/2021.
//  Copyright © 2021 Kam. All rights reserved.
//

import UIKit

class HostedTourDetailCell: UITableViewCell {

    @IBOutlet weak var hostedTourNameLabel: UILabel!
    @IBOutlet weak var hostedTourRouteNameLabel: UILabel!
    @IBOutlet weak var hostedTourDateLabel: UILabel!
    @IBOutlet weak var hostedTourTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
