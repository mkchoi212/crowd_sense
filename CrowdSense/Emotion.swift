//
//  Emotion.swift
//  CrowdSense
//
//  Created by Mike Choi on 10/29/17.
//  Copyright © 2017 Mike Choi. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Emoji {
  static let dict = ["happiness": ["🙂", "☺️", "😁"], "anger" : ["😠", "😡","😤"], "contempt" : ["😏", "😕", "😒"], "disgust" : ["😬", "😟", "🤢"], "fear" : ["😦", "😧", "😨"], "neutral" : ["😶","😐","😑"], "sadness" : ["🙁", "☹️", "😢"], "surprise" : ["😯", "😮", "😲"]]
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

func createEmotionDict(json: JSON) -> [String:[Float]] {
  var emotionDict = Dictionary<String, Array<Float>>()
  
  for (_, person) in json {
    guard let emotion = person["scores"].max(by: { $0.1 < $1.1 }) else { continue }
    let score = emotion.1.floatValue
    
    if let _ = emotionDict[emotion.0] {
      emotionDict[emotion.0]!.append(score)
    } else {
      emotionDict[emotion.0] = [score]
    }
  }
  
  return emotionDict
}

func processDict(_ emotionDict: [String:[Float]]) -> ((String, Float), String) {
  var average = Dictionary<String, Float>()
  
  for (emotion, arr) in emotionDict {
    let cnt = arr.count
    average[emotion] = arr.reduce(0, +) / Float(cnt)
  }
  
  guard let emotion = average.max(by: {$0.1 < $1.1}) else { return (("-", 0.00), "neutral") }
  let des = emotion.0
  let val = emotion.1
  
  let e_array = Emoji.dict[des]!
  var emoji = ""
  
  if val <= 0.5 {
    emoji = e_array[0]
  } else if val <= 0.75 {
    emoji = e_array[1]
  } else {
    emoji = e_array[2]
  }
  
  return ((emoji, val), des)
}
