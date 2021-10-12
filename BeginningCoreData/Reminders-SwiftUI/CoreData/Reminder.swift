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

import CoreData
import SwiftUI

/// Class

@objc(Reminder)
public class Reminder: NSManagedObject {
  
}

/// Properties

extension Reminder {
  
  enum Sort {
    case title(Bool)
    case priority(Bool)
    
    func sortDescriptor() -> NSSortDescriptor {
      switch self {
        case .title(let value) : return NSSortDescriptor(key: "title", ascending: value)
        case .priority(let value): return NSSortDescriptor(key: "priority", ascending: value)
      }
    }
  }
  
  @NSManaged var title: String
  @NSManaged var isCompleted: Bool
  @NSManaged var priority: Int16
  @NSManaged var dueDate: Date?
  @NSManaged var notes: String?
  
  static func build(context: NSManagedObjectContext, title: String, priority: Int16, dueDate: Date?, notes: String?) -> Reminder {
    let reminder = Reminder(entity: Reminder.entity(), insertInto: context)
    reminder.title = title
    reminder.notes = notes
    reminder.dueDate = dueDate
    reminder.priority = priority
    return reminder
  }
  
  static func all(sorts: [Reminder.Sort] = []) -> NSFetchRequest<Reminder> {
    let request = NSFetchRequest<Reminder>(entityName: "Reminder")
    let allSorts: [Reminder.Sort] = sorts.count == 0 ? [.priority(false), .title(false), ] : sorts
    request.sortDescriptors = allSorts.map { $0.sortDescriptor() }
    return request
  }
  
  static func uncomplete(sorts: [Reminder.Sort] = []) -> NSFetchRequest<Reminder> {
    let request = NSFetchRequest<Reminder>(entityName: "Reminder")
    let predicate = NSPredicate(format: "%K == %@", "isCompleted", NSNumber(value: false))
    request.predicate = predicate
    let allSorts: [Reminder.Sort] = sorts.count == 0 ? [.priority(false), .title(false), ] : sorts
    request.sortDescriptors = allSorts.map { $0.sortDescriptor() }
    return request
  }
  
  static func completed(sorts: [Reminder.Sort] = []) -> NSFetchRequest<Reminder> {
    let request = NSFetchRequest<Reminder>(entityName: "Reminder")
    let predicate = NSPredicate(format: "%K == %@", "isCompleted", NSNumber(value: true))
    request.predicate = predicate
    let allSorts: [Reminder.Sort] = sorts.count == 0 ? [.priority(false), .title(false), ] : sorts
    request.sortDescriptors = allSorts.map { $0.sortDescriptor() }
    return request
  }
}
