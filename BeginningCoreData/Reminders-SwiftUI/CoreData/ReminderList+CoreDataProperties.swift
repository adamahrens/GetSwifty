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
//

import Foundation
import CoreData

extension ReminderList {

    // Hides Swift implementation to Objective-C
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ReminderList> {
        return NSFetchRequest<ReminderList>(entityName: "ReminderList")
    }

    @NSManaged public var title: String
    @NSManaged public var reminders: Array<Reminder>
  
  static func build(context: NSManagedObjectContext, title: String) -> ReminderList {
    let list = ReminderList(entity: ReminderList.entity(), insertInto: context)
    list.title = title
    return list
  }
}

// MARK: Generated accessors for reminders
extension ReminderList {

    @objc(insertObject:inRemindersAtIndex:)
    @NSManaged public func insertIntoReminders(_ value: Reminder, at idx: Int)

    @objc(removeObjectFromRemindersAtIndex:)
    @NSManaged public func removeFromReminders(at idx: Int)

    @objc(insertReminders:atIndexes:)
    @NSManaged public func insertIntoReminders(_ values: [Reminder], at indexes: NSIndexSet)

    @objc(removeRemindersAtIndexes:)
    @NSManaged public func removeFromReminders(at indexes: NSIndexSet)

    @objc(replaceObjectInRemindersAtIndex:withObject:)
    @NSManaged public func replaceReminders(at idx: Int, with value: Reminder)

    @objc(replaceRemindersAtIndexes:withReminders:)
    @NSManaged public func replaceReminders(at indexes: NSIndexSet, with values: [Reminder])

    @objc(addRemindersObject:)
    @NSManaged public func addToReminders(_ value: Reminder)

    @objc(removeRemindersObject:)
    @NSManaged public func removeFromReminders(_ value: Reminder)

    @objc(addReminders:)
    @NSManaged public func addToReminders(_ values: NSOrderedSet)

    @objc(removeReminders:)
    @NSManaged public func removeFromReminders(_ values: NSOrderedSet)

}

extension ReminderList : Identifiable {

}
