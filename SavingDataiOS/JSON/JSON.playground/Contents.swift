//: A UIKit based Playground for presenting user interface
  
import UIKit
import Combine
import PlaygroundSupport

/// Codable handles the decoding/encoding for you
/// assuming all types can be decoded/encoded
struct Task: Identifiable, Codable, CustomDebugStringConvertible {
  var debugDescription: String {
   return "Task: \(id) - \(name) - \(completed)"
  }
  
  var id = UUID()
  let name: String
  let completed: Bool
  
  enum CodingKeys: String, CodingKey {
    case id = "uuid"
    case name
    case completed = "isDone"
  }
}

extension Task {
  enum Priority: String, CaseIterable, Codable {
    case no, low, medium, high
  }
}

extension TaskStore {
  struct PrioritizedTasks: Codable, CustomDebugStringConvertible {
    var debugDescription: String {
      return "Priority \(priority).\(tasks)"
    }
    
    let priority: Task.Priority
    var tasks: [Task]
  }
}

extension TaskStore.PrioritizedTasks: Identifiable {
  var id: Task.Priority { priority }
}

private extension TaskStore.PrioritizedTasks {
  init(priority: Task.Priority, names: [String]) {
    self.init(
      priority: priority,
      tasks: names.map { Task(name: $0, completed: false) }
    )
  }
}

extension FileManager {
  static var documentsDirectoryURL: URL {
    return `default`.urls(for: .documentDirectory, in: .userDomainMask)[0]
  }
}

final class TaskStore: ObservableObject {
  @Published var prioritizedTasks = [PrioritizedTasks]()
  
  /// JSON Filename for writing/reading to
  private let storeFilename = "PrioritizedTasks"
  
  /// Full Filename for Saving
  private var fileURL: URL {
    let pathExtension = "json"
    let url = (FileManager.documentsDirectoryURL.appendingPathComponent(storeFilename)).appendingPathExtension(pathExtension)
    print(url.absoluteString)
    return url
  }
  
  /**
   Adds a random Task
   */
  func add() {
    prioritizedTasks.append(PrioritizedTasks(priority: .no, names: ["Walk the dog"]))
    save()
  }
  
  /**
   Saves all changes to JSON file in documents directory
   */
  func save() {
//    print("Bundle url is \(Bundle.main.bundleURL)")
    
    // This lives longer. iOS won't purge it
    print("FileManager documentsDirectory is \(FileManager.documentsDirectoryURL)")
    
    // iOS Can purge this directory at any time
//    print("FileManager Temp \(FileManager.default.temporaryDirectory)")
    
    // Get encoder
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    
    if let data = try? encoder.encode(prioritizedTasks) {
      do {
        print("Writing to \(fileURL.absoluteString)")
        try data.write(to: fileURL, options: .atomicWrite)
        print("Successfully written to file")
      } catch {
        print("Unable to write to file \(error)")
      }
    } else {
      fatalError("Unable to encode prioritzedTasks")
    }
  }
  
  /** Loads JSON data and stores in @Published property */
  func load() {
//    print("Bundle url is \(Bundle.main.bundleURL)")
    
    // This lives longer. iOS won't purge it
//    print("FileManager documentsDirectory is \(FileManager.documentsDirectoryURL)")
    
    // iOS Can purge this directory at any time
//    print("FileManager Temp \(FileManager.default.temporaryDirectory)")
    
    guard
      let priorityTasksJsonUrl = Bundle.main.url(forResource: "PrioritizedTask", withExtension: "json")
    else {
      fatalError("Unable to find the JSON files you need")
    }
    
    // Decode them
    let decoder = JSONDecoder()
    
    // Prioritied Decoding
    if let priorityData = try? Data(contentsOf: priorityTasksJsonUrl),
       let prioritizedTasks = try? decoder.decode(TaskStore.PrioritizedTasks.self, from: priorityData) {
      self.prioritizedTasks = [prioritizedTasks]
    } else {
      fatalError("Unable to load data or decode to model")
    }
  }
}

final class MyViewController : UIViewController {
  override func loadView() {
    let view = UIView()
    view.backgroundColor = .white
    
    let label = UILabel()
    label.frame = CGRect(x: 150, y: 200, width: 200, height: 20)
    label.text = "Hello World!"
    label.textColor = .black
    
    let button = UIButton(primaryAction: UIAction(title: "Add Task") { [weak self] _ in
      print("Should add a random task & save")
      self?.store.add()
      self?.store.save()
    })
    
    button.titleLabel?.textColor = .blue
    button.frame = CGRect(x: 150, y: 240, width: 200, height: 64)
    view.addSubview(label)
    view.addSubview(button)
    self.view = view
  }
  
  private let store = TaskStore()
  private var subscriptions = Set<AnyCancellable>()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    store
      .$prioritizedTasks
      .sink { prioritizedTasks in
        print("Got new prioritized tasks \(prioritizedTasks)")
      }.store(in: &subscriptions)
  
//    loadTasksJSON()
    
    store.load()
  }
  
  /**
   Loads JSON files to be decoded
   */
  private func loadTasksJSON() {
    guard
      let taskJsonUrl = Bundle.main.url(forResource: "Task", withExtension: "json"),
      let priorityTasksJsonUrl = Bundle.main.url(forResource: "PrioritizedTask", withExtension: "json")
    else {
      fatalError("Unable to find the JSON files you need")
    }
    
    // Decode them
    let decoder = JSONDecoder()
    
    // Task Decoding
    if let tasksData = try? Data(contentsOf: taskJsonUrl),
       let task = try? decoder.decode(Task.self, from: tasksData) {
      print("Success! Decoded file to \(task)")
    } else {
      fatalError("Unable to load data or decode to model")
    }
    
    // Prioritied Decoding
    if let priorityData = try? Data(contentsOf: priorityTasksJsonUrl),
       let tasks = try? decoder.decode(TaskStore.PrioritizedTasks.self, from: priorityData) {
      print("Success! Decoded file to \(tasks)")
    } else {
      fatalError("Unable to load data or decode to model")
    }
  }
}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
