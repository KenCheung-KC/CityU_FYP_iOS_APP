//
//  CreateTourViewController.swift
//  Cityu_FYP
//
//  Created by Kam on 6/3/2021.
//  Copyright © 2021 Kam. All rights reserved.
//

import UIKit

class CreateTourViewController: UIViewController {

    var selectedHikingRoute: HikingRoute?
    
    @IBOutlet weak var tourNameTextField: UITextField!
    @IBOutlet weak var maximumParticipantsTextField: UITextField!
    @IBOutlet weak var minimumParticipantsTextField: UITextField!
    @IBOutlet weak var tourDatePicker: UIDatePicker!
    @IBOutlet weak var tourDescriptionTextView: UITextView!
    //    @IBOutlet weak var someTextLabel: UILabel!
    @IBOutlet weak var chooseHikingRouteButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        if let hikingRoute = selectedHikingRoute {
            let name = hikingRoute.name
            chooseHikingRouteButton.setTitle(name, for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let blackBorder = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        tourDescriptionTextView.layer.borderColor = blackBorder.cgColor
        tourDescriptionTextView.layer.borderWidth = 0.5
        tourDescriptionTextView.layer.cornerRadius = 5
    }
    
    @IBAction func chooseRouteButtonOnTap(_ sender: Any) {
        performSegue(withIdentifier: "GoToSelectRouteForTour", sender: self)
    }
    
    @IBAction func createButtonOnTap(_ sender: Any) {
        showSpinner(vc: self)
        
        guard let hostId = user?.id else { return }
        guard let tourName = tourNameTextField.text else { return }
        guard let hikingRouteId = selectedHikingRoute?.id else { return }
        guard let maximumParticipants = maximumParticipantsTextField.text else { return }
        guard let minimumParticipants = minimumParticipantsTextField.text else { return }
        print("date picker date: \(tourDatePicker.date)")
        let datePickerDate = DateFormatter.isoStringFormatter.string(from: tourDatePicker.date)
        guard let tourDescription = tourDescriptionTextView.text else { return }
        print("isoDateString: \(datePickerDate)")
        let url = URL(string: "\(baseUrl)/hikingTour/createTour")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let requestBody = "hostId=\(hostId)&tourName=\(tourName)&hikingRouteId=\(hikingRouteId)&maximumParticipants=\(maximumParticipants)&minimumParticipants=\(minimumParticipants)&dateAndTime=\(datePickerDate)&tourDescription=\(tourDescription)".data(using:  .utf8)
        request.httpBody = requestBody
        request.setValue(JWT_token!, forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request){
            (data, response, error) in
            do {
                let responseFromServer = try JSONDecoder().decode(CreateTourResponse.self, from: data!)
                let messageFromServer = responseFromServer.message
                
                DispatchQueue.main.sync {
                    if(messageFromServer == "Tour created!") {
                        self.removeSpinner(vc: self)
                        let controller = UIAlertController(title: "Message", message: messageFromServer, preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
                            (action) in
                            self.performSegue(withIdentifier: "GoBackToHikingToursList", sender: self)
                        })
                        controller.addAction(okAction)
                        self.present(controller, animated: true, completion: nil)
                    }
                }
            } catch let err {
                print("error from CreateTourViewController: \(err)")
            }
        }
        task.resume()
        
    }
    
    @IBAction func unwindToCreateTourVC(_ sender: UIStoryboardSegue) {
        print("sss: \(selectedHikingRoute)")
    }
    
}
