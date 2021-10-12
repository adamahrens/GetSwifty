/// Sample code from the video course, Higher-Order Functions in Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!

extension UnsignedInteger {
  func digits(radix: Self = 10) -> [Self] {
    sequence(state: self) { quotient in
      guard quotient > 0 else { return nil}
      let division = quotient.quotientAndRemainder(dividingBy: radix)
      quotient = division.quotient
      return division.remainder
    }.reversed()
  }
}


(867_5309 as UInt).digits()
(0x00_F0 as UInt).digits(radix: 0b10)
