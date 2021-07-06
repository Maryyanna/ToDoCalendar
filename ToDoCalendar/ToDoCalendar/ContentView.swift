//
//  ContentView.swift
//  ToDoCalendar
//
//  Created by Yana Morenko on 7/5/21.
//

import SwiftUI

struct ToDoRow: View {
    var todoItem: TaskViewModel
    var body: some View {
        Text("\(todoItem.title)")
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}


struct ContentView: View {
    
    //tabBarImageNames come from SF Symbols
    let tabBarImageNames = ["person", "sun.min.fill", "lasso", "pencil"]
    let tabBarTitles = ["Settings", "Today", "Recurring", "Add"]
    
    @StateObject private var taskListVM = TaskListViewModel()
    //var todoItemList = [ToDoItem]()
    
    @State var selectedTabIndex = 1
    @State var shouldShowFullScreenCover = false

    func deleteTask(at offsets: IndexSet) {
        offsets.forEach { index in
            let task = taskListVM.tasks[index]
            taskListVM.delete(task)
        }
        taskListVM.getAllTasks()
    }
    
    init() {
        //there is a bug in XCode 12 that makes all nav and tab bars to appear yellow
        UITabBar.appearance().barTintColor = .systemBackground
        UINavigationBar.appearance().barTintColor = .systemBackground
        
    }
    
    var body: some View {
        // //native Tab View
        //TabView {
        //    Text("First")
        //        .tabItem {
        //            Image(systemName: "person")
        //            Text("First")
        //        }
        //    Text("Second")
        //        .tabItem {
        //            Image(systemName: "gear")
        //            Text("Second")
        //        }
        //}
        
        VStack(spacing: 0) {
            
            Spacer()
                .fullScreenCover(isPresented: $shouldShowFullScreenCover, content: {
                    Button(action: {
                                shouldShowFullScreenCover.toggle()
                        
                            }, label: {
                                Text("Fullscreen cover")
                            })
                
                })
            
            //Views in Tab bar
            ZStack {
                
                switch selectedTabIndex {
                case 0:
                    NavigationView {
                        ScrollView {
                            ForEach(0..<100) { num in
                                Text("\(num)")
                            }
                        }
                            .navigationTitle("Will Never See It")
                    }
                    
                case 1:
                    //NavigationView
                    VStack{
                        HStack {
                            TextField("Enter task name", text: $taskListVM.title)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            Button("Save") {
                                taskListVM.save()
                                taskListVM.getAllTasks()
                            }
                        }
                        Spacer()
                        List{
                            ForEach(taskListVM.tasks, id: \.id) { task in
                                //ToDoRow(todoItem: task)
                                Text("\(task.title)")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .onDelete(perform: deleteTask)
                        }
                            
                            .font(.system(size: 16, weight: .light))
                            //.navigationTitle(tabBarTitles[selectedTabIndex])
                            .navigationBarTitleDisplayMode(.inline)
                            .toolbar {
                                ToolbarItem(placement: .principal) {
                                    HStack {
                                        Image(systemName: tabBarImageNames[selectedTabIndex])
                                        Text("\(tabBarTitles[selectedTabIndex])").font(.headline)
                                    }
                                }
                            }
                    }
                
                case 2:
                    ScrollView {
                        Text("\(tabBarTitles[selectedTabIndex])")
                    }
                    
                case 3:
                    ScrollView {
                        Text("\(tabBarTitles[selectedTabIndex])")
                    }
                    
                default:
                    NavigationView {
                        Text("Remaining tab \(selectedTabIndex)")
                        
                    }
                }
                
            }//ZStack
            .padding()
            
            //Spacer()
            Divider()
                .padding(.bottom, 12)
            
            
            //This is for TabBar
            HStack {
                ForEach(0..<tabBarImageNames.count) { num in
                    Button(action: {
                        
                        if num == 0 {
                            shouldShowFullScreenCover.toggle()
                            return
                        }
                        
                        selectedTabIndex = num
                    }, label: {
                        Spacer()
                        
                        if tabBarTitles[num] == "Add" {
                            Image(systemName: tabBarImageNames[num])
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.red)
                        } else {
                            VStack(spacing: 0) {
                                Image(systemName: tabBarImageNames[num])
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(selectedTabIndex == num ? Color(.label) : .init(white: 0.7))
                                Text(tabBarTitles[num])
                                    .font(.system(size: 12, weight: .bold, design: .default))
                            }
                        }
                        
                        
                        Spacer()
                    })
                    
                }
                .onDelete(perform: deleteTask)
                
            }
            
            
        }//VStack
        .onAppear(perform: {
            taskListVM.getAllTasks()
            Print(taskListVM.tasks.count)
            print("onAppear")
        })

    }
    
    
    
}

extension View {
    func Print(_ vars: Any...) -> some View {
        for v in vars { print(v) }
        return EmptyView()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
