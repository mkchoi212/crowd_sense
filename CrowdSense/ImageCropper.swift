//
//  ImageCropper.swift
//  CrowdSense
//
//  Created by Mike Choi on 10/29/17.
//  Copyright © 2017 Mike Choi. All rights reserved.
//

import UIKit

extension UIImage {
  func subSections() -> [UIImage] {
    let sections = [self.topHalf, self.bottomHalf, self.leftHalf, self.rightHalf]
    return sections.flatMap { $0 }
  }
  
  var topHalf: UIImage? {
    guard let cgImage = cgImage, let image = cgImage.cropping(to: CGRect(origin: .zero, size: CGSize(width: size.width, height: size.height/2))) else { return nil }
    return UIImage(cgImage: image, scale: 1, orientation: imageOrientation)
  }
  var bottomHalf: UIImage? {
    guard let cgImage = cgImage, let image = cgImage.cropping(to: CGRect(origin: CGPoint(x: 0,  y: CGFloat(Int(size.height)-Int(size.height/2))), size: CGSize(width: size.width, height: CGFloat(Int(size.height) - Int(size.height/2))))) else { return nil }
    return UIImage(cgImage: image)
  }
  var leftHalf: UIImage? {
    guard let cgImage = cgImage, let image = cgImage.cropping(to: CGRect(origin: .zero, size: CGSize(width: size.width/2, height: size.height))) else { return nil }
    return UIImage(cgImage: image)
  }
  var rightHalf: UIImage? {
    guard let cgImage = cgImage, let image = cgImage.cropping(to: CGRect(origin: CGPoint(x: CGFloat(Int(size.width)-Int((size.width/2))), y: 0), size: CGSize(width: CGFloat(Int(size.width)-Int((size.width/2))), height: size.height)))
      else { return nil }
    return UIImage(cgImage: image)
  }
}
