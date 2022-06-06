//
//  ArtDetailView.swift
//  SwiftUINavigation
//
//  Created by Adam Ahrens on 6/6/22.
//

import SwiftUI

struct ArtDetailView: View {
  let item: String
  
  var body: some View {
    Text(item)
      .font(.largeTitle)
      .fontWeight(.thin)
      .navigationTitle(item)
  }
}

struct ArtDetailView_Previews: PreviewProvider {
  static var previews: some View {
    ArtDetailView(item: "Hello")
  }
}
