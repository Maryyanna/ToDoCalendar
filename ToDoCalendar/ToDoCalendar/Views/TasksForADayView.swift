//
//  TasksForADayView.swift
//  ToDoCalendar
//
//  Created by Yana Morenko on 7/7/21.
//

import Foundation
import SwiftUI

struct TasksForADay: View {
    
    let iconName : String
    let viewTitle : String
    
    @State var selectedDate : Date?
    @State private var value : CGFloat? //this is for keyboard management
    
    @StateObject private var taskListVM = TaskListViewModel()
    
    @State var newTaskString = ""
    
    init() {
        //there is a bug in XCode 12 that makes all nav and tab bars to appear yellow
        UINavigationBar.appearance().barTintColor = .systemBackground
        
        self.iconName = "sun.min.fill"
        self.viewTitle = "Today"
        
        
    }
    
    func deleteTask(at offsets: IndexSet) {
        offsets.forEach { index in
            let task = taskListVM.tasks[index]
            taskListVM.delete(task)
        }
        taskListVM.getAllTasks()
    }
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: iconName)
                Text("\(viewTitle)").font(.headline)
            }
            HStack {
                TextField("Enter task", text: $newTaskString)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .multilineTextAlignment(.leading)
                    .keyboardType(.default)
                //.modifier(TextFieldClearButton(text: "f"))
                Button("Save") {
                    taskListVM.title = newTaskString
                    taskListVM.save()
                    taskListVM.getAllTasks()
                    newTaskString = ""
                }
            }
            Spacer()
            List{
                ForEach(taskListVM.tasks, id: \.id) { task in
                    ToDoRow(todoItem: task)
                }
                .onDelete(perform: deleteTask)
            }
            .font(.system(size: 16, weight: .light))
            
        }//VStack
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
        }
        .onAppear(perform: {
            //get dat from coreData
            taskListVM.getAllTasks()
            //for keyboard handles
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { key in
                let valueCGRect = key.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                value = valueCGRect.height
            }
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { key in
                value = 0
            }
        })
        
    }
    
    struct TextFieldClearButton: ViewModifier {
        @Binding var text: String
        
        func body(content: Content) -> some View {
            HStack {
                content
                
                if !text.isEmpty {
                    Button(
                        action: { self.text = "" },
                        label: {
                            Image(systemName: "delete.left")
                                .foregroundColor(Color(UIColor.opaqueSeparator))
                        }
                    )
                }
            }
        }
    }

}

// extension for keyboard to dismiss
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


struct TasksForADay_Previews: PreviewProvider {
    static var previews: some View {
        TasksForADay()
    }
}
