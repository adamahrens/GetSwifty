//
//  ContentView.swift
//  WaitForIt
//
//  Created by Adam Ahrens on 2/28/22.
//

import SwiftUI

struct ContentView: View {
  
  @StateObject var service = JokeService()
  
  var body: some View {
    ZStack {
      Text(service.joke)
        .multilineTextAlignment(.center)
        .padding(.horizontal)
      
      VStack {
        Spacer()
        
        Button { service.fetchJoke() } label: {
          Text("Fetch Joke")
            .padding(.bottom)
            .opacity(service.isFetching ? 0 : 1)
            .overlay {
              if service.isFetching {
                ProgressView()
              }
            }
        }
        AsyncImage(url: URL(string: "https://files.betamax.raywenderlich.com/attachments/collections/194/e12e2e16-8e69-432c-9956-b0e40eb76660.png")) { image in
          image.resizable()
        } placeholder: {
          Color.red
        }.frame(width: 128, height: 128)
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
      ContentView()
  }
}
