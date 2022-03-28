//
//  StateBindingView.swift
//  SwiftFundamentals
//
//  Created by Adam Ahrens on 3/24/22.
//

import SwiftUI

struct SwiftBird: View {
  @Binding var background: Color
  @Binding var opacity: Double

  var body: some View {
    VStack {
      Image(systemName: "swift")
        .resizable()
        .scaledToFit()
        .padding(25)
        .foregroundColor(.white)
        .opacity(opacity)
        .background(background)
        .cornerRadius(50)
    }
  }
}
struct StateBindingView: View {
  @State private var backgroundColor = Color.blue
  @State private var opacity = 0.7
  
  var body: some View {
    VStack {
      SwiftBird(background: $backgroundColor, opacity: $opacity)
        .padding([.leading, .trailing])
      
      ColorPicker("Change Background", selection: $backgroundColor)
        .padding()
      
      Slider(value: $opacity, in: 0.1...1) {
        Text("Change Opacity")
      }
      .padding()
    }
  }
}

struct StateBindingView_Previews: PreviewProvider {
  static var previews: some View {
      StateBindingView()
  }
}
