//
//  HikingRouteDetailViewController.swift
//  Cityu_FYP
//
//  Created by Kam on 16/2/2021.
//  Copyright © 2021 Kam. All rights reserved.
//

import UIKit
import MapKit

class HikingRouteDetailViewController: UIViewController, MKMapViewDelegate {

    var hikingRouteDetail: HikingRoute?
    
    @IBOutlet weak var mapview: MKMapView!
    @IBOutlet weak var ratingStarsContainer: UIView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var routeTypeLabel: UILabel!
    @IBOutlet weak var estimatedDurationLabel: UILabel!
    @IBOutlet weak var hikingRouteDescriptionLabel: UILabel!
    @IBOutlet weak var hikingRouteDetailScrollview: UIScrollView!
    @IBOutlet weak var hikingRouteNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        if let rating = hikingRouteDetail?.stars {
            for n in 0...4 {
                let starsContainer = ratingStarsContainer
                let starImageView = starsContainer?.subviews[n] as! UIImageView
                if (n < rating) {
                    starImageView.image = UIImage(named: "star")
                } else {
                    starImageView.image = UIImage(named: "empty_star")
                }
            }
        }
    }
}
