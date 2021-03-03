//
//  MyInformationViewController.swift
//  Cityu_FYP
//
//  Created by Kam on 3/3/2021.
//  Copyright © 2021 Kam. All rights reserved.
//

import UIKit

class MyInformationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    let titles: [String] = ["Username:", "Email:", "Registered since:"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 43.5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyInformationCell", for: indexPath) as! MyInformationTableViewCell
        cell.titleLabel.text = titles[indexPath.row]
        if(row == 0) {
            cell.detailLabel.text = user?.username
        }
        if (row == 1) {
            cell.detailLabel.text = user?.email
        }
        if (row == 2) {
            if let dateAndTime = getDateAndTime(ISOString: user!.createdat) {
                let date = dateAndTime.date
                cell.detailLabel.text = "\(date)"
            }
        }
        
        return cell
    }
}
