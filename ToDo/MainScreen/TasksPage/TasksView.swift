//
//  TasksView.swift
//  ToDo
//
//  Created by Леонид Шайхутдинов on 03.01.2025.
//

import SwiftUI

struct SearchView: View {
    @State var image: Image
    @State var placeholder: String
    @State var isSecure: Bool = false
    @State var text = ""
    var backgroundColor: Color
    var foregroundColor: Color
    var searchFunc: ((String)->())
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(backgroundColor)
                .frame(height: 42)
                .cornerRadius(5)
            
            HStack (spacing: 10) {
                ZStack(alignment: .leading) {
                    if text.isEmpty {
                        Text(placeholder)
                            .font(Font.custom(mainFontName, size: 12))
                            .foregroundColor(foregroundColor)
                    }
                    
                    TextField("", text: $text)
                        .disableAutocorrection(true)
                        .font(Font.custom(mainFontName, size: 12))
                        .foregroundStyle(foregroundColor)
                }
                
                Spacer()
                
                Button (action: {
                    searchFunc(text)
                })
                {
                    image
                        .resizable()
                        .frame(width: 17, height: 17)
                }
                
            }
            .padding(.horizontal, 10)
            }
        }
}

struct TasksView: View {
    func closeAddTasKView() {
        viewModel.showAddTaskView = false
        showTabBar = true
    }
    
    @State private var showDatePicker = false
    @ObservedObject var viewModel: TasksPageViewModel
    @Binding var showTabBar: Bool
    @FocusState var searchFieldFocused: Bool
    @FocusState var taskFormTitleFocused: Bool
    @FocusState var taskFormDescriptionFocused: Bool
    @State var date: Date = Date()
    @State var time: Date = Date()
    @State var taskViewModel: TaskViewModel?
    
    @State private var keyboardOffset: CGFloat = 0
    
    @State var isShowTaskView: Bool = false
    
    func showTaskView(viewModel: TaskViewModel) {
        taskViewModel = viewModel
        isShowTaskView = true
        showTabBar = true
    }

    func closeTaskView() {
        isShowTaskView = false
        viewModel.fetchTasks()
    }
    
    var body: some View {
        ZStack {
            backgroundGradient
                .ignoresSafeArea()
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            VStack {
                VStack (spacing: 45) {
                    SearchView(image: Image("search"), placeholder: "Search by task title", backgroundColor: Color(0x102D53, alpha: 0.8), foregroundColor: Color(0xFFFFFF, alpha: 0.6), searchFunc: viewModel.filterTasks)
                        .focused($searchFieldFocused)
                    VStack {
                        HStack {
                            Text("Tasks List")
                                .font(Font.custom(mainFontName, size: 14))
                                .foregroundStyle(.white)
                            Spacer()
                        }
                        
                        ScrollView {
                            VStack {
                                ForEach(viewModel.showTasks.indices, id: \.self) { index in
                                    TaskLabelView(viewModel: viewModel.showTasks[index], showTaskView: showTaskView)
                                }
                            }
                        }
                        
                        HStack {
                            Spacer()
                            Button(action: {
                                viewModel.showAddTaskView = true
                                showTabBar = false
                                print("showAddtask")
                            }) {
                                ZStack {
                                    Circle()
                                        .frame(width: 50, height: 50)
                                        .foregroundStyle(Color(0x63D9F3))
                                    Image(systemName: "plus")
                                        .resizable()
                                        .frame(width: 17, height: 17)
                                        .bold()
                                        .foregroundStyle(.white)
                                }
                            }
                        }
                    }
                    Spacer()
                        
                }
                .padding(.horizontal, 18)
                .padding(.top, 45)
                .padding(.bottom, 40)
                
            }
            .blur(radius: viewModel.showAddTaskView ? 5 : 0)
            
            if viewModel.showAddTaskView {
                
                VStack {
                    if (!taskFormTitleFocused && !taskFormDescriptionFocused) {
                        Spacer()
                    }
                    
                    TaskFormView(viewModel: TaskViewModel(user: viewModel.user, databaseManager: viewModel.databaseManager), newTaskTitleFocused: $taskFormTitleFocused, newTaskDescriptionFocused: $taskFormDescriptionFocused, confirmButtonText: "create", action: .create, updateTasks: viewModel.fetchTasks, closeFunc: closeAddTasKView)
                        
                    
                    if (taskFormTitleFocused || taskFormDescriptionFocused) {
                        Spacer()
                    }
                }
            }
            
            if isShowTaskView, let taskViewModel = taskViewModel {
                TaskView(viewModel: taskViewModel, newTaskTitleFocused: $taskFormTitleFocused, descriptionFocused: $taskFormDescriptionFocused, close: closeTaskView)
            }
        }
        .onAppear {
            viewModel.fetchTasks()
        }
        
    
    }
    
}

