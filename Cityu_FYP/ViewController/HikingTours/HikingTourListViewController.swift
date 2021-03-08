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
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hikingTourTableView.delegate = self
        hikingTourTableView.dataSource = self
        
        refreshControl = UIRefreshControl()
        hikingTourTableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControl.Event.valueChanged)
        
        getHikingTours()
    }
    
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
        let imageUrl = hikingTours[indexPath.row].hikingrouteimage
        let url = URL(string: imageUrl)
        URLSession.shared.dataTask(with: url!){
            (data, response, err) in
            guard let data = data else { return }
            DispatchQueue.main.async {
                cell.hikingTourImageView.image = UIImage(data: data)
            }
        }.resume()
        
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
    
    func getHikingTours() {
        showSpinner(vc: self)
        hikingTours = []
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
 
    @IBAction func unwindToHikingToursListVC(_ sender: UIStoryboardSegue) {
        getHikingTours()
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...

        getHikingTours()
        // Simply adding an object to the data source for this example
        print("table refreshed!")

        refreshControl.endRefreshing()
    }
}
