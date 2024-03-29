//
//  LoginPageController.swift
//  Cityu_FYP
//
//  Created by Kam on 30/1/2021.
//  Copyright © 2021 Kam. All rights reserved.
//

import UIKit

class LoginPageViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        usernameTextField.text = ""
        passwordTextField.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
    
    @IBAction func unwindFunction(unwindSegue: UIStoryboardSegue){
        print("unwind function in Register view controller")
    }
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        guard let username = usernameTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        let url = URL(string: "\(baseUrl)/user/login")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        let requestBody = "username=\(username)&password=\(password)".data(using: .utf8)
        request.httpBody = requestBody
        
        let task = URLSession.shared.dataTask(with: request){
            (data, response, error) in
            
            do {
                let loginResponseFromServer = try JSONDecoder().decode(LoginResponse.self, from: data!)
                let message = loginResponseFromServer.message
                if (message == "login success") {
                    let token = loginResponseFromServer.token!
                    let userFromServer = loginResponseFromServer.user
                    JWT_token = token
                    user = userFromServer
//                    print("JWT_token \(JWT_token)")
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "GoToMainPage", sender: self)
                    }
                } else {
                    DispatchQueue.main.async {
                        let controller = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        controller.addAction(okAction)
                        self.present(controller, animated: true, completion: nil)
                    }
                }
            } catch let err {
                print("err from loginPageViewController: \(err)")
            }
        }
        task.resume()
    }
}
