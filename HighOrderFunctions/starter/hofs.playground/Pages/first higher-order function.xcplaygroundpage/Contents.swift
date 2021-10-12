/// Sample code from the video course, Higher-Order Functions in Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!

import Foundation

protocol Meowing {
  func meow(times: Int) -> String
}

struct Cat: Meowing {
  var name: String
  
  func meow(times: Int) -> String {
    String(repeating: "meow", count: times)
  }
}


// MARK: Format Sentences
let exampleSentences = [
  "this is an example",
  "Another example!!",
  "one more example, here",
  "what about this example?"
]

/// First Order Way
func format(_ sentence: String) -> String {
    guard !sentence.isEmpty else { return sentence }
    var formattedText = sentence.prefix(1).uppercased() + sentence.dropFirst()
    if let lastCharacter = formattedText.last,
       !lastCharacter.isPunctuation {
      formattedText += "."
    }
    
    return formattedText
}

exampleSentences.forEach { string in
  print(format(string))
}

print("------------------")

/// Not very Swifty because we can't change the formatting

typealias FormatSentence = (String) -> String

extension Array where Element == String {
  func format(_ sentence: String) -> String {
    guard !sentence.isEmpty else { return sentence }
    var formattedText = sentence.prefix(1).uppercased() + sentence.dropFirst()
    if let lastCharacter = formattedText.last,
       !lastCharacter.isPunctuation {
      formattedText += "."
    }
    return formattedText
  }
  
  /// Make into a Higher Order Function
  /// Takes a function as a parameter that has an Input String that Outputs a String
  func printFormatted(format: @escaping FormatSentence) {
    for string in self {
      let formattedString = format(string)
      print(formattedString)
    }
  }
}

//exampleSentences.printFormatted(format: format(_:))

/// Could store it in a variable
print("------------------")
let functionVariable = format(_:)
exampleSentences.printFormatted(format: functionVariable)


print("------------------")
/// Could just pass a closure

exampleSentences.printFormatted { string in
  string.uppercased()
}
