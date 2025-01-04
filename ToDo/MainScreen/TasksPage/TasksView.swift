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
    var searchFunc: ((String)->())
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color(0x102D53, alpha: 0.8))
                .frame(height: 42)
                .cornerRadius(5)
            
            HStack (spacing: 10) {
                ZStack(alignment: .leading) {
                    if text.isEmpty {
                        Text(placeholder)
                            .font(Font.custom(mainFontName, size: 12))
                            .foregroundColor(Color(0xFFFFFF, alpha: 0.6))
                    }
                    
                    TextField("", text: $text)
                        .disableAutocorrection(true)
                        .font(Font.custom(mainFontName, size: 12))
                        .foregroundStyle(Color(0xFFFFFF, alpha: 0.6))
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
    func addTask() {
        
    }
    
    func closeAddTasKView() {
        viewModel.showAddTaskView = false
        showTabBar = true
    }
    
    func openDatePicker() {
        
    }
    
    @ObservedObject var viewModel: TasksPageViewModel
    @Binding var showTabBar: Bool
    @FocusState var searchFieldFocused: Bool
    @State var newTaskTitle: String = ""
    @State var descriptionText: String = ""
    @FocusState var newTaskTitleFocused: Bool
    @FocusState var descriptionFocused: Bool
    
    var body: some View {
        ZStack {
            VStack {
                VStack (spacing: 45) {
                    SearchView(image: Image("search"), placeholder: "Search by task title", searchFunc: viewModel.filterTasks)
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
                                    TaskLabelView(viewModel: viewModel.showTasks[index])
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
                
            }.blur(radius: viewModel.showAddTaskView ? 5 : 0)
            
            if viewModel.showAddTaskView {
                VStack {
                    Spacer()
                    // AddTaskView
                    ZStack {
                        Rectangle()
                            .fill(.white)
                            .clipShape(.rect(topLeadingRadius: 20, topTrailingRadius: 20))
                            .ignoresSafeArea()
                            
                            
                        VStack {
                            // Task title
                            HStack {
                                ZStack {
                                    Rectangle()
                                        .fill(Color(0x05243E))
                                        .clipShape(RoundedRectangle(cornerRadius: 5))
                                        .frame(height: 42)
                                    
                                        
                                    HStack(spacing: 15) {
                                        Image("taskTitle")
                                            .resizable()
                                            .frame(width: 16, height: 14)
                                        ZStack(alignment: .leading) {
                                            if newTaskTitle.isEmpty {
                                                Text("task")
                                                    .font(Font.custom(mainFontName, size: 16))
                                                    .foregroundColor(Color(0xFFFFFF, alpha: 0.6))
                                            }
                                            
                                            TextField("", text: $newTaskTitle)
                                                .disableAutocorrection(true)
                                                .font(Font.custom(mainFontName, size: 16))
                                                .foregroundStyle(Color(0xFFFFFF, alpha: 0.6))
                                                .focused($newTaskTitleFocused)
                                        }
                                        Spacer()
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 14)
                                }
                            }
                            
                            // Description
                            MultilineTextFieldView(description: $descriptionText, image: Image("description"), backgroundColor: Color(0x05243E), foregroundColor: Color(0xFFFFFF, alpha: 0.6))
                                .focused($descriptionFocused)
                            
                            // Date and time pickers
                            HStack (spacing: 20) {
                                Button(action: openDatePicker) {
                                    ZStack {
                                        Rectangle()
                                            .fill(Color(0x05243E))
                                            .frame(height: 42)
                                            .clipShape(RoundedRectangle(cornerRadius: 5))
                                            
                                        HStack {
                                            Image("date")
                                                .resizable()
                                                .frame(width: 15, height: 14)
                                            Text("date")
                                                .font(Font.custom(mainFontName, size: 16))
                                                .foregroundStyle(.white)
                                            Spacer()
                                        }
                                        .padding()
                                        
                                    }
                                    
                                }
                                
                                Button(action: openDatePicker) {
                                    ZStack {
                                        Rectangle()
                                            .fill(Color(0x05243E))
                                            .frame(height: 42)
                                            .clipShape(RoundedRectangle(cornerRadius: 5))
                                        HStack {
                                            Image("time")
                                                .resizable()
                                                .frame(width: 14, height: 13)
                                            Text("time")
                                                .font(Font.custom(mainFontName, size: 16))
                                                .foregroundStyle(.white)
                                            Spacer()
                                        }
                                        .padding()
                                        
                                    }
                                    
                                }
                            }
                            
                            // Buttons
                            HStack (spacing: 20) {
                                Button(action: closeAddTasKView) {
                                    ZStack {
                                        Rectangle()
                                            .stroke(Color(0x0EA5E9), lineWidth: 4)
                                            .frame(height: 45)
                                            .clipShape(RoundedRectangle(cornerRadius: 5))
                                            
                                        Text("close")
                                            .font(Font.custom(mainFontName, size: 16))
                                            .foregroundStyle(.black)
                                    }
                                    
                                }
                                
                                Button(action: addTask) {
                                    ZStack {
                                        Rectangle()
                                            .fill(Color(0x0EA5E9))
                                            .frame(height: 45)
                                            .clipShape(RoundedRectangle(cornerRadius: 5))
                                            
                                        Text("create")
                                            .font(Font.custom(mainFontName, size: 16))
                                            .foregroundStyle(.black)
                                    }
                                    
                                }
                            }
                            
                            Spacer()
                            
                        }
                        .padding(.top, 55)
                        .padding(.horizontal, 25)
                        
                    }
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2 )
                    .transition(.move(edge: .bottom))
                    
                }
            }
        }
        .onTapGesture {
            searchFieldFocused = false
            newTaskTitleFocused = false
            descriptionFocused = false
        }
        
    }
    
}
