// Copyright (c) 2020 Razeware LLC
// For full license & permission details, see LICENSE.markdown.

import UIKit
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true
//: # Creating a Complex Operation
//: ## Subclassing `Operation`
//: Allows you more control over precisely what the `Operation` is doing
let inputImage = UIImage(named: "dark_road_small.jpg")!

// TODO: Create and run TiltShiftOperation
final class TiltShiftOperation: Operation {
  
  private let input: UIImage
  private(set) var output: UIImage?
  private static let context = CIContext()
  
  init(input: UIImage) {
    self.input = input
    super.init()
  }
  
  override func main() {
    super.main()
    guard
      let filtered = TiltShiftFilter(image: input),
      let result = filtered.outputImage
    else {
      print("Unable to filter image")
      return
    }
    
    let rect = CGRect(origin: .zero, size: input.size)
    
    guard
      let cgImage = TiltShiftOperation.context.createCGImage(result, from: rect)
    else { return }
    
    output = UIImage(cgImage: cgImage)
  }
}


let operation = TiltShiftOperation(input: inputImage)

duration {
  operation.start()
}

let final = operation.output

PlaygroundPage.current.finishExecution()
