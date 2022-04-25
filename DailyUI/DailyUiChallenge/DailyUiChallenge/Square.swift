//
//  SquareModifier.swift
//  DailyUiChallenge
//
//  Created by Adam Ahrens on 4/13/22.
//

import Foundation
import SwiftUI

struct Square: ViewModifier {
  let by: CGFloat
  
  func body(content: Content) -> some View {
    content.frame(width: by, height: by)
  }
}
