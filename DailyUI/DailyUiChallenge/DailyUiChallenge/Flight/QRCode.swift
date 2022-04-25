//
//  QRCode.swift
//  DailyUiChallenge
//
//  Created by Adam Ahrens on 4/13/22.
//

import SwiftUI
import CoreImage

struct QRCode: View {
  func generateBoardingPass() -> UIImage {
    let data = "Adam".data(using: .ascii, allowLossyConversion: false)
    let filter = CIFilter(name: "CIQRCodeGenerator")!
    filter.setValue(data, forKey: "inputMessage")
    filter.setValue("Q", forKey: "inputCorrectionLevel")
    let output = filter.outputImage!
    let transform = CGAffineTransform(scaleX: 10.0, y: 10.0)
    let sized = output.transformed(by: transform)
    
    let tinted = sized.applyTint(using: UIColor(red: 0.93, green: 0.31, blue: 0.23, alpha: 1.09))!
    let image = UIImage(ciImage: tinted)
    let pngData = image.pngData()!
    return UIImage(data: pngData)!
  }
  
  var body: some View {
    HStack {
      Image(uiImage: generateBoardingPass())
        .resizable()
        .tint(Color.blue)
        .frame(width: 100, height: 100)
    }.foregroundColor(.brown)
    .background(Color.cyan)
  }
}

struct QRCode_Previews: PreviewProvider {
  static var previews: some View {
      QRCode()
      .previewLayout(.sizeThatFits)
      .padding()
      .background(Color.red)
  }
}
