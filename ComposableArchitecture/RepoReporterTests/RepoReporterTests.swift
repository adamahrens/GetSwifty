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

import ComposableArchitecture
import XCTest

@testable import RepoReporter

class RepoReporterTests: XCTestCase {
  let testScheduler = DispatchQueue.test
  var testRepositories: [RepositoryModel] {
    [
      RepositoryModel(
        name: "Repo 1",
        description: "This is the first repo.",
        stars: 5,
        forks: 5,
        language: "Swift")
    ]
  }

  func testRepositoryEffect(decoder: JSONDecoder) -> Effect<[RepositoryModel], APIError> {
    return Effect(value: testRepositories)
  }

  func testFavoriteButtonTapped() {
    let store = TestStore(initialState: RepositoryState(), reducer: repositoryReducer, environment: SystemEnvironment(environment: RepositoryEnvironment(repositoryRequest: testRepositoryEffect), main: {
      self.testScheduler.eraseToAnyScheduler()
    }, decoder: {
      JSONDecoder()
    }))
    
    guard let repo = testRepositories.first else { fatalError("Test setup incomplete") }
    store.send(.favoriteTapped(repo)) { state in
//      state.favorites.append(repo)
    }
  }

  func testOnAppear() {
  }
}
