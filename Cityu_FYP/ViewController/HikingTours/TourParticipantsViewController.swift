//
//  TourParticipantsViewController.swift
//  Cityu_FYP
//
//  Created by Kam on 17/4/2021.
//  Copyright © 2021 Kam. All rights reserved.
//

import UIKit

class TourParticipantsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tourParticipantsTableView: UITableView!
    
    var tourParticipantsUserNames: [String] = []
    var hikingTour: HikingTour?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tourParticipantsTableView.dataSource = self
        tourParticipantsTableView.delegate = self
        
        getTourParticipants()
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tourParticipantsTableView.dequeueReusableCell(withIdentifier: "TourParticipantCell") as! TourParticipantsTableViewCell
        cell.userNameLabel.text = tourParticipantsUserNames[indexPath.row]

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 43.5
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tourParticipantsUserNames.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Current participants: \(tourParticipantsUserNames.count)"
    }
    
    func getTourParticipants() {
        self.showSpinner(vc: self)
        guard let tourId = hikingTour?.id else { return }
        guard let url = URL(string: "\(baseUrl)/hikingTour/participants/\(tourId)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(JWT_token!, forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request){
            (data, response, err) in
            do {
                let responseFromServer = try JSONDecoder().decode(TourParticipantsResponse.self, from: data!)
                let tourParticipantsFromServer = responseFromServer.participants

                for participant in tourParticipantsFromServer {
                    let username = participant.username
                    self.tourParticipantsUserNames.append(username)
                }
                
                DispatchQueue.main.sync {
                    self.tourParticipantsTableView.reloadData()
                    self.removeSpinner(vc: self)
                }
            } catch let err {
                print("err from TourParticipantsViewController: \(err)")
            }
        }
        task.resume()
    }

}
