import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()

example(of: "Making Phone Numbers Part 2") {
  let phoneNumbersPublisher = ["123-4567", "555-1212", "555-1111", "123-6789"].publisher
  let areaCodePublisher = ["410", "757", "800", "540"].publisher
  let phoneExtensionPublisher = ["EXT 901", "EXT 523", "EXT 137", "EXT 100"].publisher
    
  areaCodePublisher
    .zip(phoneNumbersPublisher, phoneExtensionPublisher)
    .map { area, phone, ext in
      "1-\(area)-\(phone) \(ext)"
    }
    .sink { value in
      print("Next >>> \(value)")
    }.store(in: &subscriptions)
}

example(of: "Making Phone Numbers Part 3") {
  let phoneNumbersPublisher = ["123-4567", "555-1212", "555-1111", "123-6789"].publisher
  let areaCodePublisher = ["410", "757", "800", "540"].publisher
  let phoneExtensionPublisher = ["EXT 901", "EXT 523", "EXT 137", "EXT 100"].publisher
  
  areaCodePublisher
    .combineLatest(phoneNumbersPublisher)
    .sink { value in
      print("Next >>> \(value)")
    }.store(in: &subscriptions)
}

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
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.
