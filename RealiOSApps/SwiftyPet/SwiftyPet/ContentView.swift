//
//  ContentView.swift
//  SwiftyPet
//
//  Created by Adam Ahrens on 4/24/22.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    TabView {
      AnimalsNearYouView()
        .tabItem {
          Label("Near you", systemImage: "location")
        }

      SearchView()
        .tabItem {
          Label("Search", systemImage: "magnifyingglass")
        }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
      ContentView()
  }
}
