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
  
  var frameExtractor: FrameExtractor!
  var counter : Int!
  
  @IBOutlet var previewView: UIView!
  @IBOutlet weak var statusLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    let imageData = UIImagePNGRepresentation(UIImage(named: "sample")!)!
    
    Alamofire.upload(imageData, to: emotionsURL, method: .post, headers: header).responseJSON {response in
      switch response.result {
      case .success(let json):
        print(json)
        break
      case .failure(let error):
        print(error)
        break
      }
    }
    
    counter = 0
    frameExtractor = FrameExtractor(on: previewView)
    frameExtractor.delegate = self
  }
  
  func captured(image: UIImage) {
    
  }
}

