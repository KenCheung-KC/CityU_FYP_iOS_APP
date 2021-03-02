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
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let joinedToursCell = tableView.dequeueReusableCell(withIdentifier: "JoinedToursCell", for: indexPath)
        let hostedToursCell = tableView.dequeueReusableCell(withIdentifier: "HostedToursCell", for: indexPath)
//        print("indexPath: \(indexPath)")
        if(indexPath.row == 0) {
            return joinedToursCell
        }
        
        return hostedToursCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row == 0) {
            performSegue(withIdentifier: "GoToJoinedToursList", sender: self)
        }
        
        if(indexPath.row == 1) {
            
        }
    }
}
