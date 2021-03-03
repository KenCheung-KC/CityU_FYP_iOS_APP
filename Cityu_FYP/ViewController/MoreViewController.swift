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
            return 2
        } else {
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let joinedToursCell = tableView.dequeueReusableCell(withIdentifier: "JoinedToursCell", for: indexPath)
        let hostedToursCell = tableView.dequeueReusableCell(withIdentifier: "HostedToursCell", for: indexPath)
        let myInformationCell = tableView.dequeueReusableCell(withIdentifier: "MyInformationCell", for: indexPath)
        
        if(indexPath.section == 0) {
            if(indexPath.row == 0) {
                return joinedToursCell
            }
            return hostedToursCell
        } else {
            return myInformationCell
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
        } else {
            performSegue(withIdentifier: "GoToMyInformation", sender: self)
            print("My information")
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0) {
            return "Tours"
        } else {
            return "User Infomation"
        }
    }
    
}
