//
//  MyInformationTableViewCell.swift
//  Cityu_FYP
//
//  Created by Kam on 3/3/2021.
//  Copyright © 2021 Kam. All rights reserved.
//

import UIKit

class MyInformationTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
