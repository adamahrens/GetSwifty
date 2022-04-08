//
//  MusicRow.swift
//  MusicApp
//
//  Created by Adam Ahrens on 4/4/22.
//

import SwiftUI

struct MusicRow: View {
  @Binding var music: Music
  
  var body: some View {
    HStack {
      Image(systemName: "music.note")
        .renderingMode(.original)
        .foregroundColor(.pink)
        .clipShape(Circle())
        .padding(4)
        .overlay(Circle().stroke(.pink, lineWidth: 2))
       
        
      VStack(alignment: .leading) {
        Text(music.song)
          .fontWeight(.semibold)
        Text("by \(music.artist)")
          .foregroundColor(.gray)
          .fontWeight(.light)
      }
      
      Spacer()
      
      Text(randomTime())
    }.padding([.leading, .trailing], 6.0)
  }
  
  private func randomTime() -> String {
    "\(Int.random(in: 1...4)):\(Int.random(in: 1...4))\(Int.random(in: 1...4))"
  }
}

struct MusicRow_Previews: PreviewProvider {
  static var previews: some View {
    MusicRow(music: .constant(Music(artist: "JAY-Z", song: "99 Problems", album: "The Black Album")))
      .previewLayout(.sizeThatFits)
      .padding()
  }
}
