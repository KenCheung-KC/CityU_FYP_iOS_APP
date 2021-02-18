//
//  HikingRouteDetailController.swift
//  Cityu_FYP
//
//  Created by Kam on 13/2/2021.
//  Copyright © 2021 Kam. All rights reserved.
//

import UIKit
import MapKit

class HikingRouteDetailController: UIViewController, MKMapViewDelegate {

    var hikingRouteDetail: HikingRoute?
    
    @IBOutlet weak var hikingRouteMapView: MKMapView!
    @IBOutlet weak var hikingRouteNameTextField: UITextView!
    @IBOutlet weak var hikingRouteDifficultyStarsContainer: UIView!
    @IBOutlet weak var hikingRouteLocationTextField: UILabel!
    @IBOutlet weak var hikingRouteDistanceTextField: UILabel!
    @IBOutlet weak var hikingRouteDescriptionTextView: UITextView!
    @IBOutlet weak var hikingRouteEstimatedDurationTextField: UILabel!
    @IBOutlet weak var hikingRouteTypeTextField: UILabel!
    @IBOutlet weak var hikingRouteDetailScrollView: UIScrollView!
    @IBOutlet weak var hikingRouteDetailContentContainer: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("hikingRouteDetail in detail view controller: \(hikingRouteDetail)")
        // Do any additional setup after loading the view.
        mapHikingRouteDetailToUI()
        hikingRouteMapView.delegate = self
        
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
        
        self.hikingRouteMapView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
        
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
            self.hikingRouteMapView.addOverlay(route.polyline, level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.hikingRouteMapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
        
//        let height = hikingRouteDetailContentContainer.intrinsicContentSize
        let height = hikingRouteDescriptionTextView.intrinsicContentSize
        print("aaaa height: \(height)")
        
        hikingRouteDetailScrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 100)
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
            hikingRouteNameTextField.text = name
            let location = details.location
            hikingRouteLocationTextField.text = location
            let distance = details.distance
            hikingRouteDistanceTextField.text = "\(distance) km"
            let description = details.description
            hikingRouteDescriptionTextView.text = description
            let routeType = details.routetype
            hikingRouteTypeTextField.text = routeType
            let estimatedDuration = details.estimatedduration
            hikingRouteEstimatedDurationTextField.text = "\(estimatedDuration) minutes"
        }
        let fixedWidth = hikingRouteDescriptionTextView.frame.size.width
        let newSize = hikingRouteDescriptionTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        hikingRouteDescriptionTextView.frame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        
        if let rating = hikingRouteDetail?.stars {
            for n in 0...4 {
                let starsContainer = hikingRouteDifficultyStarsContainer
                let starImageView = starsContainer?.subviews[n] as! UIImageView
                if (n < rating) {
                    starImageView.image = UIImage(named: "star")
                } else {
                    starImageView.image = UIImage(named: "empty_star")
                }
            }
        }
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
