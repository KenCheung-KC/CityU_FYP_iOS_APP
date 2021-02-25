//
//  HikingTourDetailsViewController.swift
//  Cityu_FYP
//
//  Created by Kam on 23/2/2021.
//  Copyright © 2021 Kam. All rights reserved.
//

import UIKit

class HikingTourDetailsViewController: UIViewController {

    var hikingTourDetail: HikingTour?
    
    
    @IBOutlet weak var hikingTourNameLabel: UILabel!
    @IBOutlet weak var hikingTourDateAndTimeLabel: UILabel!
    @IBOutlet weak var hikingTourHostNameLabel: UILabel!
    @IBOutlet weak var hikingTourMinimumParticipantLabel: UILabel!
    @IBOutlet weak var hikingTourMaximumParticipantLabel: UILabel!
    @IBOutlet weak var hikingRouteButton: UIButton!
    @IBOutlet weak var hikingTourDescriptionLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("hikingTourDetail: \(hikingTourDetail)")
        
        hikingTourNameLabel.text = hikingTourDetail?.tourname
        hikingTourHostNameLabel.text = hikingTourDetail?.hostname
        hikingTourMinimumParticipantLabel.text = String(hikingTourDetail!.minimumparticipant)
        hikingTourMaximumParticipantLabel.text = String(hikingTourDetail!.maximumparticipant)
        hikingTourDescriptionLabel.text = hikingTourDetail?.tourdescription
        hikingRouteButton.setTitle(hikingTourDetail?.hikingroutename, for: .normal)
    }
    
    @IBAction func hikingRouteButtonOnTap(_ sender: Any) {
        print("Button clicked")
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
