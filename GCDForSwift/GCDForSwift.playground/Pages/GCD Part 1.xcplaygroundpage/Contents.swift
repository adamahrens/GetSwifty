import UIKit

struct Photo: Codable {
  let albumId: Int
  let id: Int
  let title: String
  let url: URL
  let thumbnailUrl: URL
}

final class PhotoManager {
  private init() {}
  static let shared = PhotoManager()
  
  private let photoQueue = DispatchQueue(label: "appsbyahrens.photoQueue", qos: .default, attributes: .concurrent)
  
  private var unsafePhotos = [Photo]()
  
  var photos: [Photo] {
    var safeCopy = [Photo]()
    
    photoQueue.sync {
      // Array of struct so it's a copy by value and not reference
      safeCopy = self.unsafePhotos
    }
    
    return safeCopy
  }
  
  func addPhoto(_ photo: Photo) {
    photoQueue.async(flags: .barrier) { [weak self] in
      guard let self = self else { return }
      self.unsafePhotos.append(photo)
      DispatchQueue.main.async {
        print("Added a photo!")
      }
    }
  }
}

DispatchQueue.global(qos: .userInitiated).async {
  guard
    let url = URL(string: "https://jsonplaceholder.typicode.com/photos")
  else { return }
  
  let task = URLSession.shared.dataTask(with: url) { data, response, error in
    guard
      let res = response as? HTTPURLResponse, 200..<300 ~= res.statusCode
    else {
      print("Unable to fetch json from \(url.absoluteString)")
      return
    }
    
    guard
      error == nil
    else {
      print("Got error from \(url.absoluteString). \(error?.localizedDescription ?? "Unknown error")")
      return
    }
    
    guard
      let d = data
    else {
      print("No data returned from \(url.absoluteString)")
      return
    }
    
    guard
      let photos = try? JSONDecoder().decode([Photo].self, from: d)
    else {
      print("Unable to decode JSON from \(url.absoluteString)")
      return
    }
    
    photos[0..<1000].forEach { photo in
      PhotoManager.shared.addPhoto(photo)
    }
    
    DispatchQueue.main.async {
      print("Got \(PhotoManager.shared.photos.count) photos")
    }
  }
  
  task.resume()
}

DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
  print(PhotoManager.shared.photos.first)
}
