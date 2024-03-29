/// Copyright (c) 2020 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

final class CollectionViewController: UICollectionViewController {
  private let cellSpacing: CGFloat = 1
  private let columns: CGFloat = 3
  private var cellSize: CGFloat?
  private var urls: [URL] = []
  private let imageCache = NSCache<NSNumber, UIImage>()

  override func viewDidLoad() {
    super.viewDidLoad()

    guard let plist = Bundle.main.url(forResource: "Photos", withExtension: "plist"),
          let contents = try? Data(contentsOf: plist),
          let serial = try? PropertyListSerialization.propertyList(from: contents, format: nil),
          let serialUrls = serial as? [String] else {
      print("Something went horribly wrong!")
      return
    }

    urls = serialUrls.compactMap { URL(string: $0) }
  }

  private func downloadWithGlobalQueue(at indexPath: IndexPath) {
    // Step 2a: Set up the utility global dispatch queue
    let queue = DispatchQueue.global(qos: .utility)
    
    // Step 2b: Capture self (code fragment 1)
    queue.async { [weak self] in
      guard let self = self else { return }
    
      // Step 2c: Move if-closure from cellForItemAt here and fix urls capture error
      let url = self.urls[indexPath.item]
      
      // Default image to nil
      var image: UIImage? = nil
      
      // Download image
      if let imageData = try? Data(contentsOf: url) {
        image = UIImage(data: imageData)
      }
      
      // Cache the image if it's available
      if let img = image {
        print("Setting cached image for \(indexPath.item)")
        self.imageCache.setObject(img, forKey: NSNumber(value: indexPath.item))
      }
      
      DispatchQueue.main.async { [weak self] in
        guard let self = self else { return }
        
        // Step 2d: Define cell (code fragment 2)
        guard let cell = self.collectionView.cellForItem(at: indexPath) as? PhotoCell else { return }
        
        // Step 2e: Dispatch UI tasks to main queue
        cell.display(image: image)
      }
    }
  }

  private func downloadWithUrlSession(at indexPath: IndexPath) {
    URLSession.shared.dataTask(with: urls[indexPath.item]) { [weak self] data, response, error in
      guard let self = self else {
        print("self no longer valid")
        return }
      
      guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
        print("response is not a 2xx")
        return }
      
      guard let imageData = data else {
        print("data is nil")
        return }
      
      guard let image = UIImage(data: imageData) else {
        print("unable to construct image")
        return }
      
      // cache it
      print("Setting cached image for \(indexPath.item)")
      self.imageCache.setObject(image, forKey: NSNumber(value: indexPath.item))
      
      print("Dispatching image to main")
      DispatchQueue.main.async {
        // update cell
        guard let cell = self.collectionView.cellForItem(at: indexPath) as? PhotoCell else {
          print("unable to fetch PhotoCell for \(indexPath)")
          return }
        
        print("PhotoCell display image")
        cell.display(image: image)
      }
    }.resume()
  }
}

// MARK: - Data source
extension CollectionViewController {
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    urls.count
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "normal", for: indexPath) as! PhotoCell
        
    // Check the cache first
    if let image = imageCache.object(forKey: NSNumber(value: indexPath.item)) {
      print("Using cached image for \(indexPath.item)")
      cell.display(image: image)
    } else {
      cell.display(image: nil)
      print("Downloading image for \(indexPath.item)")
//      downloadWithGlobalQueue(at: indexPath)
      downloadWithUrlSession(at: indexPath)
    }
    
    return cell
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CollectionViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    if cellSize == nil {
      let layout = collectionViewLayout as! UICollectionViewFlowLayout
      let emptySpace = layout.sectionInset.left + layout.sectionInset.right + (columns * cellSpacing - 1)
      cellSize = (view.frame.size.width - emptySpace) / columns
    }

    return CGSize(width: cellSize!, height: cellSize!)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    cellSpacing
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    cellSpacing
  }
}

