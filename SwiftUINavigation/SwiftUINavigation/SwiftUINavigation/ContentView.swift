//
//  ContentView.swift
//  SwiftUINavigation
//
//  Created by Adam Ahrens on 6/6/22.
//

import SwiftUI

final class ArtViewModel: ObservableObject, Identifiable {
  @Published var disciplines = ["Statue", "Mural", "Plaque", "Composite"]
}

struct ContentView: View {
  @ObservedObject var viewModel = ArtViewModel()
  
  var body: some View {
    NavigationView {
      List(viewModel.disciplines, id: \.self) { item in
        NavigationLink {
          ArtDetailView(item: item)
        } label: {
          Text(item)
            .fontWeight(.semibold)
            .font(.headline)
        }
      }
      .navigationTitle("Art")
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
      ContentView()
  }
}
