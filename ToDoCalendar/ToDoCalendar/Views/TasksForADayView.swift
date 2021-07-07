//
//  TasksForADayView.swift
//  ToDoCalendar
//
//  Created by Yana Morenko on 7/7/21.
//

import Foundation
import SwiftUI

struct ToDoRow: View {
    var todoItem: TaskViewModel
    
    @State var taskFinished : Bool = false
    
    var body: some View {
        HStack{
            if taskFinished {
                Text("\(todoItem.title)")
                    .strikethrough()
            }
            else {
                Text("\(todoItem.title)") 
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .onAppear(perform: {
            taskFinished = todoItem.finished
        })
        .onTapGesture {
            todoItem.changeFinishStatus()
            print("clicked task \(todoItem.title)")
            taskFinished = todoItem.finished
        }
        
            
    }
    
}


struct TasksForADay: View {
    
    let iconName : String = "sun.min.fill"
    @State var viewTitle : String = ""
    @Binding var tasksForADayDate : Date
    @State private var value : CGFloat? //this is for keyboard management
    
    @StateObject private var taskListVM = TaskListViewModel()
    
    @State var newTaskString = ""
    
    func setTitle() {
        print("TasksForADay setTitle tasksForADayDate \(String(describing: self.tasksForADayDate)) title \(String(describing: viewTitle))")
        let thisDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: tasksForADayDate )!
        let today = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM y"
        viewTitle = dateFormatter.string(from: tasksForADayDate )
        if (thisDate == today) {
            viewTitle = "Today"
        }
        else if (thisDate == tomorrow) {
            viewTitle = "Tomorrow"
        }
        else if (thisDate == yesterday) {
           viewTitle = "Yesterday"
        }
        print("TasksForADay setTitle end selectedDate \(String(describing: tasksForADayDate)) title \(String(describing: self.viewTitle))")
        
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
                    //do not save empty string
                    if newTaskString.count > 0 {
                        taskListVM.title = newTaskString
                        taskListVM.save()
                        taskListVM.getAllTasks()
                        newTaskString = ""
                    }
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
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
            setTitle()
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

//#if DEBUG
//struct TasksForADay_Previews: PreviewProvider {
//    static var previews: some View {
//        TasksForADay(selectedDate: nil)
//    }
//}
//#endif

