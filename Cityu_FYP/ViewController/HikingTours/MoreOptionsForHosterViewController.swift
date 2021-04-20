//
//  MoreOptionsForHosterViewController.swift
//  Cityu_FYP
//
//  Created by Kam on 19/4/2021.
//  Copyright © 2021 Kam. All rights reserved.
//

import UIKit

class MoreOptionsForHosterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var optionsTableView: UITableView!
    
    var options = ["Edit tour", "Tour participants"]
    var hikingTour: HikingTour?
    var editingTour: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        optionsTableView.delegate = self
        optionsTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = optionsTableView.dequeueReusableCell(withIdentifier: "OptionCellForTourHoster") as! OptionCellForTourHosterTableViewCell
        cell.titleLabel.text = options[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 43.5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row == 0) {
            performSegue(withIdentifier: "GoToEditTourForHoster", sender: self)
        } else {
            performSegue(withIdentifier: "ShowTourParticipantsForHoster", sender: self)
        }
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "GoToEditTourForHoster") {
            let destinationVC = segue.destination as! CreateTourViewController
            destinationVC.editingTour = editingTour!
            destinationVC.existingHikingTour = hikingTour!
        }
        
        if(segue.identifier == "ShowTourParticipantsForHoster") {
            let destinationVC = segue.destination as! TourParticipantsViewController
            destinationVC.hikingTour = hikingTour!
        }
    }
}

