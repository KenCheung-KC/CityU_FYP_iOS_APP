//
//  MoreViewController.swift
//  Cityu_FYP
//
//  Created by Kam on 2/3/2021.
//  Copyright © 2021 Kam. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0) {
            return 3
        } else {
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let joinedToursCell = tableView.dequeueReusableCell(withIdentifier: "JoinedToursCell", for: indexPath)
        let hostedToursCell = tableView.dequeueReusableCell(withIdentifier: "HostedToursCell", for: indexPath)
        let likedRoutesCell = tableView.dequeueReusableCell(withIdentifier: "LikedRoutesCell", for: indexPath)
        let myInformationCell = tableView.dequeueReusableCell(withIdentifier: "MyInformationCell", for: indexPath)
        let logoutCell = tableView.dequeueReusableCell(withIdentifier: "LogOutCell", for: indexPath)
        
        if(indexPath.section == 0) {
            if(indexPath.row == 0) {
                return joinedToursCell
            }
            if(indexPath.row == 1) {
                return hostedToursCell
            }
            return likedRoutesCell
        } else if (indexPath.section == 1) {
            return myInformationCell
        } else {
            return logoutCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 0) {
            if(indexPath.row == 0) {
                performSegue(withIdentifier: "GoToJoinedToursList", sender: self)
            }
        
            if(indexPath.row == 1) {
                performSegue(withIdentifier: "GoToHostedTours", sender: self)
            }
            
            if(indexPath.row == 2) {
                performSegue(withIdentifier: "GoToLikedRoutes", sender: self)
            }
        } else if (indexPath.section == 1 && indexPath.row == 0){
            performSegue(withIdentifier: "GoToMyInformation", sender: self)
        } else {
            let alertController = UIAlertController(title: "Hint", message: "Are you sure to logout?", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Yes", style: .default) { (_) in
                user = nil
                JWT_token = nil
                let navigationController = self.navigationController
                let rootNavigationController = navigationController?.navigationController
                rootNavigationController?.popToRootViewController(animated: true)
            }
            alertController.addAction(okAction)
            let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0) {
            return "Tours & routes"
        }
        if (section == 1) {
            return "User Infomation"
        }
        
        return ""
    }
    
}
