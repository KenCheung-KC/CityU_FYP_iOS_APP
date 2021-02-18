//
//  RegisterViewController.swift
//  Cityu_FYP
//
//  Created by Kam on 30/1/2021.
//  Copyright © 2021 Kam. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
//    var activityViewContainer = UIView()
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("RegisterController view did load!")
    }
    
//    override func viewWillLayoutSubviews() {
//        activityViewContainer = UIView(frame: self.view.bounds)
//    }
    

    @IBAction func signUp(_ sender: Any) {
        guard let username = usernameTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let email = emailTextField.text else { return }
        
        self.showSpinner(vc: self)
        
        let url = URL(string: "\(baseUrl)/user/register")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let requestBody = "username=\(username)&password=\(password)&email=\(email)".data(using:  .utf8)
        request.httpBody = requestBody
        
        let task = URLSession.shared.dataTask(with: request){
            (data, response, error) in
            guard let data = data else { return }
            print("response from server: ", String(data: data, encoding: .utf8)!)
            self.removeSpinner(vc: self)
            let messageFromServer = String(data: data, encoding: .utf8)
            if(messageFromServer != "User created!") {
                DispatchQueue.main.async {
                    let controller = UIAlertController(title: "Warning", message: messageFromServer, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    controller.addAction(okAction)
                    self.present(controller, animated: true, completion: nil)
                }
            } else {
                DispatchQueue.main.async {
                    let controller = UIAlertController(title: "Success", message: messageFromServer, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: {(action) in
                        self.performSegue(withIdentifier: "GoBackToLoginPage", sender: self)
                    })
                    controller.addAction(okAction)
                    self.present(controller, animated: true, completion: nil)
                }
            }
        }
        
        task.resume()
    }
    
}

