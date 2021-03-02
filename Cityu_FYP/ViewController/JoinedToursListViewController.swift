//
//  JoinedToursListViewController.swift
//  Cityu_FYP
//
//  Created by Kam on 2/3/2021.
//  Copyright © 2021 Kam. All rights reserved.
//

import UIKit

class JoinedToursListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var joinedTours: [HikingTour] = []
    
    @IBOutlet weak var joinedToursTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        joinedToursTableView.dataSource = self
        joinedToursTableView.delegate = self
        getJoinedTours()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return joinedTours.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JoinedTourDetailCell", for: indexPath) as! JoinedTourDetailCell
        
        let joinedTourName = joinedTours[indexPath.row].tourname
        let routeOfTour = joinedTours[indexPath.row].hikingroutename
        let date = getDateAndTime(ISOString: joinedTours[indexPath.row].dateandtime)?.date
        let time = getDateAndTime(ISOString: joinedTours[indexPath.row].dateandtime)?.time
        
        cell.hikingTourNameLabel.text = joinedTourName
        cell.hikingRouteOfTourLabel.text = routeOfTour
        cell.hikingToueDateLabel.text = date
        cell.hikingTourTimeLabel.text = time
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "GoToTourDetailFromJoinedTours", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToTourDetailFromJoinedTours" {
            if let indexPath = self.joinedToursTableView.indexPathForSelectedRow {
                let destinationVC = segue.destination as! HikingTourDetailsViewController
                destinationVC.hikingTourDetail = joinedTours[indexPath.row]
            }
        }
    }
    
    func getJoinedTours() {
        showSpinner(vc: self)
        
        guard let url = URL(string: "\(baseUrl)/hikingTour/getUserJoinedTours/\(user!.id)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(JWT_token!, forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request){
            (data, response, err) in
            do {
                let responseFromServer = try JSONDecoder().decode(GetJoinedToursResponse.self, from: data!)
                let joinedTours = responseFromServer.userJoinedTours
                
                for joinedTour in joinedTours {
                    self.joinedTours.append(joinedTour)
                }
                
                DispatchQueue.main.sync {
                    self.joinedToursTableView.reloadData()
                    self.removeSpinner(vc: self)
                }
                
            } catch let err {
                print("err: \(err)")
            }
        }
        
        task.resume()
    }
    
}
