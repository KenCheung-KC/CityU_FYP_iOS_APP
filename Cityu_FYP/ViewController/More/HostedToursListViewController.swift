//
//  HostedToursListViewController.swift
//  Cityu_FYP
//
//  Created by Kam on 2/3/2021.
//  Copyright © 2021 Kam. All rights reserved.
//

import UIKit

class HostedToursListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var hostedTours: [HikingTour] = []
    
    @IBOutlet weak var hostedToursTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hostedToursTableView.dataSource = self
        hostedToursTableView.delegate = self
        getHostedTours()
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hostedTours.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = hostedToursTableView.dequeueReusableCell(withIdentifier: "HostedTourDetailCell", for: indexPath) as! HostedTourDetailCell
        let hostedTourName = hostedTours[indexPath.row].tourname
        let routeNameOfHostedTour = hostedTours[indexPath.row].hikingroutename
        let hostedTourDateAndTime = hostedTours[indexPath.row].dateandtime
        if let dateAndTime = DateFormatter.isoStringFormatter.date(from: hostedTourDateAndTime) {
            let date = DateFormatter.dateFormatter.string(from: dateAndTime)
            let time = DateFormatter.timeFormatter.string(from: dateAndTime)
            cell.hostedTourDateLabel.text = date
            cell.hostedTourTimeLabel.text = time
        }
        cell.hostedTourNameLabel.text = hostedTourName
        cell.hostedTourRouteNameLabel.text = routeNameOfHostedTour
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "GoToTourDetailFromHostedTours", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "GoToTourDetailFromHostedTours") {
            if let indexPath = self.hostedToursTableView.indexPathForSelectedRow {
                let destinationVC = segue.destination as! HikingTourDetailsViewController
                destinationVC.hikingTourDetail = hostedTours[indexPath.row]
            }
        }
    }
    
    func getHostedTours() {
        showSpinner(vc: self)
        
        guard let url = URL(string: "\(baseUrl)/hikingTour/getUserHostedTours/\(user!.id)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(JWT_token!, forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request){
            (data, response, err) in
            do {
                let responseFromServer = try JSONDecoder().decode(GetHostedToursResponse.self, from: data!)
                let hostedTours = responseFromServer.userHostedTours
                
                for hostedTour in hostedTours {
                    self.hostedTours.append(hostedTour)
                }
                
                DispatchQueue.main.sync {
                    self.hostedToursTableView.reloadData()
                    self.removeSpinner(vc: self)
                }
                
            } catch let err {
                print("err from hostedToursListViewController: \(err)")
            }
        }
        
        task.resume()
    }
}
