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
    ScrollView {
      Section("Current") {
        Text(service.joke)
          .fontWeight(.bold)
          .multilineTextAlignment(.center)
          .padding(.horizontal)
          .frame(maxHeight: 200)
      }
      
      Button {
        Task.init(priority: .userInitiated) {
          try? await service.fetchJoke()
        }
      } label: {
        Text("Fetch Joke")
          .padding(.bottom)
          .opacity(service.isFetching ? 0 : 1)
          .overlay {
            if service.isFetching {
              ProgressView()
            }
          }
      }
      
      if service.previousJokes.count > 1 {
        Section("Previous") {
          ForEach(service.previousJokes, id: \.self) { joke in
            Text(joke)
              .fontWeight(.light)
              .multilineTextAlignment(.center)
              .padding(.horizontal)
              .frame(maxHeight: 200)
          }
        }
      }
    }
    
    /*
    Group {
     
     
      Button {

        // Feels like calling
        // DispatchQueue.global().async
        
//          Deprecated
//          async {
//            try? await service.fetchJoke()
//          }
        
        Task.init(priority: .userInitiated) {
          try? await service.fetchJoke()
        }
      } label: {
        Text("Fetch Joke")
          .padding(.bottom)
          .opacity(service.isFetching ? 0 : 1)
          .overlay {
            if service.isFetching {
              ProgressView()
            }
          }
      }
    }
     */
      
//      List(service.previousJokes, id: \.self) { joke  in
//        Text(joke)
//      }
      
        
      
        /*
        AsyncImage(url: URL(string: "https://files.betamax.raywenderlich.com/attachments/collections/194/e12e2e16-8e69-432c-9956-b0e40eb76660.png")) { image in
          image.resizable()
        } placeholder: {
          Color.red
        }.frame(width: 128, height: 128)
         */
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
      ContentView()
  }
}
