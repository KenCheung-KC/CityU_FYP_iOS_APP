//
//  LikedRoutesListViewController.swift
//  Cityu_FYP
//
//  Created by Kam on 27/3/2021.
//  Copyright © 2021 Kam. All rights reserved.
//

import UIKit

class LikedRoutesListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var likedRoutesDetails: [HikingRoute] = []
    var refreshControl: UIRefreshControl!
    
    @IBOutlet weak var likedRoutesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        likedRoutesTableView.delegate = self
        likedRoutesTableView.dataSource = self
        
        getLikedRoutes()
        
        refreshControl = UIRefreshControl()
        likedRoutesTableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControl.Event.valueChanged)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likedRoutesDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = likedRoutesTableView.dequeueReusableCell(withIdentifier: "LikedRouteCell") as! LikedRouteTableViewCell
        let likedRouteName = likedRoutesDetails[indexPath.row].name
        let likedRouteDifficulty = likedRoutesDetails[indexPath.row].stars
        
        if let likedRouteRating = likedRoutesDetails[indexPath.row].userrating {
            cell.cosmosView.rating = Double(likedRouteRating)
        } else {
            cell.cosmosView.rating = 0.0
        }
        
        cell.likedRouteNameLabel.text = likedRouteName

        for n in 0...4 {
            let likedRouteDifficultyImageCntainer = cell.difficultyImageViewContainer
            let difficultyImageView = likedRouteDifficultyImageCntainer?.subviews[n] as! UIImageView
            if (n < likedRouteDifficulty) {
                difficultyImageView.image = UIImage(named: "weakness_fill")
            } else {
                difficultyImageView.image = UIImage(named: "weakness_empty")
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "GoToHikingRouteDetailFromLikedRoutes", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToHikingRouteDetailFromLikedRoutes" {
            if let indexPath = self.likedRoutesTableView.indexPathForSelectedRow {
                let destinationVC = segue.destination as! HikingRouteDetailViewController
                destinationVC.hikingRouteDetail = likedRoutesDetails[indexPath.row]
            }
        }
    }
    
    func getLikedRoutes() {
        showSpinner(vc: self)
        likedRoutesDetails = []
        guard let url = URL(string: "\(baseUrl)/hikingRoute/likedHikingRoutes") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(JWT_token!, forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request){
            (data, response, err) in
            do {
                let responseFromServer = try JSONDecoder().decode(GetLikedHikingRoutesResponse.self, from: data!)
                let likedRoutesFromServer = responseFromServer.likedHikingRoutes
                
                for likedRoute in likedRoutesFromServer {
                    self.likedRoutesDetails.append(likedRoute)
                }

                DispatchQueue.main.sync {
                    self.likedRoutesTableView.reloadData()
                    self.removeSpinner(vc: self)
                }
            } catch let err {
                print("err from hikingTourListViewController: \(err)")
            }
        }
        task.resume()
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...

        getLikedRoutes()
        // Simply adding an object to the data source for this example
        print("table refreshed!")

        refreshControl.endRefreshing()
    }
}
