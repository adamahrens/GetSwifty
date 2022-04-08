//
//  MusicList.swift
//  MusicApp
//
//  Created by Adam Ahrens on 4/4/22.
//

import SwiftUI

struct MusicList: View {
  @EnvironmentObject var repository: MusicRepository
  @Binding var music: [Music]
  
  var body: some View {
    GeometryReader { reader in
      ScrollView {
        ForEach($music) { m in
          MusicRow(music: m)
            .padding([.top, .bottom], 8)
            .onTapGesture {
              repository.selectedMusic = m.wrappedValue
            }
        }
      }.frame(minHeight: reader.size.height * 0.75)
    }
  }
}

struct MusicList_Previews: PreviewProvider {
  static var previews: some View {
    MusicList(music: .constant([
      Music(artist: "Slipknot", song: "Purity", album: "Self Titled"),
      Music(artist: "American Head Charge", song: "Just So You Know", album: "The War of Art"),
      Music(artist: "Cartel", song: "Faster Ride", album: "Cycles"),
      Music(artist: "The Home Team", song: "Right Through Me", album: "Slow Bloom"),
      Music(artist: "JAY-Z", song: "99 Problems", album: "The Black Album")
    ]))
  }
}
