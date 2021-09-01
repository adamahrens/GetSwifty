//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

enum Language {
  case english, german, spanish
}

protocol Localizable {
  static var supportedLanguages: [Language] { get }
}

/// Adding a default implementation to Localizable
extension Localizable {
  static var supportedLanguages: [Language] {
    return [.english]
  }
}

/// We can limit conformance of a Protcol to only subclasses
protocol Uppercased where Self: UILabel {
  func uppercased()
}

extension UILabel: Uppercased {
  func uppercased() {
    text = self.text?.uppercased()
  }
}

// Can't conform because it's restricted to UILabel only
//extension String: Uppercased {
//
//}

// All child protocols inherit requirements from parent protocol
// so in effect Immutable has two requirements
protocol ImmutableLocalizable: Localizable {
  func change(to language: Language) -> Self
}

protocol MutableLocalizable: Localizable {
  mutating func change(to language: Language)
}

struct Text: ImmutableLocalizable {
  
  var content = "Help"
  
  func change(to language: Language) -> Text {
    switch language {
      case .english: return Text(content: content)
      case .german: return Text(content: "Hilfe")
      case .spanish: return Text(content: "Ayuda")
    }
  }
  
  /// Localizable
  static var supportedLanguages: [Language] = [.english, .spanish]
}

extension UILabel: MutableLocalizable {
  
  /// Localizable
  static var supportedLanguages: [Language] = [.english, .german]
  
  func change(to language: Language) {
    switch language {
      case .english: text = "Help"
      case .german: text = "Hilfe"
      case .spanish: text = "Ayuda"
    }
  }
}

class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        let label = UILabel()
        label.frame = CGRect(x: 150, y: 200, width: 200, height: 20)
        label.text = "lets try this"
        label.uppercased()
        label.textColor = .black
        
        view.addSubview(label)
        self.view = view
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
