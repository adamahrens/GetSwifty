/// Copyright (c) 2021 Razeware LLC
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

struct ScoreView: View {
  
//  @State var numberOfAnswered = 0
  
  // We don't want ScoreView to be the Single Source of Truth
  // We want that to exist outside of this view.
//  @State var numberOfAnswered: Int
  
  // But just doing @State isn't good enough. It is a pass by value
  // Which means the values will get out of sync. Hence @Binding
  // This is a dumb view so we want this owned by something else
  @Binding var numberOfAnswered: Int
  
  // Another way without using @State property wrapper
  var answered = State<Int>(initialValue: 0)
  
  // This Property isn't State because it doesnt
  // change over the lifetime of the View. So make it a
  // constant
  let numberOfQuestions: Int
  
  var body: some View {
    HStack {
      Text("\(numberOfAnswered)/\(numberOfQuestions)")
        .font(.caption)
        .padding(4)
      Spacer()
    }
  }
}

struct ScoreView_Previews: PreviewProvider {
  @State static var numberOfAnswered: Int = 0
  
  static var previews: some View {
    ScoreView(numberOfAnswered: $numberOfAnswered, numberOfQuestions: 5)
      .previewLayout(.sizeThatFits)
      .padding()
  }
}
