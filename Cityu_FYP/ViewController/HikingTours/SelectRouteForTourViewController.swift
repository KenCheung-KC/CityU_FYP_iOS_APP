//
//  SelectRouteForTourViewController.swift
//  Cityu_FYP
//
//  Created by Kam on 6/3/2021.
//  Copyright © 2021 Kam. All rights reserved.
//

import UIKit

class SelectRouteForTourViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var hikingRoutes: [HikingRoute] = []
    var selectedRoute: HikingRoute?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getHikingRoutes()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hikingRoutes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectRouteForTourCell", for: indexPath) as! SelectRouteForTourTableViewCell
        let difficultyContainer = cell.subviews[0].subviews[1]
        let routeName = hikingRoutes[indexPath.row].name
        let stars = hikingRoutes[indexPath.row].stars
        
        cell.hikingRouteNameLabel.text = routeName
        for i in 0...4 {
            let imageView = difficultyContainer.subviews[i] as! UIImageView
            if (i < stars) {
                imageView.image = UIImage(named: "weakness_fill")
            } else {
                imageView.image = UIImage(named: "weakness_empty")
            }
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRoute = hikingRoutes[indexPath.row]
        performSegue(withIdentifier: "PassHikingRouteIdToCreateTourVC", sender: self)
    }
    
    func getHikingRoutes() {
        showSpinner(vc: self)
        
        guard let url = URL(string: "\(baseUrl)/hikingRoute/hikingRouteList") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(JWT_token!, forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request){
            (data, response, err) in
            do {
                let responseFromServer = try JSONDecoder().decode(HikingRoutesResponse.self, from: data!)
                let hikingRoutesFromServer = responseFromServer.hikingRoutes
                
                for hikingRoute in hikingRoutesFromServer {
                    self.hikingRoutes.append(hikingRoute)
                }
                
                DispatchQueue.main.sync {
                    self.tableView.reloadData()
                    self.removeSpinner(vc: self)
                }
            } catch let err {
                print("err from SelectRouteForTourViewController: \(err)")
            }
        }
        task.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let createTourVC = segue.destination as! CreateTourViewController
        createTourVC.selectedHikingRoute = selectedRoute
    }
    
    
}
