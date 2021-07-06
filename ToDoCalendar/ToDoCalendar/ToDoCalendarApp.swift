//
//  ToDoCalendarApp.swift
//  ToDoCalendar
//
//  Created by Yana Morenko on 7/5/21.
//

import SwiftUI

@main
struct ToDoCalendarApp: App {
    
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
