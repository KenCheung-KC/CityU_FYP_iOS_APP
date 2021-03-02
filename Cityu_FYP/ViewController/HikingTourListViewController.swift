//
//  HikingTourListViewController.swift
//  Cityu_FYP
//
//  Created by Kam on 17/2/2021.
//  Copyright © 2021 Kam. All rights reserved.
//

import UIKit

class HikingTourListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var hikingTourTableView: UITableView!
    var hikingTours: [HikingTour] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hikingTours.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = hikingTourTableView.dequeueReusableCell(withIdentifier: "hikingTourItemCell", for: indexPath) as! HikingTourItemCell
        cell.hikingTourNameLabel.text = hikingTours[indexPath.row].tourname
        cell.hikingRouteNameLabel.text = hikingTours[indexPath.row].hikingroutename
        cell.hikingTourDescriptionLabel.text = hikingTours[indexPath.row].tourdescription
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "GoToHikingTourDetail", sender: self)
    }
    
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToHikingTourDetail" {
            if let indexPath = self.hikingTourTableView.indexPathForSelectedRow {
                let destinationVC = segue.destination as! HikingTourDetailsViewController
                destinationVC.hikingTourDetail = hikingTours[indexPath.row]
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hikingTourTableView.delegate = self
        hikingTourTableView.dataSource = self
        getHikingTours()
    }
    
    func getHikingTours() {
        showSpinner(vc: self)
        
        guard let url = URL(string: "\(baseUrl)/hikingTour/hikingToursList") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(JWT_token!, forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request){
                    (data, response, err) in
                    do {
                        let responseFromServer = try JSONDecoder().decode(HikingToursResponse.self, from: data!)
                        let hikingToursFromServer = responseFromServer.hikingTours
                        
                        for hikingTour in hikingToursFromServer {
                            self.hikingTours.append(hikingTour)
                        }
                        
                        DispatchQueue.main.sync {
                            self.hikingTourTableView.reloadData()
                            self.removeSpinner(vc: self)
                        }
                    } catch let err {
                        print("err from hikingTourListViewController: \(err)")
                    }
                }
                task.resume()
    }
    
}
