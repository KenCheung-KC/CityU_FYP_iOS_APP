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
var baseUrl: String = "http://localhost:3000"
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

    
//    func showAlert(vc: UIViewController, message: String) {
//        DispatchQueue.main.async {
//            let controller = UIAlertController(title: "Warning", message: messageFromServer, preferredStyle: .alert)
//            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//            controller.addAction(okAction)
//            self.present(controller, animated: true, completion: nil)
//        }
//    }
}
