import UIKit
import Combine

var subscriptions = Set<AnyCancellable>()

example(of: "NotificationCenter") {
  let center = NotificationCenter.default
  let notification = Notification.Name("Combine")
  
  center
    .publisher(for: notification, object: nil)
    .print()
    .sink { note in
      print("Got \(note)")
    }.store(in: &subscriptions)
  
  center.post(name: notification, object: nil)
}


example(of: "Just") {
  Just("Hello World")
    .sink { completion in
      switch completion {
        case .finished:
          print("Just finished")
        case .failure(_):
          print("Just errored")
      }
    } receiveValue: { next in
      print("Just next -> \(next)")
    }.store(in: &subscriptions)
}

example(of: "assign(to:on:)") {
  
  final class Person {
    var name: String = "" {
      didSet {
        print(name)
      }
    }
  }
  
  let person = Person()
  
  ["Bruce", "Tony", "Thor", "Peter"]
    .publisher
    .assign(to: \.name, on: person)
    .store(in: &subscriptions)
}


example(of: "Passthrough") {
  let subject = PassthroughSubject<String, Never>()
  
  subject
    .sink { print("Next -> \($0)") }
    .store(in: &subscriptions)
  
  subject.send("Hello")
  sleep(2)
  subject.send("World")
  subject.send(completion: .finished)
  subject.send("Wont emit")
}

example(of: "PassThrough with Erase") {
  // You do the eraseToAnyPublisher to hide the underlying details of the publisher
  
  let subject = PassthroughSubject<[String], Never>()
  
  let publisher = subject.eraseToAnyPublisher()
  
  // So we know we can't send new values to it. Especially if this is a user facing property
}
