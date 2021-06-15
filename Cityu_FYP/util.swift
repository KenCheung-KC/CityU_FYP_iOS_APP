//
//  ActivityIndicator.swift
//  Cityu_FYP
//
//  Created by Kam on 9/2/2021.
//  Copyright © 2021 Kam. All rights reserved.
//

import UIKit

//var aView : UIView?
var JWT_token: String?
//var baseUrl: String = "https://powerful-bastion-22979.herokuapp.com" // for heroku server
var baseUrl: String = "http://localhost:3000"
//var baseUrl: String = "http://192.168.0.103:3000" // for iOS device
var user: User?

extension UIViewController {
    
    func showSpinner(vc: UIViewController) {
        let activityIndicatorContainer = UIView(frame: vc.view.bounds)
        activityIndicatorContainer.accessibilityIdentifier = "activityIndicatorContainer"
        activityIndicatorContainer.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView()
        ai.transform = CGAffineTransform(scaleX: 3, y: 3)
        ai.center = activityIndicatorContainer.center
        ai.startAnimating()
        activityIndicatorContainer.addSubview(ai)
        vc.view.addSubview(activityIndicatorContainer)
    }
    
    func removeSpinner(vc: UIViewController) {
        DispatchQueue.main.async {
            for subview in vc.view.subviews {
                if (subview.accessibilityIdentifier == "activityIndicatorContainer"){
                    subview.removeFromSuperview()
                    break;
                }
            }
        }
    }
    
    func hideNavigationBar(animated: Bool){
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    
    func showNavigationBar(animated: Bool) {
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func getDateAndTime(ISOString: String) -> DateAndTime? {
        // this function is not used now.
        print("ISOString: \(ISOString)")
        let isoStringFromServerToDate = DateFormatter.isoStringFormatter.date(from: ISOString)
        print("string to date: \(isoStringFromServerToDate)")
        let dateToString = DateFormatter.isoStringFormatter.string(from: isoStringFromServerToDate!)
        print("date to string: \(dateToString)")
        let splitedISOString = ISOString.components(separatedBy: "T")
        let date = splitedISOString[0]
        let time = String(splitedISOString[1].dropLast(5))
        let dateAndTime = DateAndTime(date: date, time: (time))
        
        return dateAndTime
    }
    
    //    func showAlert(vc: UIViewController, message: String) {
    //        DispatchQueue.main.async {
    //            let controller = UIAlertController(title: "Warning", message: messageFromServer, preferredStyle: .alert)
    //            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    //            controller.addAction(okAction)
    //            self.present(controller, animated: true, completion: nil)
    //        }
    //    }
}

extension DateFormatter {
    
    static let isoStringFormatter: DateFormatter = {
        let df = DateFormatter()
        
        // 2) Set the current timezone to .current, or America/Chicago.
        //        df.timeZone = .current
        df.timeZone = TimeZone(identifier: "Asia/Hong_Kong")
        
        // 3) Set the format of the altered date.
        //        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
        
        return df
    }()
    
    static let dateAndTimeFormatter: DateFormatter = {
        let df = DateFormatter()
        df.timeZone = TimeZone(identifier: "Asia/Hong_Kong")
        df.dateStyle = .full
        df.timeStyle = .medium
        return df
    }()
    
    static let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.timeZone = TimeZone(identifier: "Asia/Hong_Kong")
        df.dateStyle = .full
        return df
    }()
    
    static let timeFormatter: DateFormatter = {
        let df = DateFormatter()
        df.timeZone = TimeZone(identifier: "Asia/Hong_Kong")
        df.timeStyle = .short
        return df
    }()
}
