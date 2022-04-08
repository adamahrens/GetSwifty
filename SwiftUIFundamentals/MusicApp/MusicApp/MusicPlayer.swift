//
//  MusicPlayer.swift
//  MusicApp
//
//  Created by Adam Ahrens on 4/4/22.
//

import SwiftUI

struct MusicPlayer: View {
  @Binding var music: Music? {
    didSet {
      progress = 0
      current = 1
    }
  }
  
  @State var progress = CGFloat(0)
  @State var current = CGFloat(1)
  let max = CGFloat(100)
  
  private let timer = Timer
    .publish(every: 1, on: .main, in: .common)
    .autoconnect()
  
  var body: some View {
    VStack {
      if let m = music {
        Text(m.fullDisplay())
          .font(.caption)
        ZStack {
          GeometryReader { reader in
            Capsule()
              .foregroundColor(.white)
              .frame(height: 4.0)
            Capsule()
              .frame(width: reader.size.width * progress, height: 4.0)
              .foregroundColor(.pink)
          }
        }.padding([.leading, .trailing], 8)
      } else {
        Text("No Music to Play")
      }
    }
    .foregroundColor(.pink)
    .background(.black)
    .onReceive(timer) { _ in
      current += 1
      progress = current/max
    }
  }
}

struct MusicPlayer_Previews: PreviewProvider {
  static var previews: some View {
    VStack {
      MusicPlayer(music: .constant(nil))
      MusicPlayer(music: .constant(Music(artist: "American Head Charge", song: "Just So You Know", album: "The War of Art")))
    }
    .previewLayout(.sizeThatFits)
    .padding()
  }
}
