//
//  SearchView.swift
//  SwiftyPet
//
//  Created by Adam Ahrens on 4/24/22.
//

import SwiftUI

struct SearchView: View {
  var body: some View {
    NavigationView {
      Text("SearchView")
        .navigationTitle("Find your future pet")
    }
  }
}

struct SearchView_Previews: PreviewProvider {
  static var previews: some View {
      SearchView()
  }
}
