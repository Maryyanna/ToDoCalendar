//
//  ToDoListItem+CoreDataProperties.swift
//  ToDoCalendar
//
//  Created by Yana Morenko on 7/6/21.
//
//

import Foundation
import CoreData


extension ToDoListItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoListItem> {
        return NSFetchRequest<ToDoListItem>(entityName: "ToDoListItem")
    }

    @NSManaged public var createTimestamp: Date?
    @NSManaged public var modifiedTimestamp: Date?
    @NSManaged public var tags: String?
    @NSManaged public var type: String?
    @NSManaged public var name: String?
    @NSManaged public var content: String?

}

extension ToDoListItem : Identifiable {

}
