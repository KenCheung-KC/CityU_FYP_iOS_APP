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
    var hikingRouteDetail: HikingRoute?
    
    @IBOutlet weak var hikingTourNameLabel: UILabel!
    @IBOutlet weak var hikingTourDateAndTimeLabel: UILabel!
    @IBOutlet weak var hikingTourHostNameLabel: UILabel!
    @IBOutlet weak var hikingTourMinimumParticipantLabel: UILabel!
    @IBOutlet weak var hikingTourMaximumParticipantLabel: UILabel!
    @IBOutlet weak var hikingRouteButton: UIButton!
    @IBOutlet weak var hikingTourDescriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hikingTourNameLabel.text = hikingTourDetail?.tourname
        hikingTourHostNameLabel.text = hikingTourDetail?.hostname
        hikingTourMinimumParticipantLabel.text = String(hikingTourDetail!.minimumparticipant)
        hikingTourMaximumParticipantLabel.text = String(hikingTourDetail!.maximumparticipant)
        hikingTourDescriptionLabel.text = hikingTourDetail?.tourdescription
        hikingRouteButton.setTitle(hikingTourDetail?.hikingroutename, for: .normal)
    }
    
    @IBAction func hikingRouteButtonOnTap(_ sender: Any) {
        let url = URL(string: "\(baseUrl)/hikingRoute/hikingRouteList/\(hikingTourDetail!.hikingrouteid)")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue(JWT_token!, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request){
            (data, response, error) in
            
            do {
                let responseFromServer = try JSONDecoder().decode(HikingRouteResponse.self, from: data!)
                self.hikingRouteDetail = responseFromServer.hikingRoute
                
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "GoToHikingRouteDetailFromHikingTour", sender: self)
                }
                
            } catch let err {
                print("err: \(err)")
            }
        }
        
        task.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToHikingRouteDetailFromHikingTour" {
            let destinationVC = segue.destination as! ScrollableHikingRouteDetailViewController
            destinationVC.hikingRouteDetail = hikingRouteDetail
        }
    }
}
