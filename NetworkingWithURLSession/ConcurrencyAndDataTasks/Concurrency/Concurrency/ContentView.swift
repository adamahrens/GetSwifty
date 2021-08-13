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
  @State private var calculateDisabled = false
  
  // Use OperationQueue for offloading work on background threads
  private let backgroundQueue = OperationQueue()
  private let operation = PrimeOperation()
  
  private let mainQueue = OperationQueue.main
  
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
        // calculatePrimes()
        
        // Use Operation
        performPrimeOperation()
      }, label: {
        Text("Calculate Primes")
      }).disabled(calculateDisabled)
      
      Picker("Enter Sandman", selection: $artistCover) {
        ForEach(ArtistCover.allCases, id: \.self) {
          Text($0.rawValue)
        }
   
      }.pickerStyle(SegmentedPickerStyle())
      .padding()
      
      Spacer()
    }
  }
  
  /// Uses Operation and OperationQueue
  /// to perform prime calculations on background thread
  private func performPrimeOperation() {
    // Want to do this on the main thread
    // Luckily SwiftUI automagically
    // delivers it on the main thread when @State
    // variables change
    calculateDisabled = true
    
    // If this was UIKit would have to run
    // On main thread
    /*
     DispatchQueue.main.async {
      self.calculateDisabled = false
     }
     */
    
    let operation = PrimeOperation()
    
    // Perform after PrimeOperation is complete
    let enableButton = BlockOperation {
      calculateDisabled = false
    }
    
    // Enable is dependent on PrimeOperation completing
    enableButton.addDependency(operation)
    
    // Add to the Queue for work to be performed
    backgroundQueue.addOperation(operation)
    backgroundQueue.addOperation(enableButton)
    
    // Could also just pass in a block instead of creating Operation subclasses for all body of work
    DispatchQueue.global(qos: .userInitiated).async {
      calculatePrimes(logPrefix: "GCD Queue")
    }
    
    backgroundQueue.addOperation {
      calculatePrimes(logPrefix: "OperationQueue")
    }
  }
  
  /**
   * Moving to background Operation Thread
   * To prevent blocking main
   */
   
  private func calculatePrimes(logPrefix: String) {
    for number in 0...500_000 {
      let isPrime = isPrime(number: number)
      print("\(logPrefix) \(number) is prime? \(isPrime.description)")
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
