// Copyright (c) 2020 Razeware LLC
// For full license & permission details, see LICENSE.markdown.

import UIKit
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true
//: # Download a Group of Images
let group = DispatchGroup()
let queue = DispatchQueue.global()

let base = "https://wolverine.raywenderlich.com/books/con/image-from-rawpixel-id-"
let ids = [466881, 466910, 466925, 466931, 466978, 467028, 467032, 467042, 467052]
var images = [UIImage]()

// Step 1: Fill in this DispatchGroup wrapper
func dataTaskGroup(with url: URL, group: DispatchGroup, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
  // Notify entering of group
  group.enter()
  
  // Call async function
  URLSession.shared.dataTask(with: url) { data, response, error in
    completionHandler(data, response, error)
    group.leave()
  }.resume()
}

for id in ids {
  guard let url = URL(string: "\(base)\(id)-jpeg.jpg") else { continue }
  // Step 2: Call dataTask_Group
  dataTaskGroup(with: url, group: group) { data, response, error in
    guard let httpResponse = response as? HTTPURLResponse else {
      print("Did not get an HTTPUrl Response")
      return
    }
    
    guard httpResponse.statusCode < 300 else {
      print("Did not get a 200")
      return
    }
    
    guard error == nil else {
      print("Got an error fetching an image")
      return
    }
    
    guard let d = data, let image = UIImage(data: d) else {
      print("Unable to construct image from data")
      return
    }
    
    images.append(image)
    print("Added image to array")
  }
}

// Step 3: Fill in group.notify handler
group.notify(queue: queue) {
  print("Fetched all images")
  PlaygroundPage.current.finishExecution()
}
