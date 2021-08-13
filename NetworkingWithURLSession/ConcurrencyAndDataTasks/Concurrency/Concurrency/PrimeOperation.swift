//
//  PrimeOperation.swift
//  Concurrency
//
//  Created by Adam Ahrens on 8/12/21.
//

import Foundation

/// Subclass of Operation to calculate prime numbers
/// Allows you to override other methods
/// Each operation has unique states
/// Ready: It’s prepared to start
/// Executing: The task is currently running
/// Finished: Once the process is completed
/// Canceled: The task canceled
final class PrimeOperation: Operation {
  override func main() {
    for number in 0...500_000 {
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
