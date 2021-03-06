//
//  TaskListViewModel.swift
//  ToDoCalendar
//
//  Created by Yana Morenko on 7/6/21.
//

import Foundation
import CoreData

class TaskListViewModel: ObservableObject {
    
    var title: String = ""
    
    @Published var tasks: [TaskViewModel] = []
    
    func getAllTasks() {
        tasks = CoreDataManager.shared.getAllTasks().map(TaskViewModel.init)
    }
    
    func delete(_ task: TaskViewModel) {
        
        let existingTask = CoreDataManager.shared.getTaskById(id: task.id)
        if let existingTask = existingTask {
            CoreDataManager.shared.deleteTask(task: existingTask)
        }
    }
    
    func save() {
        let task = Task(context: CoreDataManager.shared.viewContext)
        task.title = title
        CoreDataManager.shared.save()
        print(task)
    }
    
}

struct TaskViewModel {
    
    let task: Task

    var id: NSManagedObjectID {
        return task.objectID
    }

    var title: String {
        return task.title ?? "unspecified title"
    }
    
    var finished: Bool {
        if task.finishTimestamp != nil { return true }
        return false
    }
    
    func changeFinishStatus() {
        if task.finishTimestamp != nil {
            task.finishTimestamp = nil
        }
        else {
            task.finishTimestamp = Date()
        }
        CoreDataManager.shared.save()
        print("changeFinishStatus")
    }
    
}
