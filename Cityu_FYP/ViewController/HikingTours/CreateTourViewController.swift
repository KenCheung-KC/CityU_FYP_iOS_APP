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
    var editingTour: Bool = false
    var existingHikingTour: HikingTour?
    
    @IBOutlet weak var tourNameTextField: UITextField!
    @IBOutlet weak var maximumParticipantsTextField: UITextField!
    @IBOutlet weak var minimumParticipantsTextField: UITextField!
    @IBOutlet weak var tourDatePicker: UIDatePicker!
    @IBOutlet weak var tourDescriptionTextView: UITextView!
    //    @IBOutlet weak var someTextLabel: UILabel!
    @IBOutlet weak var chooseHikingRouteButton: UIButton!
    @IBOutlet weak var createTourButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        if let hikingRoute = selectedHikingRoute {
            let name = hikingRoute.name
            chooseHikingRouteButton.setTitle(name, for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("editingTour: \(editingTour)")
        print("existingHikingTour: \(existingHikingTour)")
        let blackBorder = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        tourDescriptionTextView.layer.borderColor = blackBorder.cgColor
        tourDescriptionTextView.layer.borderWidth = 0.5
        tourDescriptionTextView.layer.cornerRadius = 5
        
        if let hikingTour = existingHikingTour {
            let tourName = hikingTour.tourname
            guard let dateAndTime = DateFormatter.isoStringFormatter.date(from: hikingTour.dateandtime) else { return }
            print("aaaaa: \(dateAndTime)")
            let routeName = hikingTour.hikingroutename
            let minParticipants = hikingTour.minimumparticipant
            let maxParticipants = hikingTour.maximumparticipant
            let tourDescritpion = hikingTour.tourdescription
            
            tourNameTextField.text = tourName
            chooseHikingRouteButton.setTitle(routeName, for: .normal)
            maximumParticipantsTextField.text = String(maxParticipants)
            minimumParticipantsTextField.text = String(minParticipants)
            tourDatePicker.date = dateAndTime
            tourDescriptionTextView.text = tourDescritpion
        }
        
        if(editingTour == true) {
            createTourButton.setTitle("Edit Tour", for: .normal)
        } else {
            createTourButton.setTitle("Create Tour", for: .normal)
        }
    }
    
    @IBAction func chooseRouteButtonOnTap(_ sender: Any) {
        performSegue(withIdentifier: "GoToSelectRouteForTour", sender: self)
    }
    
    @IBAction func createButtonOnTap(_ sender: Any) {
        print("Create button tapped")
        showSpinner(vc: self)
        var hikingRouteId: Int?
        
        guard let hostId = user?.id else { return }
        print("hostId: \(hostId)")
        guard let tourName = tourNameTextField.text else { return }
        print("tourName: \(tourName)")
        if let routeId = selectedHikingRoute?.id {
            hikingRouteId = routeId
        }
        if let existingRouteId = existingHikingTour?.hikingrouteid {
            hikingRouteId = existingRouteId
        }
        //        guard let hikingRouteId = selectedHikingRoute?.id else { return }
        print("routeId: \(hikingRouteId)")
        guard let maximumParticipants = maximumParticipantsTextField.text else { return }
        print("maximumParticipants: \(maximumParticipants)")
        guard let minimumParticipants = minimumParticipantsTextField.text else { return }
        print("minimumParticipants: \(minimumParticipants)")
        let datePickerDate = DateFormatter.isoStringFormatter.string(from: tourDatePicker.date)
        print("datePickerDate: \(datePickerDate)")
        guard let tourDescription = tourDescriptionTextView.text else { return }
        print("tourDescription: \(tourDescription)")
        
        
        if(editingTour == false) {
            // create tour, post request
            let url = URL(string: "\(baseUrl)/hikingTour/createTour")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let requestBody = "hostId=\(hostId)&tourName=\(tourName)&hikingRouteId=\(hikingRouteId!)&maximumParticipants=\(maximumParticipants)&minimumParticipants=\(minimumParticipants)&dateAndTime=\(datePickerDate)&tourDescription=\(tourDescription)".data(using: .utf8)
            
            print("request body: \(String(decoding: requestBody!, as: UTF8.self))")
            request.httpBody = requestBody
            print(request.httpBody)
            print("httpBody: \(String(decoding: request.httpBody!, as: UTF8.self))")
            request.setValue(JWT_token!, forHTTPHeaderField: "Authorization")
            let task = URLSession.shared.dataTask(with: request){
                (data, response, error) in
                do {
                    let responseFromServer = try JSONDecoder().decode(CreateOrEditTourResponse.self, from: data!)
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
        } else {
            // edit tour, put request
            let url = URL(string: "\(baseUrl)/hikingTour/editTour/\(existingHikingTour!.id)")!
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            let requestBody = "hostId=\(hostId)&tourName=\(tourName)&hikingRouteId=\(hikingRouteId!)&maximumParticipants=\(maximumParticipants)&minimumParticipants=\(minimumParticipants)&dateAndTime=\(datePickerDate)&tourDescription=\(tourDescription)".data(using: .utf8)
            
            print("request body: \(String(decoding: requestBody!, as: UTF8.self))")
            request.httpBody = requestBody
            print("httpBody: \(String(decoding: request.httpBody!, as: UTF8.self))")
            request.setValue(JWT_token!, forHTTPHeaderField: "Authorization")
            let task = URLSession.shared.dataTask(with: request){
                (data, response, error) in
                do {
                    let responseFromServer = try JSONDecoder().decode(CreateOrEditTourResponse.self, from: data!)
                    let messageFromServer = responseFromServer.message
                    
                    DispatchQueue.main.sync {
                        if(messageFromServer == "Tour edited!") {
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
        
        
    }
    
    @IBAction func unwindToCreateTourVC(_ sender: UIStoryboardSegue) {
        print("sss: \(selectedHikingRoute)")
    }
    
}
