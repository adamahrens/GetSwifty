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

import Combine
import ComposableArchitecture

struct RepositoryState: Equatable {
  var repositories = [RepositoryModel]()
  var favorites = [RepositoryModel]()
}

enum RepositoryAction: Equatable {
  case onAppear
  case dataLoaded(Result<[RepositoryModel], APIError>)
  case favoriteTapped(RepositoryModel)
}

struct RepositoryEnvironment {
  var repositoryRequest: (JSONDecoder) -> Effect<[RepositoryModel], APIError>
//  Before Using SystemEnvironment
//  which holds most of those
//
//  var main: () -> AnySchedulerOf<DispatchQueue>
//  var decoder: () -> JSONDecoder
//
//  static let development = RepositoryEnvironment(repositoryRequest: dummyRepositoryEffect) {
//    .main
//  } decoder: {
//    JSONDecoder()
//  }
}

//let repositoryReducer = Reducer<RepositoryState, RepositoryAction, RepositoryEnvironment> {
let repositoryReducer = Reducer<RepositoryState, RepositoryAction, SystemEnvironment<RepositoryEnvironment>> {
state, action, environment in
  switch action {
  case .onAppear:
    return environment.repositoryRequest(environment.decoder())
      .receive(on: environment.main())
      .catchToEffect()
      .map(RepositoryAction.dataLoaded)
  case .dataLoaded(let result):
    switch result {
    case .success(let repos):
      state.repositories = repos
    case .failure(let error):
      break
    }
    
    return .none
  case .favoriteTapped(let repository):
    if state.favorites.contains(repository) {
      state.favorites.removeAll { $0 == repository }
    } else {
      state.favorites.append(repository)
    }
    
    return .none
  }
}
