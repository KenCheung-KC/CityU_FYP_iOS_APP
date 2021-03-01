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
    @IBOutlet weak var hikingTourDateLabel: UILabel!
    @IBOutlet weak var hikingTourTimeLabel: UILabel!
    @IBOutlet weak var hikingTourHostNameLabel: UILabel!
    @IBOutlet weak var hikingTourMinimumParticipantLabel: UILabel!
    @IBOutlet weak var hikingTourMaximumParticipantLabel: UILabel!
    @IBOutlet weak var hikingRouteButton: UIButton!
    @IBOutlet weak var hikingTourDescriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("hiking tour detail: \(hikingTourDetail)")
        hikingTourNameLabel.text = hikingTourDetail?.tourname
        hikingTourDateLabel.text = getDateAndTime(ISOString: hikingTourDetail!.dateandtime)?.date
        hikingTourTimeLabel.text = getDateAndTime(ISOString: hikingTourDetail!.dateandtime)?.time
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
    
    @IBAction func joinButtonOnTap(_ sender: Any) {
        print("join")
        
        guard let url = URL(string: "\(baseUrl)/hikingTour/joinHikingTour/\(hikingTourDetail!.id)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(JWT_token!, forHTTPHeaderField: "Authorization")
        let requestBody = "userId=\(user!.id)".data(using: .utf8)
        request.httpBody = requestBody
        
        let task = URLSession.shared.dataTask(with: request){
            (data, response, error) in
            
            do {
                let responseFromServer = try JSONDecoder().decode(JoinTourResponse.self, from: data!)
//                print("join tour response: \(responseFromServer)")
                let messageFromServer = responseFromServer.message
                DispatchQueue.main.async {
                    let controller = UIAlertController(title: "Message From Server", message: messageFromServer, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    controller.addAction(okAction)
                    self.present(controller, animated: true, completion: nil)
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
    
    func getDateAndTime(ISOString: String) -> DateAndTime? {
        print("ISOString: \(ISOString)")
        let splitedISOString = ISOString.components(separatedBy: "T")
        print(splitedISOString)
        print(splitedISOString[1].dropLast(5))
        let date1 = splitedISOString[0]
        let time1 = String(splitedISOString[1].dropLast(5))
        
        let dateAndTime = DateAndTime(date: date1, time: (time1))
        print("dateAndTime: \(dateAndTime)")

        return dateAndTime
    }
}

struct DateAndTime {
    var date: String
    var time: String
    
    init(date: String, time: String) {
        self.date = date
        self.time = time
    }
}
