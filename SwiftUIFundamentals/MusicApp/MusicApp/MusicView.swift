//
//  MusicView.swift
//  MusicApp
//
//  Created by Adam Ahrens on 4/4/22.
//

import SwiftUI

struct MusicView: View {
  @EnvironmentObject var repository: MusicRepository
  
  var body: some View {
    GeometryReader { reader in
      VStack {
        MusicHeader()
        
        MusicList(music: $repository.catalog)
          .background(Color.white.opacity(0.9))
          .cornerRadius(8.0)
          .padding([.leading, .trailing], 6)
        
        MusicPlayer(music: $repository.selectedMusic)
          .frame(width: reader.size.width, height: 45)
          .background(Color.black)
      }
      .frame(minWidth: reader.size.width)
      .background(Color.black)
    }
  }
}

struct MusicView_Previews: PreviewProvider {
  static let repository = MusicRepository()
  
  static var previews: some View {
    Group {
      MusicView()
        .environmentObject(repository)
        .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro Max"))
      MusicView()
        .environmentObject(repository)
    }
  }
}
