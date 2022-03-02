/// Copyright (c) 2021 Razeware LLC
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

import Foundation

/// Easily throw generic errors with a text description.
extension String: Error { }

/// The app model that communicates with the server.
class LittleJohnModel: ObservableObject {
  /// Current live updates.
  @Published private(set) var tickerSymbols = [Stock]()

  ///
  /// Available Stock Symbols
  /// async lets compiler know this runs in an async context
  /// So it might suspend and resume at will.
  func availableSymbols() async throws -> [String] {
    guard
      let url = URL(string: "http://localhost:8080/littlejohn/symbols")
    else { throw "URL could not be created" }
    
    // This suspends the function and resumes when we get a response
    // await asks as the place to "pause" the method execution
    let (data, response) = try await URLSession.shared.data(from: url)
    
    guard
      let httpResponse = response as? HTTPURLResponse,
      200..<300 ~= httpResponse.statusCode
    else { throw "Server responded with an error" }
    
    return try JSONDecoder().decode([String].self, from: data)
  }
  
  /// Start live updates for the provided stock symbols.
  func startTicker(_ selectedSymbols: [String]) async throws {
    tickerSymbols = []
    guard let url = URL(string: "http://localhost:8080/littlejohn/ticker?\(selectedSymbols.joined(separator: ","))") else {
      throw "The URL could not be created."
    }
    
    let (stream, response) = try await liveURLSession.bytes(from: url)
    
    guard
      let httpResponse = response as? HTTPURLResponse,
      200..<300 ~= httpResponse.statusCode
    else { throw "Server responded with an error" }
    
    for try await line in stream.lines {
      let symbols = try JSONDecoder()
        .decode([Stock].self, from: Data(line.utf8))
        .sorted(by: { $0.name < $1.name })
      
      await MainActor.run {
        tickerSymbols = symbols
        print("Running on Main thread")
      }
    }
    
    await MainActor.run {
      tickerSymbols = []
    }
  }

  /// A URL session that lets requests run indefinitely so we can receive live updates from server.
  private lazy var liveURLSession: URLSession = {
    var configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForRequest = .infinity
    return URLSession(configuration: configuration)
  }()
}
