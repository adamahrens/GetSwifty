//
//  ContentView.swift
//  Concurrency
//
//  Created by Adam Ahrens on 8/12/21.
//

import SwiftUI

struct ContentView: View {
  
  enum ArtistCover: String, CaseIterable {
    case metallica = "Metallica"
    case weezer = "Weezer"
    case u2 = "U2"
  }
  
  @State private var artistCover = ArtistCover.weezer
  
  var body: some View {
    VStack {
      Spacer()
      
      DatePicker(
        selection: .constant(Date()),
        label: { Text("Date") }
      )
      .labelsHidden()
      .datePickerStyle(WheelDatePickerStyle())
      
      Button(action: {
        // This will block the UI since it's an
        // intensive calculation
        calculatePrimes()
      }, label: {
        Text("Calculate Primes")
      })
      
      Picker("Enter Sandman", selection: $artistCover) {
        ForEach(ArtistCover.allCases, id: \.self) {
          Text($0.rawValue)
        }
   
      }.pickerStyle(SegmentedPickerStyle())
      .padding()
      
      Spacer()
    }
  }
  
  private func calculatePrimes() {
    for number in 0...8_000_000 {
      let isPrime = isPrime(number: number)
      print("\(number) is prime? \(isPrime.description)")
    }
  }
  
  private func isPrime(number: Int) -> Bool {
    if number <= 1 { return false }
    if number <= 3 { return true }
    
    var i = 2
    while i * i <= number {
      if number % i == 0 {
        return false
      }
      
      // Update i
      i = i + 2
    }
    
    return true
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
