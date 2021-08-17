//
//  ContentView.swift
//  CombineMusic
//
//  Created by Adam Ahrens on 8/16/21.
//

import SwiftUI
import Combine

// MARK: Models

struct MediaResponse: Codable{
  var results: [MusicItem]
}

struct MusicItem: Codable, Identifiable  {
  let id: Int
  let artistName: String
  let artistId: Int
  let trackName: String
  let collectionName: String
  let preview: String
  let artwork: String
  
  var localFile: URL?
  var isDownloading = false
  var downloadLocation: URL?
  var previewUrl: URL? {
    return URL(string: preview)
  }
  
  enum CodingKeys: String, CodingKey {
    case id = "trackId"
    case artistName
    case artistId
    case trackName
    case collectionName
    case preview = "previewUrl"
    case artwork = "artworkUrl100"
  }
}

extension MusicItem {
  init(id: Int, artistName: String, artistId: Int, trackName: String, collectionName: String, preview: String, artwork: String) {
    self.id = id
    self.artistName = artistName
    self.artistId = artistId
    self.trackName = trackName
    self.collectionName = collectionName
    self.preview = preview
    self.artwork = artwork
  }
}

final class SearchViewModel: ObservableObject {
  private var subscriptions = Set<AnyCancellable>()
  private let decoder = JSONDecoder()
  
  // Public
  @Published var results = [MusicItem]()
  @Published var query = ""
  
  init() {
    $query
      .debounce(for: .milliseconds(700), scheduler: RunLoop.main)
      .removeDuplicates() // Prevent same value from being published
      .compactMap { query in
        let searchUrl = "https://itunes.apple.com/search?media=music&entity=song&term=\(query)"
        return URL(string: searchUrl)
      }
      .flatMap(fetchSearchResults)
      .receive(on: DispatchQueue.main)
      .assign(to: \.results, on: self)
      .store(in: &subscriptions)
//      .sink { input in
//        print("User typed in \(input)")
//      }
//      .store(in: &subscriptions)
  }
  
  private func fetchSearchResults(for url: URL) -> AnyPublisher<[MusicItem], Never> {
    URLSession.shared
      .dataTaskPublisher(for: url)
      .map(\.data) // Get the Data from the response
      .decode(type: MediaResponse.self, decoder: decoder)
      .map(\.results)
      .replaceError(with: [])
      .eraseToAnyPublisher()
  }
}

// MARK: Views
struct ContentView: View {
  
  @ObservedObject private var viewModel = SearchViewModel()
  
  var body: some View {
    NavigationView {
      VStack {
        TextField("Search", text: $viewModel.query)
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .padding()
        
        Spacer()
        
        List(viewModel.results) { item in
          NavigationLink(
            destination: SongDetailView(musicItem: item),
            label: {
              VStack(alignment: .leading) {
                
                Text(item.trackName)
                  .font(.headline)
                  .fontWeight(.bold)
                
                Text(item.artistName)
                  .font(.subheadline)
                  .fontWeight(.light)
              }
            })
        }
      }.navigationTitle("Music Search")
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
