//
//  CoreDataManager.swift
//  ToDoCalendar
//
//  Created by Yana Morenko on 7/6/21.
//

import Foundation
import CoreData

class CoreDataManager {
    
    let persistentContainer: NSPersistentContainer
    static let shared = CoreDataManager()
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func getTaskById(id: NSManagedObjectID) -> Task? {
        
        do {
            return try viewContext.existingObject(with: id) as? Task
        } catch {
            return nil
        }
        
    }
    
    func deleteTask(task: Task) {
        
        viewContext.delete(task)
        save()
        
    }
    
    func getAllTasks() -> [Task] {
        
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        
        do {
            return try viewContext.fetch(request)
        } catch {
            return []
        }
        
    }
    
    func save() {
        print("CoreDataManager save")
        do {
            try viewContext.save()
        } catch {
            viewContext.rollback()
            print(error.localizedDescription)
        }
    }
    
    
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "ToDoCalendar")
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Unable to initialize Core Data Stack \(error)")
            }
        }
        
    }
    /*
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "ToDoCalendar")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
     */
}
