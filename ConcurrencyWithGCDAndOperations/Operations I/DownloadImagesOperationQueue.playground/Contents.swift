// Copyright (c) 2020 Razeware LLC
// For full license & permission details, see LICENSE.markdown.

import UIKit
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true
//: # Downloading Images in an OperationQueue
//: Subclass `AsyncOperation` to create an operation that
//: uses `URLSession` `dataTask(with:)` to download an image.
//: Then use this in an `OperationQueue` to download the images
//: represented by the `ids` array.
final class ImageLoadOperation: AsyncOperation {
  private let url: URL
  var image: UIImage?

  init(url: URL) {
    self.url = url
    super.init()
  }
  
  // TODO: Call dataTask with url and save image
  override func main() {
    URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
      
      defer {
        print("Setting state to finished")
        self?.state = .finished
      }
      
      guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode < 300 else {
        print("Response wasn't 200")
        return
      }
      
      guard let imageData = data, let resultImage = UIImage(data: imageData) else {
        print("Unable to build image from data")
        return
      }
      
      self?.image = resultImage
    }.resume()
  }
}
//: For each `id`, create a `url`.
//: Then, for each url, create an `ImageLoadOperation`,
//: and add it to an `OperationQueue`.
//: When each operation completes, add its output `image` to the `images` array.
let base = "https://wolverine.raywenderlich.com/books/con/image-from-rawpixel-id-"
let ids = [466881, 466910, 466925, 466931, 466978, 467028, 467032, 467042, 467052]
var images = [UIImage]()
let queue = OperationQueue()

for id in ids {
  guard let url = URL(string: "\(base)\(id)-jpeg.jpg") else { continue }
  // TODO: Create operation with completionBlock and add to queue
  let operation = ImageLoadOperation(url: url)
  operation.completionBlock = {
    guard let image = operation.image else { return }
    print("Adding image to array")
    images.append(image)
  }
  
  queue.addOperation(operation)
}

duration {
  queue.waitUntilAllOperationsAreFinished()
}

images[7]

PlaygroundPage.current.finishExecution()
