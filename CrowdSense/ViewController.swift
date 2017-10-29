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
import AVFoundation

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
  var recording : Bool!
  var histogram : [String:Int]! = ["😁": 1, "☺️": 5, "😮": 10]
  
  @IBOutlet var previewView: UIView!
  @IBOutlet var scoreView: UIView!
  @IBOutlet weak var confidenceLabel: UILabel!
  @IBOutlet weak var emojiLabel: UILabel!
  @IBOutlet weak var ppButton: UIButton!
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  @IBAction func openLog(_ sender: Any) {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let modalVC = storyboard.instantiateViewController(withIdentifier :"chartvc") as! ChartViewController

    modalVC.histogram = histogram
    modalVC.modalPresentationStyle = .overCurrentContext
    present(modalVC, animated: true, completion: {})
  }
  
  @IBAction func pp(_ sender: Any) {
    if recording {
      counter = 0
      ppButton.setTitle("Start", for: .normal)
      ppButton.backgroundColor = UIColor(rgb: UIColor.GREEN)
    } else {
      counter = 199
      ppButton.setTitle("Stop", for: .normal)
      ppButton.backgroundColor = UIColor(rgb: UIColor.RED)
      confidenceLabel.text = "Scanning..."
      emojiLabel.text = "-"
    }
    recording = !recording
  }
  
  @IBAction func autoFocusTap(_ sender: UITapGestureRecognizer) {
    let point = sender.location(in: self.view)
    let device: AVCaptureDevice = AVCaptureDevice.devices().filter { device in
      device.hasMediaType(.video) &&
        device.position == .back
      }.first!
    do {
      try device.lockForConfiguration()
      if device.isFocusPointOfInterestSupported && device.isFocusModeSupported(device.focusMode){
        device.focusPointOfInterest = point
        device.focusMode = .autoFocus
      }
      device.unlockForConfiguration()
    } catch {
      print(error)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    counter = 0
    recording = false
    
    frameExtractor = FrameExtractor(on: previewView)
    frameExtractor.delegate = self
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(true)
    _ = [scoreView, ppButton].map { $0?.clipsToBounds = true }
    _ = [scoreView, ppButton].map { $0?.layer.cornerRadius = 10.0 }
    ppButton.backgroundColor = UIColor(rgb: UIColor.GREEN)

  }
  
  func captured(image: UIImage) {
    counter = counter + 1
    if (counter % 150 == 0 && recording) {
      counter = 1
      emotionAPICall(image, k: 0.8)
    }
  }
  
  func emotionAPICall(_ image: UIImage, k: Double) {
    print("API CALL \(k)")
    
    let imageData = UIImageJPEGRepresentation(image, CGFloat(k))!
    
    Alamofire.upload(imageData, to: emotionsURL, method: .post, headers: header).responseJSON {response in
      switch response.result {
      case .success(let data):
        let emotionDict = createEmotionDict(json: JSON(data))
        let message = processDict(emotionDict)
        
        if(message.1 == 0.0 && k > 0.5) {
          self.emotionAPICall(image, k: k - 0.1)
        } else {
          self.emojiLabel.text = message.0
          self.confidenceLabel.text = "\(message.1 * 100.0)%"
          if let _ = self.histogram[message.0] {
            self.histogram[message.0] = self.histogram[message.0]! + 1
          } else {
            self.histogram[message.0] = 1
          }
        }
        break

      case .failure(let error):
        let alert = UIAlertController(title: "API Error", message: error as? String, preferredStyle: UIAlertControllerStyle.alert)
        self.present(alert, animated: true, completion: {})
        break
      }
    }
  }
}
