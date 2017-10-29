//
//  ViewController.swift
//  CrowdSense
//
//  Created by Mike Choi on 10/28/17.
//  Copyright © 2017 Mike Choi. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, FrameExtractorDelegate {
  let emotionsURL = "https://westus.api.cognitive.microsoft.com/emotion/v1.0/recognize"
  let header = ["Ocp-Apim-Subscription-Key": "fb09fdf4c5764183bd31f73e03de5099", "Content-Type": "application/octet-stream"]
  let params  = ["url": "http://ww2.hdnux.com/photos/17/51/15/4100937/5/1024x1024.jpg"]
  var frameExtractor: FrameExtractor!
  var counter : Int!
  
  @IBOutlet var previewView: UIView!
  @IBOutlet weak var statusLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    counter = 0
    frameExtractor = FrameExtractor(on: previewView)
    frameExtractor.delegate = self
  }
  
  func captured(image: UIImage) {
    
//    Alamofire.request(emotionsURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: header).responseJSON { response in
//       switch response.result {
//       case .success(let json):
//        print(json)
//        break
//       case .failure(let error):
//        print(error)
//        break
//      }
//    }
  }
}

