//
//  ToDoListItem+CoreDataProperties.swift
//  ToDoCalendar
//
//  Created by Yana Morenko on 7/6/21.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "ToDoListItem")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var createTimestamp: Date?
    @NSManaged public var modifiedTimestamp: Date?
    @NSManaged public var tags: String?
    @NSManaged public var type: String?
    @NSManaged public var title: String?
    @NSManaged public var content: String?
    @NSManaged public var dueDate: Date?
}

extension Task : Identifiable {

}
