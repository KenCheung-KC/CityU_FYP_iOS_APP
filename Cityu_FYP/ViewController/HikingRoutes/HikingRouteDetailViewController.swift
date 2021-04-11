//
//  HikingRouteDetailViewController.swift
//  Cityu_FYP
//
//  Created by Kam on 16/2/2021.
//  Copyright © 2021 Kam. All rights reserved.
//

import UIKit
import MapKit
import Cosmos

class HikingRouteDetailViewController: UIViewController, MKMapViewDelegate {

    var hikingRouteDetail: HikingRoute?
    var rating: Double?
//    var liked: Bool?
    
    @IBOutlet weak var mapview: MKMapView!
//    @IBOutlet weak var ratingStarsContainer: UIView!
    @IBOutlet weak var difficultyIconContainer: UIView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var routeTypeLabel: UILabel!
    @IBOutlet weak var estimatedDurationLabel: UILabel!
    @IBOutlet weak var hikingRouteDescriptionLabel: UILabel!
    @IBOutlet weak var hikingRouteDetailScrollview: UIScrollView!
    @IBOutlet weak var hikingRouteNameLabel: UILabel!
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var likeHikingRouteBarButtonItem: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = false
        // Do any additional setup after loading the view.
        mapHikingRouteDetailToUI()
        mapview.delegate = self
        
        let sourceLocation = CLLocationCoordinate2D(latitude: hikingRouteDetail!.startlatitude, longitude: hikingRouteDetail!.startlongitude)
        let destinationLocation = CLLocationCoordinate2D(latitude: hikingRouteDetail!.endlatitude, longitude: hikingRouteDetail!.endlongitude)
        
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        let sourceAnnotation = MKPointAnnotation()
        sourceAnnotation.title = "Start"
                
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.title = "End"
        
        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }
        
        self.mapview.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate {(response, error) -> Void in
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                return
            }
            
            let route = response.routes[0]
            self.mapview.addOverlay(route.polyline, level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapview.setRegion(MKCoordinateRegion(rect), animated: true)
        }
        
        if let rating = hikingRouteDetail?.userrating {
            cosmosView.rating = Double(rating)
        } else {
            cosmosView.rating = 0.0
        }
        
        cosmosView.settings.starSize = 30
        cosmosView.didFinishTouchingCosmos = { rating in
            self.rating = rating
            self.rateForHikingRoute(rating: Int(self.rating!))
        }
        
        if let liked = hikingRouteDetail?.userliked {
            setUserLikedBarButtonItem(liked: liked)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.systemBlue
        renderer.lineWidth = 4.0

        return renderer
    }
    
    func mapHikingRouteDetailToUI() {
        if let details = hikingRouteDetail {
            let name = details.name
            hikingRouteNameLabel.text = name
            let location = details.location
            locationLabel.text = location
            let distance = details.distance
            distanceLabel.text = "\(distance) km"
            let description = details.description
            hikingRouteDescriptionLabel.text = description
            let routeType = details.routetype
            routeTypeLabel.text = routeType
            let estimatedDuration = details.estimatedduration
            estimatedDurationLabel.text = "\(estimatedDuration) minutes"
        }
        
        if let difficultyStars = hikingRouteDetail?.stars {
            for n in 0...4 {
                let difficultyContainer = difficultyIconContainer
                let difficultyImageView = difficultyContainer?.subviews[n] as! UIImageView
                if (n < difficultyStars) {
                    difficultyImageView.image = UIImage(named: "weakness_fill")
                } else {
                    difficultyImageView.image = UIImage(named: "weakness_empty")
                }
            }
        }
    }
    
    func rateForHikingRoute (rating: Int){
        guard let hikingRouteId = hikingRouteDetail?.id else { return }
        guard let url = URL(string: "\(baseUrl)/hikingRoute/rateHikingRoute/\(hikingRouteId)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let requestBody = "userId=\(user!.id)&rating=\(rating)".data(using:  .utf8)
        request.httpBody = requestBody
        request.setValue(JWT_token!, forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request){
            (data, response, err) in
            guard let data = data else { return }
            do {
                let responseFromServer = try JSONDecoder().decode(RateForHikingRouteResponse.self, from: data)
                let messageFromServer = responseFromServer.message
                if(messageFromServer == "Rated for route!"){
                    DispatchQueue.main.sync {
                        print("success")
                        self.removeSpinner(vc: self)
                        let controller = UIAlertController(title: "Message", message: messageFromServer, preferredStyle: .alert)
//                        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
//                            (action) in
//
//                        })
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        controller.addAction(okAction)
                        self.present(controller, animated: true, completion: nil)
                    }
                } else {
                    print("fail?")
                }
            } catch let err {
                
            }
        }
        
        task.resume()
    }
    
    @IBAction func likeHikingRouteBarButtonOnTap(_ sender: Any) {
        likeHikingRoute()
        var liked = hikingRouteDetail!.userliked!
        liked = !liked
        hikingRouteDetail!.userliked = liked
        setUserLikedBarButtonItem(liked: liked)
    }
    
    func setUserLikedBarButtonItem(liked: Bool) {
        if(liked){
            likeHikingRouteBarButtonItem.image = UIImage(systemName: "heart.fill")
        } else {
            likeHikingRouteBarButtonItem.image = UIImage(systemName: "heart")
        }
    }
    
    func likeHikingRoute() {
        showSpinner(vc: self)
        guard let url = URL(string: "\(baseUrl)/hikingRoute/likeHikingRoute/\(hikingRouteDetail!.id)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue(JWT_token!, forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request){
            (data, response, err) in
            do {
                let responseFromServer = try JSONDecoder().decode(LikeForHikingRouteResponse.self, from: data!)
                let messageFromServer = responseFromServer.message
                print("message from server: \(messageFromServer)")
                
                DispatchQueue.main.sync {
                    self.removeSpinner(vc: self)
                }
            } catch let err {
                print("err from likeHikingRoute function: \(err)")
            }
        }
        task.resume()
    }
    
    
}
