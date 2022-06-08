/// Copyright (c) 2022 Razeware LLC
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

import SwiftUI

struct LoadingAnimation: UIViewRepresentable {
  let animatedFrames: UIImage
  let imageView: UIImageView
  let square = CGFloat(125)
  
  init() {
    var images = [UIImage]()
    for index in 1...127 {
      guard
        let image = UIImage(named: "dog_\(String(format: "%03d", index))")
      else { continue }
      images.append(image)
    }
    
    animatedFrames = UIImage.animatedImage(with: images, duration: 4) ?? UIImage()
    imageView = UIImageView.square(side: square)
    imageView.clipsToBounds = true
    imageView.autoresizesSubviews = true
    imageView.contentMode = .scaleAspectFit
  }
  
  /// MARK: UIViewRepresentable
  func makeUIView(context: Context) -> some UIView {
    let view = UIView(frame: CGRect(x: 0, y: 0, width: square, height: square))
    imageView.image = animatedFrames
    imageView.center = view.center()
    view.backgroundColor = .red
    view.addSubview(imageView)
    return view
  }
  
  func updateUIView(_ uiView: UIViewType, context: Context) {
    // do nothing
  }
}


struct LoadingAnimationView: View {
  var body: some View {
    VStack {
      LoadingAnimation()
    }
  }
}
struct LoadingAnimationView_Previews: PreviewProvider {
  static var previews: some View {
    LoadingAnimationView()
  }
}

extension UIImageView {
  static func square(side: CGFloat) -> UIImageView {
    UIImageView(frame: CGRect(x: 0, y: 0, width: side, height: side))
  }
}

extension UIView {
  func center() -> CGPoint {
    CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
  }
}
