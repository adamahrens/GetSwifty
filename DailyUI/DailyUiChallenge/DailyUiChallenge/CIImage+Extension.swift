//
//  CIImage+Extension.swift
//  DailyUiChallenge
//
//  Created by Adam Ahrens on 4/14/22.
//

import Foundation
import CoreImage
import UIKit

extension CIFilter {
  static var colorInvert = CIFilter(name: "CIColorInvert")
  static var maskToAlpha = CIFilter(name: "CIMaskToAlpha")
  static var multiplyCompositing = CIFilter(name: "CIMultiplyCompositing")
  static var constantColorGenerator = CIFilter(name: "CIConstantColorGenerator")
}

extension CIImage {
  var transparent: CIImage? {
    inverted?.blackTransparent
  }
  
  var inverted: CIImage? {
    guard let filter = CIFilter.colorInvert else { return nil }
    filter.setValue(self, forKey: "inputImage")
    return filter.outputImage
  }
  
  var blackTransparent: CIImage? {
    guard let filter = CIFilter.maskToAlpha else { return nil }
    filter.setValue(self, forKey: "inputImage")
    return filter.outputImage
  }
  
  func applyTint(using color: UIColor) -> CIImage? {
    guard
      let transparent = transparent,
      let multiply = CIFilter.multiplyCompositing,
      let constantColor = CIFilter.constantColorGenerator
    else { return nil }
    
    let ciColor = CIColor(color: color)
    constantColor.setValue(ciColor, forKey: kCIInputColorKey)
    let colorImage = constantColor.outputImage
    
    multiply.setValue(colorImage, forKey: kCIInputImageKey)
    multiply.setValue(transparent, forKey: kCIInputBackgroundImageKey)
    return multiply.outputImage
  }
}
