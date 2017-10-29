//
//  ViewController.swift
//  CrowdSense
//
//  Created by Mike Choi on 10/28/17.
//  Copyright © 2017 Mike Choi. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
  let emotionsURL = "https://westus.api.cognitive.microsoft.com/emotion/v1.0/recognize"
  let header = ["Ocp-Apim-Subscription-Key": "fb09fdf4c5764183bd31f73e03de5099", "Content-Type": "application/json"]
  let p2  = ["url": "http://ww2.hdnux.com/photos/17/51/15/4100937/5/1024x1024.jpg"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    Alamofire.request(emotionsURL, method: .post, parameters: p2, encoding: JSONEncoding.default, headers: header).responseJSON { response in
      if let json = response.result.value {
        print(json)
      }
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

