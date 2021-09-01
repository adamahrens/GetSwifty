//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport
import Combine

struct Preference<T>: CustomStringConvertible {
  let key: Preferences.PreferenceKey
  
  var value: T? {
    get {
      UserDefaults.standard.value(forKey: key.rawValue) as? T
    }
    
    set {
      UserDefaults.standard.setValue(newValue, forKey: key.rawValue)
    }
  }
  
  var description: String {
    "\(key.rawValue) -> \(String(describing: value))"
  }
}

final class Preferences {
  let supportedPreferences: [PreferenceKey] = [.audioVolume, .saveOffline]
  
  func preference<T>(for key : PreferenceKey) -> Preference<T> {
    return Preference(key: key)
  }
  
  enum PreferenceKey: String {
    case audioVolume
    case saveOffline
  }
}

let preferences = Preferences()

print(preferences.supportedPreferences)
let vol = preferences.preference(for: .audioVolume) as Preference<Float>
print(vol)

var volume = Preference<Float>(key: .audioVolume)
volume.value = 0.6

print(vol)

var saveOffline = Preference<Bool>(key: .saveOffline)
saveOffline.value = true

/// PATS (Protocols with Associated Types

protocol Request {
  associatedtype Model
  func fetch() -> AnyPublisher<Model, Error>
}

struct TextRequest: Request {
//  typealias Model = String
  
//  func fetch() -> AnyPublisher<Model, Error> {
//    Just("Hello World")
//      .setFailureType(to: Error.self)
//      .eraseToAnyPublisher()
//  }
  
  func fetch() -> AnyPublisher<String, Error> {
    Just("Hello World")
      .setFailureType(to: Error.self)
      .eraseToAnyPublisher()
  }
}


class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        let label = UILabel()
        label.frame = CGRect(x: 150, y: 200, width: 200, height: 20)
        label.text = "Hello World!"
        label.textColor = .black
        
        view.addSubview(label)
        self.view = view
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
