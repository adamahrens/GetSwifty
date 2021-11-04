/// Copyright (c) 2020 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import SwiftUI

struct ContentView: View {
  @State var game = Game()
  @State var guess: RGB
  @State var showScore = false
  
  /// For adapting to screen size
  ///
  private let circle = CGFloat(0.5)
  private let labelWidth = CGFloat(0.53)
  private let labelHeight = CGFloat(0.06)
  private let buttonWidth = CGFloat(0.87)
  
  var body: some View {
    GeometryReader { reader in
      ZStack {
        Color.element
          .edgesIgnoringSafeArea(.all)
        
        VStack {
          ColorCircle(rgb: game.target, size: CGSize(width: reader.size.width * circle, height: reader.size.width * circle))
          
          if showScore {
            BevelText(text: game.target.intString(), size: CGSize(width: reader.size.width * labelWidth, height: reader.size.height * labelHeight))
           
          } else {
            BevelText(text: "R: ???, G: ???, B: ???", size: CGSize(width: 200, height: 48))
          }
          
          ColorCircle(rgb: guess, size: CGSize(width: reader.size.width * circle, height: reader.size.width * circle))
          
          BevelText(text: guess.intString(), size: CGSize(width: reader.size.width * labelWidth, height: reader.size.height * labelHeight))

          GameSlider(color: .red, value: $guess.red)
          GameSlider(color: .green, value: $guess.green)
          GameSlider(color: .blue, value: $guess.blue)
          
          Button("Try Guess") {
            showScore = true
            game.check(guess: guess)
          }.buttonStyle(NeumorphicButtonStyle(size: CGSize(width: reader.size.width * buttonWidth, height: reader.size.height * labelHeight)))
        
          .alert(isPresented: $showScore) {
            Alert(title: Text("Your Score"), message: Text(String(game.scoreRound)), dismissButton: .default(Text("Ok")) {
              game.startNewRound()
              guess = RGB()
            })
          }
        }
          .padding(.bottom, 8.0)
          .font(.headline)
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      ContentView(guess: RGB(red: 0.8, green: 0.3, blue: 0.7))
      ContentView(guess: RGB(red: 0.8, green: 0.3, blue: 0.7)).previewDevice("iPhone 8")
      ContentView(guess: RGB(red: 0.8, green: 0.3, blue: 0.7)).previewDevice("iPhone 8 Plus")
      ContentView(guess: RGB(red: 0.8, green: 0.3, blue: 0.7)).previewDevice("iPhone 12 mini")
    }
  }
}
