//
//  RecommendationRoutesListViewController.swift
//  Cityu_FYP
//
//  Created by Kam on 3/4/2021.
//  Copyright © 2021 Kam. All rights reserved.
//

import UIKit

class RecommendationRoutesListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var recommendationRouteTableView: UITableView!
    var recommendedRoutes: [HikingRoute] = []
    var refreshControl: UIRefreshControl!
    
    override func viewWillAppear(_ animated: Bool) {
        getRecommendationRoutes()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recommendationRouteTableView.delegate = self
        recommendationRouteTableView.dataSource = self
        refreshControl = UIRefreshControl()
        recommendationRouteTableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControl.Event.valueChanged)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recommendedRoutes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = recommendationRouteTableView.dequeueReusableCell(withIdentifier: "RecommendationListItemCell") as! RecommendationRouteItemCell
        let recommendedRouteName = recommendedRoutes[indexPath.row].name
        let recommendedRouteDescription = recommendedRoutes[indexPath.row].description
        let imageUrl = recommendedRoutes[indexPath.row].hikingrouteimage
        let recommendedByContentBased = recommendedRoutes[indexPath.row].recommendedbycontentbased
        let recommendedByCollaborativeFiltering = recommendedRoutes[indexPath.row].recommendedbycollaborativefiltering
        let recommendedForColdStart = recommendedRoutes[indexPath.row].recommendedforcoldstart
        
        // some default configuration of UI components
        cell.recommendedByCBLabel.isHidden = true
        cell.recommendedByCFLabel.isHidden = true
        cell.recommendedForColdStartLabel.isHidden = true
        cell.recommendedByCFLabel.frame.origin.x = 30
        
        if let cb = recommendedByContentBased {
            if(cb == true){
                cell.recommendedByCBLabel.isHidden = false
            }
        }

        if let cf = recommendedByCollaborativeFiltering {
            if(cf == true){
                cell.recommendedByCFLabel.isHidden = false
                if(cell.recommendedByCBLabel.isHidden) {
                    cell.recommendedByCFLabel.frame.origin.x = 0
                }
            }
        }
        
        if let cs = recommendedForColdStart {
            if (cs == true) {
                cell.recommendedForColdStartLabel.frame.origin.x = 0
                cell.recommendedForColdStartLabel.isHidden = false
            }
        }
        
        cell.recommendationRouteNameLabel.text = recommendedRouteName
        cell.recommendationRouteDescriptionLabel.text = recommendedRouteDescription
        let url = URL(string: imageUrl!)
        URLSession.shared.dataTask(with: url!){
            (data, response, err) in
            guard let data = data else { return }
            DispatchQueue.main.async {
                cell.recommendationRouteImage.image = UIImage(data: data)
            }
        }.resume()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(recommendedRoutes[indexPath.row])
        performSegue(withIdentifier: "GoToHikingRouteDetailFromRecommendationList", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToHikingRouteDetailFromRecommendationList" {
            if let indexPath = self.recommendationRouteTableView.indexPathForSelectedRow {
                let destinationVC = segue.destination as! HikingRouteDetailViewController
                destinationVC.hikingRouteDetail = recommendedRoutes[indexPath.row]
            }
        }
    }
    
    func getRecommendationRoutes() {
        showSpinner(vc: self)
        self.recommendedRoutes = []
        guard let url = URL(string: "\(baseUrl)/recommendation/recommendationRoutes") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(JWT_token!, forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request){
            (data, response, err) in
            do {
                let responseFromServer = try JSONDecoder().decode(RecommendedRoutesResponse.self, from: data!)
                let recommendedRoutesFromServer = responseFromServer.recommendedRoutes
                
                for hikingRoute in recommendedRoutesFromServer {
                    self.recommendedRoutes.append(hikingRoute)
                }
                
                DispatchQueue.main.sync {
                    self.recommendationRouteTableView.reloadData()
                    self.removeSpinner(vc: self)
                }
            } catch let err {
                print("err from recommendationRouteListViewController: \(err)")
            }
        }
        task.resume()
    }
 
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...
        
        getRecommendationRoutes()
        // Simply adding an object to the data source for this example
        print("table refreshed!")
        
        refreshControl.endRefreshing()
    }
}
