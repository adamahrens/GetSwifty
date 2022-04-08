//
//  MusicRepository.swift
//  MusicApp
//
//  Created by Adam Ahrens on 4/4/22.
//

import Foundation

struct Music: Identifiable, Equatable {
  let id = UUID()
  let artist: String
  let song: String
  let album: String
  
  func fullDisplay() -> String {
    "\(song) - \(artist)"
  }
}

final class MusicRepository: ObservableObject {
  @Published var favorites = [Music]()
  @Published var catalog = [Music]()
  @Published var selectedMusic: Music?
  
  init() {
    catalog = [
      Music(artist: "Slipknot", song: "Purity", album: "Self Titled"),
      Music(artist: "American Head Charge", song: "Just So You Know", album: "The War of Art"),
      Music(artist: "Cartel", song: "Faster Ride", album: "Cycles"),
      Music(artist: "The Home Team", song: "Right Through Me", album: "Slow Bloom"),
      Music(artist: "JAY-Z", song: "99 Problems", album: "The Black Album"),
      Music(artist: "Wu-Tang Clan", song: "Sound The Horns", album: "Chamber Music"),
      Music(artist: "August Burns Red", song: "The Frost", album: "Phantom Anthem"),
      Music(artist: "Run The Jewels", song: "The Ground Below", album: "RTJ4"),
      Music(artist: "NOTHING MORE", song: "Jenny", album: "Nothing More"),
      Music(artist: "Ice Nine Kills", song: "Assault & Batteries", album: "Welcome To Horrorwood"),
      Music(artist: "Billy Squier", song: "Lonely Is The Night", album: "Don't Say No"),
      Music(artist: "Skindred", song: "Pressure", album: "Babylon"),
      Music(artist: "Stand Atlantic", song: "Jurassic Park", album: "Pink Elephant")
    ]
  }
  
  func favorite(music: Music) {
    let found = favorites.firstIndex { $0.id == music.id }
    if let index = found {
      favorites.remove(at: index)
    } else {
      favorites.append(music)
    }
  }
  
  func select(music: Music) {
    selectedMusic = music
  }
}
