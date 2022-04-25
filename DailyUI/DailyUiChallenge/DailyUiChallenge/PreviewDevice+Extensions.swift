//
//  PreviewDevice+Extensions.swift
//  DailyUiChallenge
//
//  Created by Adam Ahrens on 4/13/22.
//

import Foundation
import SwiftUI

extension PreviewDevice {
  static var iphone8plus: PreviewDevice {
    PreviewDevice(rawValue: "iPhone 8 Plus")
  }
  static var iphone6: PreviewDevice {
    PreviewDevice(rawValue: "iPhone 6")
  }
  
  static var iphone12ProMax: PreviewDevice {
    PreviewDevice(rawValue: "iPhone 12 Pro Max")
  }
  
  static var iphone13Mini: PreviewDevice {
    PreviewDevice(rawValue: "iPhone 13 mini")
  }
  
  static var iphoneSE: PreviewDevice {
    PreviewDevice(rawValue: "iPhone SE")
  }
}
