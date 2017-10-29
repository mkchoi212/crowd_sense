//
//  Color.swift
//  PTSD App
//
//  Created by Mike Choi on 10/26/17.
//  Copyright © 2017 Mike Choi. All rights reserved.
//

import UIKit

extension UIColor {
  static let RED = 0xff3b30
  static let GREEN = 0x4cd964
  
  convenience init(red: Int, green: Int, blue: Int) {
    assert(red >= 0 && red <= 255, "Invalid red component")
    assert(green >= 0 && green <= 255, "Invalid green component")
    assert(blue >= 0 && blue <= 255, "Invalid blue component")
    
    self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
  }
  
  convenience init(rgb: Int) {
    self.init(
      red: (rgb >> 16) & 0xFF,
      green: (rgb >> 8) & 0xFF,
      blue: rgb & 0xFF
    )
  }
}

extension UIColor {
  static let mainSupportingColor =  UIColor(rgb: 0xFFFFFF)
  static let mainThemeColor =  UIColor(rgb: 0x2094FA)
}

