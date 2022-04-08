//
//  MusicHeader.swift
//  MusicApp
//
//  Created by Adam Ahrens on 4/4/22.
//

import SwiftUI

struct MusicHeader: View {
  var body: some View {
    LazyVGrid(columns: [
      .init(.fixed(150)),
      .init(.flexible()),
      .init(.fixed(90))
    ]) {
      VStack(alignment: .leading ) {
        Text("MusicApp")
        .foregroundColor(.white)
        .font(.title)
        .fontWeight(.semibold)
        .padding(.bottom, 8)
        
        Image(systemName: "mustache.fill")
          .renderingMode(.original)
          .foregroundColor(.pink)
      }
      
      Spacer()
      
      VStack(alignment: .trailing) {
        Text("Yolo")
          .foregroundColor(.white)
        
        Button {
          print("Play")
        } label: {
          HStack {
            Image(systemName: "play.fill")
              .renderingMode(.original)
            Text("Play")
            
          }
          .foregroundColor(.white)
        }.tint(.pink)
         .buttonStyle(.borderedProminent)
         .buttonBorderShape(.capsule)
        
        Button {
          print("Play")
        } label: {
          HStack {
            Image(systemName: "pause.fill")
              .renderingMode(.original)
            Text("Play")
            
          }
          .foregroundColor(.white)
        }.tint(.pink)
         .buttonStyle(.borderedProminent)
         .buttonBorderShape(.capsule)
      }
    }
  }
}

struct MusicHeader_Previews: PreviewProvider {
  static var previews: some View {
      MusicHeader()
      .padding()
      .background(Color.black)
      .previewLayout(.sizeThatFits)
  }
}
