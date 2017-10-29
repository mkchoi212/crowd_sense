//
//  ViewController.swift
//  CrowdSense
//
//  Created by Mike Choi on 10/28/17.
//  Copyright © 2017 Mike Choi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

enum Confidence {
  case Low
  case Medium
  case High
}

class ViewController: UIViewController, FrameExtractorDelegate {
  let emotionsURL = "https://westus.api.cognitive.microsoft.com/emotion/v1.0/recognize"
  let header = ["Ocp-Apim-Subscription-Key": "fb09fdf4c5764183bd31f73e03de5099", "Content-Type": "application/octet-stream"]
  
  var frameExtractor: FrameExtractor!
  var counter : Int!
  var emotionDict = Dictionary<String, Array<Float>>()
  
  @IBOutlet var previewView: UIView!
  @IBOutlet weak var statusLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    counter = 0
    frameExtractor = FrameExtractor(on: previewView)
    frameExtractor.delegate = self
  }
  
  func evalStrength(val: Float) -> Confidence {
    if(val < 0.5) {
      return .Low
    } else if (val < 0.75) {
      return .Medium
    } else {
      return .High
    }
  }
  
  func createEmotionDict(json: JSON) {
    for (_, person) in json {
      guard let emotion = person["scores"].max(by: { $0.1 < $1.1 }) else { continue }
      let score = emotion.1.floatValue
      
      if let _ = emotionDict[emotion.0] {
        emotionDict[emotion.0]!.append(score)
      } else {
        emotionDict[emotion.0] = [score]
      }
    }
    
    print(emotionDict)
  }
  
  func captured(image: UIImage) {
    counter = counter + 1
    
    if (counter % 50 == 0) {
      let imageData = UIImagePNGRepresentation(image)!
    
      Alamofire.upload(imageData, to: emotionsURL, method: .post, headers: header).responseJSON {response in
        switch response.result {
        case .success(let data):
          self.emotionDict = Dictionary<String, Array<Float>>()
          self.createEmotionDict(json: JSON(data))
          break
          
        case .failure(let error):
          print(error)
          break
        }
      }
    }
  }
}

