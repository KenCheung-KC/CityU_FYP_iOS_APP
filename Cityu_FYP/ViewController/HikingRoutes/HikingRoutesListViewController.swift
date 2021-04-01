//
//  HikingRoutesListViewController.swift
//  Cityu_FYP
//
//  Created by Kam on 10/2/2021.
//  Copyright © 2021 Kam. All rights reserved.
//

import UIKit

class HikingRoutesListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var hikingRoutes: [HikingRoute] = []
    var refreshControl: UIRefreshControl!
    
    @IBOutlet weak var hikingRouteTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getHikingRoutes()
        hikingRouteTableView.delegate = self
        hikingRouteTableView.dataSource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        hikingRouteTableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControl.Event.valueChanged)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 340
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hikingRoutes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hikingRouteItemCell", for: indexPath) as! HikingRouteItemCell
        
        cell.hikingRouteNameLabel.text = hikingRoutes[indexPath.row].name
        cell.hikingRouteDescription.text = hikingRoutes[indexPath.row].description
        
        let rating = hikingRoutes[indexPath.row].stars
        for n in 0...4 {
            let starsContainer = cell.ratingStarContainerView
            let starImageView = starsContainer?.subviews[n] as! UIImageView
            if (n < rating) {
                starImageView.image = UIImage(named: "weakness_fill")
            } else {
                starImageView.image = UIImage(named: "weakness_empty")
            }
        }
        
        let imageUrl = hikingRoutes[indexPath.row].hikingrouteimage
        let url = URL(string: imageUrl!)
        URLSession.shared.dataTask(with: url!){
            (data, response, err) in
            guard let data = data else { return }
            DispatchQueue.main.async {
                cell.hikingRouteImage.image = UIImage(data: data)
            }
        }.resume()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "GoToHikingRouteDetailPage", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToHikingRouteDetailPage" {
            if let indexPath = self.hikingRouteTableView.indexPathForSelectedRow {
                let destinationVC = segue.destination as! HikingRouteDetailViewController
                destinationVC.hikingRouteDetail = hikingRoutes[indexPath.row]
            }
        }
    }
    
    func getHikingRoutes() {
        showSpinner(vc: self)
        self.hikingRoutes = []
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
                    self.hikingRouteTableView.reloadData()
                    self.removeSpinner(vc: self)
                }
            } catch let err {
                print("err from hikingRouteListViewController: \(err)")
            }
        }
        task.resume()
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...
        
        getHikingRoutes()
        // Simply adding an object to the data source for this example
        print("table refreshed!")
        
        refreshControl.endRefreshing()
    }
    
}

/*
 Notes
 Can get the hikingRoutes data from server now
 
 TODO:
 1. Display custom tableview cell - finished
 2. Feed data to tableview cell to display the information - finished
 3. Handle jwt token, append the token to authorization header automatically? - to be finish
 4. Pass data to hiking route detail page and display it
 5. Mapview of hiking route detail page
 
 */
