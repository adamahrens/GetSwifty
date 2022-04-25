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

import SwiftUI
import Combine
import ComposableArchitecture

struct RepositoryListView: View {
  let store: Store<RepositoryState, RepositoryAction>

  var body: some View {
    WithViewStore(self.store) { viewStore in
      ScrollView {
        LazyVStack {
          ForEach(viewStore.repositories) { repository in
            RepositoryView(repository: repository, store: store)
              .padding([.leading, .trailing, .bottom])
          }
        }
        .background(Color("rw-dark")
          .edgesIgnoringSafeArea([.top, .leading, .trailing]))
      }
      .onAppear { viewStore.send(.onAppear) }
    }
  }
}

struct FavoritesListView: View {
  let store: Store<RepositoryState, RepositoryAction>

  var body: some View {
    WithViewStore(self.store) { viewStore in
      ScrollView {
        LazyVStack {
          ForEach(viewStore.favorites) { repository in
            RepositoryView(repository: repository, store: store)
              .padding([.leading, .trailing, .bottom])
          }
        }
        .background(Color("rw-dark")
          .edgesIgnoringSafeArea([.top, .leading, .trailing]))
      }
    }
  }
}

struct RepositoryView: View {
  let repository: RepositoryModel
  let store: Store<RepositoryState, RepositoryAction>

  var body: some View {
    WithViewStore(self.store) { viewStore in
      VStack {
        HStack {
          Text(repository.name)
            .font(.title)
          Spacer()
          Button(
            action: { viewStore.send(.favoriteTapped(repository)) },
            label: {
              if viewStore.favorites.contains(repository) {
                Image(systemName: "heart.fill")
              } else {
                Image(systemName: "heart")
              }
            })
        }
        Text(repository.description ?? "No description available")
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.top, 4)
          .padding(.bottom, 4)
        HStack {
          HStack {
            Image(systemName: "star.fill")
            Text("\(repository.stars)")
          }
          Spacer()
          HStack {
            Image(systemName: "arrow.triangle.branch")
            Text("\(repository.forks)")
          }
          Spacer()
          if repository.language != nil {
            Text("\(repository.language ?? "---")")
              .multilineTextAlignment(.center)
          }
        }
      }
      .padding()
      .foregroundColor(Color("rw-light"))
      .background(Color("rw-green"))
    .cornerRadius(8.0)
    }
  }
}

struct RepositoryListView_Previews: PreviewProvider {
  static var previews: some View {
    RepositoryListView(store: Store(
        initialState: RepositoryState(),
        reducer: repositoryReducer,
        environment: .dev(environment: RepositoryEnvironment(repositoryRequest: dummyRepositoryEffect))
      )
    )
  }
}
