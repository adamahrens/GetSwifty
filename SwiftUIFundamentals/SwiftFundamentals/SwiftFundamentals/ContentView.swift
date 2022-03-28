//
//  ContentView.swift
//  SwiftFundamentals
//
//  Created by Adam Ahrens on 3/24/22.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    ZStack {
     
      VStack {
        VStack {
          Image(systemName: "sun.max.fill")
            .resizable()
            .foregroundColor(.yellow)
            .frame(width: 50, height: 50)
          
          Text("Sunny")
            .fontWeight(.bold)
            .padding(.bottom, 8)
            
          Text("H: 61, L: 44")
            .fontWeight(.light)
        }
        .padding()
        .foregroundColor(.white)
        .background(
          LinearGradient(gradient: Gradient(colors: [.white, .blue]), startPoint: .top, endPoint: .bottom)
        )
        .cornerRadius(8)
        .padding(.bottom, 20)
        
        HStack {
          Image(systemName: "camera")
          Text("Smile")
            .font(.largeTitle)
            .padding(.leading, 5.0)
        }.foregroundColor(.purple)
        
        Button(":)") {
          print("You're on candid camera")
        }.tint(.purple)
          .buttonStyle(.borderedProminent)
          .buttonBorderShape(.capsule)
          .controlSize(.large)
      }
      
      
      Image(systemName: "swift")
        .resizable()
        .scaledToFit()
        .padding()
        .opacity(0.09)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
      ContentView()
  }
}
