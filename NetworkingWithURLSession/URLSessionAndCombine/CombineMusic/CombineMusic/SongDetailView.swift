//
//  SongDetailView.swift
//  CombineMusic
//
//  Created by Adam Ahrens on 8/17/21.
//

import SwiftUI
import Combine

struct ArtistResponse: Codable {
  let results: [Artist]
}

struct Artist: Codable {
  let artistName: String
  let primaryGenreName: String
}

final class SongDetailViewModel: ObservableObject {
  private var subscriptions = Set<AnyCancellable>()
  
  var musicItem: MusicItem? {
    didSet {
//      fetchArtwork()
//      fetchPrimaryGenre()
      fetchData()
    }
  }
  
  @Published var musicImage = UIImage(systemName: "music.mic")!
  @Published var primaryGenre = ""
  
  private let decoder = JSONDecoder()
    
  private func fetchArtwork() {
    guard
      let artworkUrl = musicItem?.artwork,
      let url = URL(string: artworkUrl)
    else { return }
    
    URLSession.shared
      .dataTaskPublisher(for: url)
      .map(\.data)
      .compactMap { UIImage(data: $0) }
      .replaceError(with: UIImage(systemName: "music.mic")!)
      .eraseToAnyPublisher()
      .receive(on: DispatchQueue.main)
      .assign(to: \.musicImage, on: self)
      .store(in: &subscriptions)
  }
  
  private func fetchPrimaryGenre() {
    guard
      let artistId = musicItem?.artistId,
      let url = URL(string: "https://itunes.apple.com/lookup?id=\(artistId)")
    else { return }
    
    URLSession.shared
      .dataTaskPublisher(for: url)
      .map(\.data)
      .decode(type: ArtistResponse.self, decoder: decoder)
      .compactMap { $0.results.first?.primaryGenreName }
      .replaceError(with: "")
      .eraseToAnyPublisher()
      .receive(on: DispatchQueue.main)
      .assign(to: \.primaryGenre, on: self)
      .store(in: &subscriptions)
  }
  
  private func fetchData() {
    guard
      let artwork = musicItem?.artwork,
      let artworkUrl = URL(string: artwork),
      let artistId = musicItem?.artistId,
      let artistUrl = URL(string: "https://itunes.apple.com/lookup?id=\(artistId)")
    else { return }
    
    let imagePublisher = URLSession.shared.dataTaskPublisher(for: artworkUrl)
      .map(\.data)
      .compactMap { UIImage(data: $0) }
      .replaceError(with: UIImage(systemName: "music.mic")!)
      .eraseToAnyPublisher()
    
    let artistPublisher = URLSession.shared.dataTaskPublisher(for: artistUrl)
      .map(\.data)
      .decode(type: ArtistResponse.self, decoder: decoder)
      .compactMap { $0.results.first?.primaryGenreName }
      .replaceError(with: "")
      .eraseToAnyPublisher()
    
    Publishers.Zip(imagePublisher, artistPublisher)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] image, genre in
        self?.musicImage = image
        self?.primaryGenre = genre
      }.store(in: &subscriptions)
  }
}


struct SongDetailView: View {
  
  let musicItem: MusicItem

  @ObservedObject private var viewModel = SongDetailViewModel()
  
  var body: some View {
    VStack {
      GeometryReader { reader in
        VStack {
          Image(uiImage: viewModel.musicImage)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: reader.size.height / 2)
            .cornerRadius(50)
            .padding()
            .shadow(radius: 10)
          Text("\(musicItem.trackName) - \(musicItem.artistName)")
          Text(musicItem.collectionName)
          HStack {
            Text("Primary Genre")
            Text(viewModel.primaryGenre)
              .font(.subheadline)
              .fontWeight(.bold)
          }
        }
      }
    }
    .onAppear(perform: {
      viewModel.musicItem = musicItem
    })
    .navigationTitle(musicItem.artistName)
  }
}

struct SongDetailView_Previews: PreviewProvider {
  static var previews: some View {
    let item = MusicItem(id: 192678693, artistName: "Leonard Cohen", artistId: 100, trackName: "Hallelujah", collectionName: "The Essential Leonard Cohen", preview: "https://audio-ssl.itunes.apple.com/itunes-assets/Music/16/10/b2/mzm.muynlhgk.aac.p.m4a", artwork: "https://is1-ssl.mzstatic.com/image/thumb/Music/v4/77/17/ab/7717ab31-46f9-48ca-7250-9f565306faa7/source/1000x1000bb.jpg")
    SongDetailView(musicItem: item)
  }
}
