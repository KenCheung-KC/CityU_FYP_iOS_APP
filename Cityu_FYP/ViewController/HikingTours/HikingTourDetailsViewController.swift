//
//  HikingTourDetailsViewController.swift
//  Cityu_FYP
//
//  Created by Kam on 23/2/2021.
//  Copyright © 2021 Kam. All rights reserved.
//

import UIKit

class HikingTourDetailsViewController: UIViewController {

    var hikingTourDetail: HikingTour?
    var hikingRouteDetail: HikingRoute?
    
    @IBOutlet weak var hikingTourNameLabel: UILabel!
    @IBOutlet weak var hikingTourDateLabel: UILabel!
    @IBOutlet weak var hikingTourTimeLabel: UILabel!
    @IBOutlet weak var hikingTourHostNameLabel: UILabel!
    @IBOutlet weak var hikingTourPriceLabel: UILabel!
    @IBOutlet weak var hikingTourMinimumParticipantLabel: UILabel!
    @IBOutlet weak var hikingTourMaximumParticipantLabel: UILabel!
    @IBOutlet weak var hikingRouteButton: UIButton!
    @IBOutlet weak var hikingTourDescriptionLabel: UILabel!
    @IBOutlet weak var navigationBarEditButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(hikingTourDetail?.hostid != user?.id) {
            self.navigationItem.rightBarButtonItem = nil
        } else {
            self.navigationItem.rightBarButtonItem = navigationBarEditButton
        }
        let tourDateAndTime = hikingTourDetail!.dateandtime
        guard let dateAndTime = DateFormatter.isoStringFormatter.date(from: tourDateAndTime) else { return }
        let date = DateFormatter.dateFormatter.string(from: dateAndTime)
        let time = DateFormatter.timeFormatter.string(from: dateAndTime)
        hikingTourNameLabel.text = hikingTourDetail?.tourname
        hikingTourDateLabel.text = date
        hikingTourTimeLabel.text = time
        hikingTourHostNameLabel.text = hikingTourDetail?.hostname
        hikingTourPriceLabel.text = "$\(hikingTourDetail!.price)"
        hikingTourMinimumParticipantLabel.text = String(hikingTourDetail!.minimumparticipant)
        hikingTourMaximumParticipantLabel.text = String(hikingTourDetail!.maximumparticipant)
        hikingTourDescriptionLabel.text = hikingTourDetail?.tourdescription
        hikingRouteButton.setTitle(hikingTourDetail?.hikingroutename, for: .normal)
    }
    
    @IBAction func hikingRouteButtonOnTap(_ sender: Any) {
        let url = URL(string: "\(baseUrl)/hikingRoute/hikingRouteList/\(hikingTourDetail!.hikingrouteid)")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue(JWT_token!, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request){
            (data, response, error) in
            
            do {
                let responseFromServer = try JSONDecoder().decode(HikingRouteResponse.self, from: data!)
                self.hikingRouteDetail = responseFromServer.hikingRoute
                
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "GoToHikingRouteDetailFromHikingTour", sender: self)
                }
                
            } catch let err {
                print("err: \(err)")
            }
        }
        
        task.resume()
    }
    
    func joinTour() {
        showSpinner(vc: self)
        
        guard let url = URL(string: "\(baseUrl)/hikingTour/joinHikingTour/\(hikingTourDetail!.id)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(JWT_token!, forHTTPHeaderField: "Authorization")
        let requestBody = "userId=\(user!.id)".data(using: .utf8)
        request.httpBody = requestBody
        
        let task = URLSession.shared.dataTask(with: request){
            (data, response, error) in
            
            do {
                let responseFromServer = try JSONDecoder().decode(JoinedToursResponse.self, from: data!)
                let messageFromServer = responseFromServer.message
                DispatchQueue.main.async {
                    let controller = UIAlertController(title: "Message From Server", message: messageFromServer, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    controller.addAction(okAction)
                    self.removeSpinner(vc: self)
                    self.present(controller, animated: true, completion: nil)
                }
            } catch let err {
                print("err from hiking tour detail VC: \(err)")
            }
        }
        
        task.resume()
    }
    
    @IBAction func joinButtonOnTap(_ sender: Any) {
        if(self.hikingTourDetail!.price > 0) {
            let controller = UIAlertController(title: "Message", message: "This tour charges $\(self.hikingTourDetail!.price), are you sure you need to join this tour?", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Pay", style: .default, handler: {
                (action) in
                self.joinTour()
            })
            controller.addAction(okAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            controller.addAction(cancelAction)
            self.removeSpinner(vc: self)
            self.present(controller, animated: true, completion: nil)
        } else {
            joinTour()
        }
        
//            showSpinner(vc: self)
//
//            guard let url = URL(string: "\(baseUrl)/hikingTour/joinHikingTour/\(hikingTourDetail!.id)") else { return }
//            var request = URLRequest(url: url)
//            request.httpMethod = "POST"
//            request.setValue(JWT_token!, forHTTPHeaderField: "Authorization")
//            let requestBody = "userId=\(user!.id)".data(using: .utf8)
//            request.httpBody = requestBody
//
//            let task = URLSession.shared.dataTask(with: request){
//                (data, response, error) in
//
//                do {
//                    let responseFromServer = try JSONDecoder().decode(JoinedToursResponse.self, from: data!)
//                    let messageFromServer = responseFromServer.message
//                    DispatchQueue.main.async {
//                        let controller = UIAlertController(title: "Message From Server", message: messageFromServer, preferredStyle: .alert)
//                        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//                        controller.addAction(okAction)
//                        self.removeSpinner(vc: self)
//                        self.present(controller, animated: true, completion: nil)
//                    }
//                } catch let err {
//                    print("err from hiking tour detail VC: \(err)")
//                }
//            }
//
//            task.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToHikingRouteDetailFromHikingTour" {
            let destinationVC = segue.destination as! HikingRouteDetailViewController
            destinationVC.hikingRouteDetail = hikingRouteDetail
        }
        
        if segue.identifier == "GoToCreateTourVCToEditTour" {
            let destinationVC = segue.destination as! CreateTourViewController
            destinationVC.editingTour = true
            destinationVC.existingHikingTour = hikingTourDetail
        }
    }
    
    @IBAction func navigationBarEditButtonOnTap(_ sender: Any) {
        performSegue(withIdentifier: "GoToCreateTourVCToEditTour", sender: self)
    }
    
}
