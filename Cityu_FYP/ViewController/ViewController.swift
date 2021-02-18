//
//  ViewController.swift
//  Cityu_FYP
//
//  Created by Kam on 23/1/2021.
//  Copyright © 2021 Kam. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBAction func buttonPressed(_ sender: Any) {
        print("button pressed!")
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let x:Int = 51
        
        print("Hi!", x)
        
//        let url = URL(string: "http://localhost:3000/user/register")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        let postData = "username=kamkam1233&email=kamkam1233@email.com&password=123321".data(using: .utf8)
//        request.httpBody = postData
//
//        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
//            guard let data = data else { return }
//            print("response from server: ", String(data: data, encoding: .utf8)!)
//        }

//        task.resume()
        
        let url = URL(string: "http://localhost:3000/pictures/unnamed.jpg")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let imageData = UIImage(data: data!) else { return }
            print("image data: ", imageData)
            DispatchQueue.main.async {
                self.imageView.image = imageData
            }
            
        }
        
        task.resume()
    }

}
